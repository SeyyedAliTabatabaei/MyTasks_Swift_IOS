//
//  PersistenceController.swift
//  My Tasks
//
//  Created by Seyyed Ali Tabatabaei on 5/9/23.
//

import Foundation
import CoreData

struct PersistenceController{
    static let shared = PersistenceController()
    let container : NSPersistentContainer
    
    var viewContext : NSManagedObjectContext {
        return container.viewContext
    }
    
    init(inMemory : Bool = false) {
        container = NSPersistentContainer(name: "Tasks")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }else{
                print("Successfuly load core data")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
}

