//
//  CoreDataStack.swift
//  Virtual_Tourist
//
//  Created by Dan Henshaw on 12/10/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//


import CoreData

    struct CoreDataStack {
    
    static let shared = CoreDataStack(modelName: "Model")!
    private let model: NSManagedObjectModel
    internal let coordinator: NSPersistentStoreCoordinator
    private let modelURL: URL
    internal let DatabaseURL: URL
    let context: NSManagedObjectContext
    internal let persistingContext: NSManagedObjectContext
    internal let backgroundContext: NSManagedObjectContext
    
    init?(modelName: String) {
        
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            print("Unable to find \(modelName) in the main bundle")
            return nil
        }
        self.modelURL = modelURL
        
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            print("Unable to create a model from \(modelURL)")
            return nil
        }
        
        self.model = model
        
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        persistingContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        persistingContext.persistentStoreCoordinator = coordinator
        
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = persistingContext
        
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = context
        
        let fm = FileManager.default
        
        guard let docUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to reach the documents folder")
            return nil
        }
        
        self.DatabaseURL = docUrl.appendingPathComponent("model.sqlite")
        
        let options = [NSInferMappingModelAutomaticallyOption: true,NSMigratePersistentStoresAutomaticallyOption: true]
        
        do {
            try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: DatabaseURL, options: options as [NSObject : AnyObject]?)
        } catch {
            print("unable to add store at \(DatabaseURL)")
        }
    }
    
    
    func addStoreCoordinator(_ storeType: String, configuration: String?, storeURL: URL, options : [NSObject:AnyObject]?) throws {
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: DatabaseURL, options: nil)
    }
}

 extension CoreDataStack {
    
    func save() {
        
        context.performAndWait() {
            
            if self.context.hasChanges {
                do {
                    try self.context.save()
                } catch {
                    fatalError("Error saving context: \(error)")
                }
                
                self.persistingContext.perform() {
                    do {
                        try self.persistingContext.save()
                    } catch {
                        fatalError("Error saving persisting context: \(error)")
                    }
                }
            }
        }
    }
}

