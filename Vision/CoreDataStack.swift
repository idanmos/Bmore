//
//  CoreDataStack.swift
//  Vision
//
//  Created by Idan Moshe on 08/12/2020.
//

import Foundation
import CoreData
import Contacts

// MARK: - Core Data Stack

/**
 Core Data stack setup including history processing.
 */
class CoreDataStack {
        
    // MARK: - Initialize Core Data
    
    private lazy var storeURL: URL = {
        let urls: [URL] = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentURL: URL = urls.last else {
            fatalError("\(#file), \(#function), Error fetching document directory")
        }
        return documentURL.appendingPathComponent("Vision.sqlite")
    }()
    
    /**
     A persistent container that can load cloud-backed and non-cloud stores.
     */
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentCloudKitContainer(name: "Vision")
        
        container.loadPersistentStores { (storeDescription: NSPersistentStoreDescription, error: Error?) in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.transactionAuthor = appTransactionAuthorName
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        
        return container
    }()
    
    /**
     The URL of the thumbnail folder.
     */
    static var attachmentFolder: URL = {
        var url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("Vision", isDirectory: true)
        url = url.appendingPathComponent("attachments", isDirectory: true)
        
        // Create it if it doesn’t exist.
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)

            } catch {
                print("###\(#function): Failed to create thumbnail folder URL: \(error)")
            }
        }
        return url
    }()
    
    init() {
        //
    }
    
    func mainContext() -> NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    func saveContext () {
        let context = self.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
