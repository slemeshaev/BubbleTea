//
//  FilterViewController.swift
//  BubbleTea
//
//  Created by Stanislav Lemeshaev on 09.08.2022.
//  Copyright © 2022 slemeshaev. All rights reserved.
//

import UIKit
import CoreData

class FilterViewController: UITableViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var firstPriceCategoryLabel: UILabel!
    @IBOutlet private weak var secondPriceCategoryLabel: UILabel!
    @IBOutlet private weak var thirdPriceCategoryLabel: UILabel!
    @IBOutlet private weak var numDealsLabel: UILabel!
    
    @IBOutlet private weak var cheapVenueCell: UITableViewCell!
    @IBOutlet private weak var moderateVenueCell: UITableViewCell!
    @IBOutlet private weak var expensiveVenueCell: UITableViewCell!
    
    @IBOutlet private weak var offeringDealCell: UITableViewCell!
    @IBOutlet private weak var walkingDistanceCell: UITableViewCell!
    @IBOutlet private weak var userTipsCell: UITableViewCell!
    
    @IBOutlet private weak var nameAZSortCell: UITableViewCell!
    @IBOutlet private weak var nameZASortCell: UITableViewCell!
    @IBOutlet private weak var distanceSortCell: UITableViewCell!
    @IBOutlet private weak var priceSortCell: UITableViewCell!
    
    // MARK: - Properties
    var coreDataStack: CoreDataStack!
    
    private lazy var cheapVenuePredicate: NSPredicate = {
        return NSPredicate(format: "%K == %@", #keyPath(Venue.priceInfo.priceCategory), "$")
    }()
    
    private lazy var moderateVenuePredicate: NSPredicate = {
        return NSPredicate(format: "%K == %@", #keyPath(Venue.priceInfo.priceCategory), "$$")
    }()
    
    private lazy var expensiveVenuePredicate: NSPredicate = {
        return NSPredicate(format: "%K == %@", #keyPath(Venue.priceInfo.priceCategory), "$$$")
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        populateCheapVenueCountLabel()
        populateModerateVenueCountLabel()
        populateExpensiveVenueCountLabel()
        populateDealsCountLabel()
    }
    
    // MARK: - IBActions
    @IBAction private func search(_ sender: UIBarButtonItem) {
        print(#function)
    }
}

// MARK: - UITableViewDelegate
extension FilterViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
}

// MARK: - Helper methods
extension FilterViewController {
    func populateCheapVenueCountLabel() {
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Venue")
        fetchRequest.resultType = .countResultType
        fetchRequest.predicate = cheapVenuePredicate
        
        do {
            let countResult = try coreDataStack.managedContext.fetch(fetchRequest)
            let count = countResult.first!.intValue
            let pluralised = count == 1 ? "place" : "places"
            firstPriceCategoryLabel.text = "\(count) bubble tea \(pluralised)"
        } catch let error as NSError {
            print("Count not fetched \(error), \(error.userInfo)")
        }
    }
    
    func populateModerateVenueCountLabel() {
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Venue")
        fetchRequest.resultType = .countResultType
        fetchRequest.predicate = moderateVenuePredicate
        
        do {
            let countResult = try coreDataStack.managedContext.fetch(fetchRequest)
            let count = countResult.first!.intValue
            let pluralised = count == 1 ? "place" : "places"
            secondPriceCategoryLabel.text = "\(count) bubble tea \(pluralised)"
        } catch let error as NSError {
            print("Count not fetched \(error), \(error.userInfo)")
        }
    }
    
    func populateExpensiveVenueCountLabel() {
        let fetchRequest: NSFetchRequest<Venue> = Venue.fetchRequest()
        fetchRequest.predicate = expensiveVenuePredicate
        
        do {
            let count = try coreDataStack.managedContext.count(for: fetchRequest)
            let pluralised = count == 1 ? "place" : "places"
            thirdPriceCategoryLabel.text = "\(count) bubble tea \(pluralised)"
        } catch let error as NSError {
            print("Count not fetched \(error), \(error.userInfo)")
        }
    }
    
    func populateDealsCountLabel() {
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Venue")
        fetchRequest.resultType = .dictionaryResultType
        
        let sumExpressionDesc = NSExpressionDescription()
        sumExpressionDesc.name = "sumDeals"
        
        let specialCountExpression = NSExpression(forKeyPath: #keyPath(Venue.specialCount))
        sumExpressionDesc.expression = NSExpression(forFunction: "sum:",
                                                    arguments: [specialCountExpression])
        sumExpressionDesc.expressionResultType = .integer32AttributeType
        
        fetchRequest.propertiesToFetch = [sumExpressionDesc]
        
        do {
            let results = try coreDataStack.managedContext.fetch(fetchRequest)
            let resultDictionary = results.first!
            let numberDeals = resultDictionary["sumDeals"] as! Int
            let pluralised = numberDeals == 1 ? "deal" : "deals"
            numDealsLabel.text = "\(numberDeals) \(pluralised)"
        } catch let error as NSError {
            print("Count not fetched \(error), \(error.userInfo)")
        }
    }
}
