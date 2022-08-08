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
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        importJSONSeedDataIfNeeded()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == filterViewControllerSegueIdentifier {
            //
        }
    }
    
    // MARK: - IBActions
    @IBAction func unwindToVenueListViewController(_ segue: UIStoryboardSegue) {
        //
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

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: venueCellIdentifier, for: indexPath)
        cell.textLabel?.text = "Bubble Tea Venue"
        cell.detailTextLabel?.text = "Price Info"
        return cell
    }
}
