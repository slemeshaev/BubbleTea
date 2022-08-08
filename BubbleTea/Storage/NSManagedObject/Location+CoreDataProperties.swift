//
//  Location+CoreDataProperties.swift
//  BubbleTea
//
//  Created by Stanislav Lemeshaev on 08.08.2022.
//  Copyright © 2022 slemeshaev. All rights reserved.
//

import Foundation
import CoreData

extension Location {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }
    
    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var distance: Float
    @NSManaged public var state: String?
    @NSManaged public var zipcode: String?
    @NSManaged public var venue: Venue?
}

extension Location : Identifiable {
}
