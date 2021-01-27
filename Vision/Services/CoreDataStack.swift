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
        
    // MARK: - NSFetchedResultsController
    
    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: self.mainContext(),
                                                    sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self.fetchedResultsControllerDelegate
        
        do {
            try controller.performFetch()
        } catch {
            debugPrint(#file, #function, error)
        }
        
        return controller
    }()
    
    func resetAndRefetch() {
        self.mainContext().reset()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            debugPrint(#file, #function, error)
        }
    }
    
    func numberOfSections() -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func getAll<T: NSManagedObject>() -> [T] {
        return self.fetchedResultsController.fetchedObjects as? [T] ?? []
    }
    
    func object<T: NSManagedObject>(at indexPath: IndexPath) -> T? {
        return self.fetchedResultsController.object(at: indexPath) as? T
    }
    
    // MARK: - Test
    
    func importTasks() {
        let context = self.backgroundContext()
        context.perform {
        }
    }
    
}

// MARK: - Properties

extension CoreDataStack {
    
    func fetchProperties(fetchLimit: Int? = nil) -> [Property] {
                
        let request: NSFetchRequest<Property> = Property.fetchRequest()
        
        if let limit: Int = fetchLimit {
            request.fetchLimit = limit
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let results: [Property] = try self.mainContext().fetch(request)
            return results
        } catch let error {
            debugPrint(#function, error)
        }
        
        return []
    }
    
    func fetchProperty(by propertyId: UUID) -> Property? {
        let request: NSFetchRequest<Property> = Property.fetchRequest()
        
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "propertyId == %@", argumentArray: [propertyId])
        
        do {
            let results: [Property] = try self.mainContext().fetch(request)
            return results.first
        } catch let error {
            debugPrint(#function, error)
        }
        
        return nil
    }
    
    func save(_ info: [Application.PropertySaveKeys: Any]) {
        let property = Property(context: self.mainContext())
        property.date = Date()
        
        if let dateIsNow = info[.dateIsNow] as? Bool {
            property.enterDateIsNow = dateIsNow
        }
        if let sellOrRent = info[.sellOrRent] as? String {
            property.sellOrRent = sellOrRent
        }
        if let latitude = info[.latitude] as? Double {
            property.latitude = latitude
        }
        if let longitude = info[.longitude] as? Double {
            property.longitude = longitude
        }
        if let propertyUUID = info[.uuid] as? UUID {
            property.uuid = propertyUUID
        }
        if let enterDate = info[.enterDate] as? Date {
            property.entryDate = enterDate
        }
        if let propertyType = info[.type] as? Int {
            property.type = Int16(propertyType)
        }
        if let address = info[.address] as? String {
            property.address = address
        }
        if let price = info[.price] as? String {
            property.price = price
        }
        if let size = info[.size] as? String, let value = Double(size) {
            property.size = value
        }
        if let room = info[.rooms] as? String, let value = Double(room) {
            property.rooms = value
        }
        if let balcony = info[.balcony] as? String, let value = Int(balcony) {
            property.balcony = Int16(value)
        }
        if let floorNumber = info[.floorNumber] as? String, let floor = Int(floorNumber) {
            property.floorNumber = Int16(floor)
        }
        if let totalFloorNumber = info[.totalFloorsNumber] as? String, let floor = Int(totalFloorNumber) {
            property.totalFloorNumber = Int16(floor)
        }
        if let parking = info[.parking] as? String, let value = Int(parking) {
            property.parking = Int16(value)
        }
        if let extraInfo = info[.extraInfo] as? String {
            property.extraInfo = extraInfo
        }
        if let contactIdentifier = info[.contactIdentifier] as? String {
            property.contactIdentifier = contactIdentifier
        }
        if let isExclisivity = info[.isExclusivity] as? Bool {
            property.isExclusivity = isExclisivity
        }
        if let exclusiveEndDate = info[.exclusivityEndDate] as? Date {
            property.exclusivityEndDate = exclusiveEndDate
        }
        
        self.saveContext()
    }
    
    func delete(_ property: Property) {
        ImageStorage.shared.delete(propertyId: property.uuid)
        
        self.mainContext().delete(property)
        self.saveContext()
    }
    
}

// MARK: - Leads

extension CoreDataStack {
    
    
    
}

// MARK: - Time Tracking

extension CoreDataStack {
    
