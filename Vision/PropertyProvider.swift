//
//  PropertyProvider.swift
//  Bmore
//
//  Created by Idan Moshe on 29/01/2021.
//

import UIKit
import CoreData

class PropertyProvider {
    
    // MARK: - Variables
    
    private(set) var persistentContainer: NSPersistentContainer
    private weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Property> = {
        let fetchRequest: NSFetchRequest<Property> = Property.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Schema.Property.date.rawValue, ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self.fetchedResultsControllerDelegate
        
        do {
            try controller.performFetch()
        } catch {
            fatalError("###\(#file)#\(#function): Failed to performFetch: \(error)")
        }
        
        return controller
    }()
    
    // MARK: - Lifecycle
    
    init(with persistentContainer: NSPersistentContainer,
         fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?) {
        self.persistentContainer = persistentContainer
        self.fetchedResultsControllerDelegate = fetchedResultsControllerDelegate
    }
    
    func addProperty(configuration: PropertyConfiguration,
                     shouldSave: Bool = true,
                     handler: @escaping () -> Void) {
        self.persistentContainer.viewContext.perform {
            let property = Property(context: self.persistentContainer.viewContext)
            property.date = configuration.date
            property.uuid = configuration.uuid
            property.enterDateIsNow = configuration.enterDateIsNow
            property.sellOrRent = configuration.sellOrRent
            property.latitude = configuration.latitude ?? 0
            property.longitude = configuration.longitude ?? 0
            property.entryDate = configuration.entryDate
            property.type = configuration.type
            property.address = configuration.address
            property.price = configuration.price
            property.size = configuration.size ?? 0
            property.rooms = configuration.rooms ?? 0
            property.balcony = configuration.balcony ?? 0
            property.floorNumber = configuration.floorNumber ?? 0
            property.totalFloorNumber = configuration.totalFloorNumber ?? 0
            property.parking = configuration.parking ?? 0
            property.extraInfo = configuration.extraInfo
            property.contactIdentifier = configuration.contactIdentifier
            property.isExclusivity = configuration.isExclusivity
            property.exclusivityEndDate = configuration.exclusivityEndDate
            
            if shouldSave {
                self.persistentContainer.viewContext.save(with: .addProperty)
            }
            DispatchMainThreadSafe { handler() }
        }
    }
    
    func delete(property: Property,
                shouldSave: Bool = true,
                handler: @escaping () -> Void) {
        guard let context = property.managedObjectContext else {
            fatalError("###\(#function): Failed to retrieve the context from: \(property)")
        }
        context.perform {
            context.delete(property)
            
            if shouldSave {
                context.save(with: .deleteProperty)
            }
            DispatchMainThreadSafe { handler() }
        }
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate

/* extension MasterViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
} */
