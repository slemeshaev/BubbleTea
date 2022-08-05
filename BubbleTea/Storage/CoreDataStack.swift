//
//  CoreDataStack.swift
//  BubbleTea
//
//  Created by Stanislav Lemeshaev on 04.08.2022.
//  Copyright © 2022 slemeshaev. All rights reserved.
//

import CoreData

final class CoreDataStack {
    // MARK: - Init
    init(modelName: String) {
        self.modelName = modelName
    }
    
    // MARK: - Properties
    private let modelName: String
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()
    
    // MARK: - Interface
    func saveContext() {
        guard managedContext.hasChanges else {
            return
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
