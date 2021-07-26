//
//  File.swift
//  
//
//  Created by Adam Dahan on 2021-07-04.
//

import CoreData
import UIKit

@available(iOS 10.0, *)
public final class StorageProvider {
    
    /// Hide the initializer to prevent clients from instantiating this
    /// object directly.
    private init() { }

    /// Singleton dispatch
    public static let main = StorageProvider()
    
    public static var persistentContainer: NSPersistentContainer = {
        let momdName = "Storage"

        let modelURL = Bundle.module.url(forResource: momdName, withExtension: ".momd")!

        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }

        let persistentContainer = NSPersistentContainer(name: momdName, managedObjectModel: mom)
                
        persistentContainer.loadPersistentStores(completionHandler: { description, error in
            if let error = error {
                fatalError("Core Data store failed to load with error: \(error)")
            }
        })
        
        return persistentContainer
    }()
    
    public func getAllLogs() -> [Log] {
        let fetchRequest: NSFetchRequest<Log> = Log.fetchRequest()
        
        do {
            return try StorageProvider.persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch movies: \(error)")
            return []
        }
    }
    
    public func flush(completion: @escaping ((_ succeeded: Bool) -> Void)) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Log")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try StorageProvider.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: StorageProvider.persistentContainer.viewContext)
            completion(true)
        } catch let error as NSError {
            // TODO: handle the error
            print(error)
            completion(false)
        }
    }
    
    public func saveLog(
        location: String,
        data: String
    ) {
        
        let log = Log(context: StorageProvider.persistentContainer.viewContext)
        log.uuid = UUID().uuidString
        log.location = location
        log.date = Date()
        log.data = data
    
        do {
            try StorageProvider.persistentContainer.viewContext.save()
            print(log.description)
        } catch {
            print("Failed to save movie: \(error)")
            StorageProvider.persistentContainer.viewContext.rollback()
        }
    }
}