    func fetchTimeTrack(fetchLimit: Int? = nil) -> [TimeTrack] {
        let request: NSFetchRequest<TimeTrack> = TimeTrack.fetchRequest()
        
        if let limit: Int = fetchLimit {
            request.fetchLimit = limit
        }
                
        do {
            let results: [TimeTrack] = try self.mainContext().fetch(request)
            return results
        } catch let error {
            debugPrint(#function, error)
        }
        
        return []
    }
}

// MARK: - Transactions

extension CoreDataStack {
    
    func fetchTransactions(fetchLimit: Int? = nil) -> [Transaction] {
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        if let limit: Int = fetchLimit {
            request.fetchLimit = limit
        }
                
        do {
            let results: [Transaction] = try self.mainContext().fetch(request)
            return results
        } catch let error {
            debugPrint(#function, error)
        }
        
        return []
    }
    
    private func saveOrEdit(_ transaction: Transaction, configuration: TransactionConfiguration) {
        transaction.status = Int16(configuration.status)
        transaction.type = Int16(configuration.type)
        transaction.date = configuration.date
        transaction.locationType = Int16(configuration.locationType)
        transaction.propertyId = configuration.propertyId
        transaction.address = configuration.address
        transaction.location = configuration.location
        transaction.placemark = configuration.placemark
        transaction.price = NSDecimalNumber(string: configuration.price)
        transaction.commisionType = Int16(configuration.commisionType)
        transaction.commission = NSDecimalNumber(string: configuration.commision)
        transaction.contactId = configuration.contactId
        
        if let type = Application.TransactionType(rawValue: Int16(configuration.type)) {
            if type == .revenue {
                if let propertyId: UUID = configuration.propertyId,
                   let property: Property = self.fetchProperty(by: propertyId) {
                    property.isSold = true
                }
            }
        }
        
        self.saveContext()
    }
    
    func save(_ configuration: TransactionConfiguration) {
        let transaction = Transaction(context: self.mainContext())
        transaction.uuid = UUID()
        self.saveOrEdit(transaction, configuration: configuration)
    }
    
    func edit(_ transaction: Transaction, configuration: TransactionConfiguration) {
        self.saveOrEdit(transaction, configuration: configuration)
    }
        
    func delete(_ transaction: Transaction) {
        self.mainContext().delete(transaction)
        self.saveContext()
    }
    
}

// MARK: - Tasks

extension CoreDataStack {
    
    func fetchTasks(fetchLimit: Int? = nil) -> [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        if let limit: Int = fetchLimit {
            request.fetchLimit = limit
        }
                
        do {
            let results: [Task] = try self.mainContext().fetch(request)
            return results
        } catch let error {
            debugPrint(#function, error)
        }
        
        return []
    }
    
    private func saveOrEdit(_ task: Task, configuration: TaskConfiguration) {
        task.timestamp = Date()
        task.title = configuration.title
        task.status = configuration.status.rawValue
        task.type = configuration.type.rawValue
        task.date = configuration.date
        task.contactId = configuration.contactId
        task.comments = configuration.comments
        task.isPushEnabled = configuration.isPushEnabled
        self.saveContext()
    }
    
    func save(_ configuration: TaskConfiguration) {
        let task = Task(context: self.mainContext())
        task.uuid = UUID()
        self.saveOrEdit(task, configuration: configuration)
    }
    
    func edit(_ task: Task, configuration: TaskConfiguration) {
        self.saveOrEdit(task, configuration: configuration)
    }
        
    func delete(_ task: Task) {
        self.mainContext().delete(task)
        self.saveContext()
    }
    
}

// MARK: - Meetings

extension CoreDataStack {
}
