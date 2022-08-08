//
//  Category+CoreDataProperties.swift
//  BubbleTea
//
//  Created by Stanislav Lemeshaev on 08.08.2022.
//  Copyright © 2022 slemeshaev. All rights reserved.
//

import Foundation
import CoreData

extension Category {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }
    
    @NSManaged public var categoryID: String?
    @NSManaged public var name: String?
    @NSManaged public var venue: Venue?
}

extension Category : Identifiable {
}
