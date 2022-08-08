//
//  PriceInfo+CoreDataProperties.swift
//  BubbleTea
//
//  Created by Stanislav Lemeshaev on 08.08.2022.
//  Copyright © 2022 slemeshaev. All rights reserved.
//

import Foundation
import CoreData

extension PriceInfo {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PriceInfo> {
        return NSFetchRequest<PriceInfo>(entityName: "PriceInfo")
    }
    
    @NSManaged public var priceCategory: String?
    @NSManaged public var venue: Venue?
}

extension PriceInfo : Identifiable {
}
