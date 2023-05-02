//
//  MainViewController.swift
//  BubbleTea
//
//  Created by Stanislav Lemeshaev on 03.08.2022.
//  Copyright © 2022 slemeshaev. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    // MARK: - Properties
    private let filterViewControllerSegueIdentifier = "toFilterViewController"
    private let venueCellIdentifier = "VenueCell"
    
    private lazy var coreDataStack = CoreDataStack(modelName: "BubbleTea")
    
    private var fetchRequest: NSFetchRequest<Venue>?
    private var asyncFetchRequest: NSAsynchronousFetchRequest<Venue>?
    
    private var venues: [Venue] = []
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        importJSONSeedDataIfNeeded()
        fetchRequest = Venue.fetchRequest()
        reloadVenues()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == filterViewControllerSegueIdentifier,
              let navigationController = segue.destination as? UINavigationController,
              let filterViewController = navigationController.topViewController as? FilterViewController else {
            return
        }
        
        filterViewController.coreDataStack = coreDataStack
        filterViewController.delegate = self
    }
    
    // MARK: - IBActions
    @IBAction private func unwindToVenueListViewController(_ segue: UIStoryboardSegue) {
    }
    
    // MARK: - Private
    private func importJSONSeedDataIfNeeded() {
        let fetchRequest = NSFetchRequest<Venue>(entityName: "Venue")
        let count = try! coreDataStack.managedContext.count(for: fetchRequest)
        
        guard count == 0 else { return }
        
        do {
            let results = try coreDataStack.managedContext.fetch(fetchRequest)
            results.forEach { coreDataStack.managedContext.delete($0) }
            
            coreDataStack.saveContext()
            importJSONSeedData()
        } catch let error as NSError {
            print("Error fetching: \(error), \(error.userInfo)")
        }
    }
    
    private func prepareButchUpdate() {
        let batchUpdate = NSBatchUpdateRequest(entityName: "Venue")
        batchUpdate.propertiesToUpdate = [#keyPath(Venue.favorite): true]
        
        batchUpdate.affectedStores = coreDataStack.managedContext.persistentStoreCoordinator?.persistentStores
        batchUpdate.resultType = .updatedObjectsCountResultType
        
        do {
            let batchResult = try coreDataStack.managedContext.execute(batchUpdate) as! NSBatchUpdateResult
            print("Records updated \(String(describing: batchResult.result))")
        } catch let error as NSError {
            print("Could not update \(error), \(error.userInfo)")
        }
    }
    
    private func prepareAsyncFetchRequest() {
        let venueFetchRequest: NSFetchRequest<Venue> = Venue.fetchRequest()
        fetchRequest = venueFetchRequest
        
        asyncFetchRequest = NSAsynchronousFetchRequest<Venue>(fetchRequest: venueFetchRequest) { [unowned self] (result: NSAsynchronousFetchResult) in
            guard let venues = result.finalResult else { return }
            
            self.venues = venues
            self.tableView.reloadData()
        }
        
        do {
            guard let asyncFetchRequest = asyncFetchRequest else { return }
            try coreDataStack.managedContext.execute(asyncFetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    private func prepareFetchRequest() {
        guard let model = coreDataStack.managedContext.persistentStoreCoordinator?.managedObjectModel,
              let fetchRequest = model.fetchRequestTemplate(forName: "FetchRequest") as? NSFetchRequest<Venue> else {
            return
        }
        
        self.fetchRequest = fetchRequest
    }
    
    private func reloadVenues() {
        guard let fetchRequest = fetchRequest else {
            return
        }
        
        do {
            venues = try coreDataStack.managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: venueCellIdentifier, for: indexPath)
        let venue = venues[indexPath.row]
        
        cell.textLabel?.text = venue.name
        cell.detailTextLabel?.text = venue.priceInfo?.priceCategory
        return cell
    }
}

// MARK: - FilterViewControllerDelegate
extension MainViewController: FilterViewControllerDelegate {
    func filterViewController(filter: FilterViewController,
                              didSelectPredicate predicate: NSPredicate?,
                              sortDescriptor: NSSortDescriptor?) {
        guard let fetchRequest = fetchRequest else {
            return
        }
        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = nil
        
        fetchRequest.predicate = predicate
        
        if let sortDescriptor = sortDescriptor {
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        reloadVenues()
    }
}

// MARK: - Helper methods
extension MainViewController {
    private func importJSONSeedData() {
        let jsonURL = Bundle.main.url(forResource: "Seed", withExtension: "json")!
        let jsonData = try! Data(contentsOf: jsonURL)
        
        let jsonDict = try! JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) as! [String: Any]
        let responseDict = jsonDict["response"] as! [String: Any]
        let jsonArray = responseDict["venues"] as! [[String: Any]]
        
        for jsonDictionary in jsonArray {
            let venueName = jsonDictionary["name"] as? String
            let contactDict = jsonDictionary["contact"] as! [String: String]
            
            let venuePhone = contactDict["phone"]
            
            let specialsDict = jsonDictionary["specials"] as! [String: Any]
            let specialCount = specialsDict["count"] as? NSNumber
            
            let locationDict = jsonDictionary["location"] as! [String: Any]
            let priceDict = jsonDictionary["price"] as! [String: Any]
            let statsDict =  jsonDictionary["stats"] as! [String: Any]
            
            let location = Location(context: coreDataStack.managedContext)
            location.address = locationDict["address"] as? String
            location.city = locationDict["city"] as? String
            location.state = locationDict["state"] as? String
            location.zipcode = locationDict["postalCode"] as? String
            let distance = locationDict["distance"] as? NSNumber
            location.distance = distance!.floatValue
            
            let category = Category(context: coreDataStack.managedContext)
            
            let priceInfo = PriceInfo(context: coreDataStack.managedContext)
            priceInfo.priceCategory = priceDict["currency"] as? String
            
            let stats = Stats(context: coreDataStack.managedContext)
            let checkins = statsDict["checkinsCount"] as? NSNumber
            stats.checkinsCount = checkins!.int32Value
            let tipCount = statsDict["tipCount"] as? NSNumber
            stats.tipCount = tipCount!.int32Value
            
            let venue = Venue(context: coreDataStack.managedContext)
            venue.name = venueName
            venue.phone = venuePhone
            venue.specialCount = specialCount!.int32Value
            venue.location = location
            venue.category = category
            venue.priceInfo = priceInfo
            venue.stats = stats
        }
        
        coreDataStack.saveContext()
    }
}
