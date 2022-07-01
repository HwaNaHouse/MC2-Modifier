//
//  Persistence.swift
//  CoreDateVMTest
//
//  Created by Hyeonsoo Kim on 2022/06/23.
//
//  MARK: Core Data

import CoreData

class PersistenceController { //class vs struct -> no error both of them.
    
    static let shared = PersistenceController() //singleton
    let container: NSPersistentContainer
    
    //Convenience
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Moment")
        if inMemory { // ?
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    //Better save
    func saveContext() {
        let context = viewContext
        
        if context.hasChanges { //no change, no save. efficient.
            do {
                try context.save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    //for preview
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        //Categories
        let newCategory = Category(context: viewContext)
        newCategory.title = "Apple"
        
        shared.saveContext()
        
        return result
    }()
}
