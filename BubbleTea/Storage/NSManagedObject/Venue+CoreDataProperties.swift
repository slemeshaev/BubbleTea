//
//  Venue+CoreDataProperties.swift
//  BubbleTea
//
//  Created by Stanislav Lemeshaev on 08.08.2022.
//  Copyright © 2022 slemeshaev. All rights reserved.
//

import Foundation
import CoreData

extension Venue {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Venue> {
        return NSFetchRequest<Venue>(entityName: "Venue")
    }
    
    @NSManaged public var favorite: Bool
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var specialCount: Int32
    @NSManaged public var category: Category?
    @NSManaged public var location: Location?
    @NSManaged public var priceInfo: PriceInfo?
    @NSManaged public var stats: Stats?
}

extension Venue : Identifiable {
}
