//
//  FilterViewController.swift
//  BubbleTea
//
//  Created by Stanislav Lemeshaev on 09.08.2022.
//  Copyright © 2022 slemeshaev. All rights reserved.
//

import UIKit

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
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
