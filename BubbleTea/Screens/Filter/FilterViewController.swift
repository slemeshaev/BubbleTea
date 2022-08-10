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
    @IBOutlet private weak var firstPriceCategory: UILabel!
    @IBOutlet private weak var secondPriceCategory: UILabel!
    @IBOutlet private weak var thirdPriceCategory: UILabel!
    @IBOutlet private weak var numDeals: UILabel!
    
    @IBOutlet private weak var cheapVenue: UITableViewCell!
    @IBOutlet private weak var moderateVenue: UITableViewCell!
    @IBOutlet private weak var expensiveVenue: UITableViewCell!
    
    @IBOutlet private weak var offeringDeal: UITableViewCell!
    @IBOutlet private weak var walkingDistance: UITableViewCell!
    @IBOutlet private weak var userTips: UITableViewCell!
    
    @IBOutlet private weak var nameAZSort: UITableViewCell!
    @IBOutlet private weak var nameZASort: UITableViewCell!
    @IBOutlet private weak var distanceSort: UITableViewCell!
    @IBOutlet private weak var priceSort: UITableViewCell!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction private func search(_ sender: UIBarButtonItem) {
    }
}

// MARK: - UITableViewDelegate
extension FilterViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
