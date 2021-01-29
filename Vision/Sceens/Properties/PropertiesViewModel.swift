//
//  PropertiesViewModel.swift
//  Vision
//
//  Created by Idan Moshe on 06/12/2020.
//

import UIKit
import CoreData

class PropertiesViewModel: BaseViewModel {
    
    // MARK: - Variables
    
    private lazy var dataProvider: PropertyProvider = {
        return PropertyProvider(
            with: AppDelegate.sharedDelegate().coreDataStack.persistentContainer,
            fetchedResultsControllerDelegate: nil
        )
    }()
        
    deinit {
        debugPrint("Deallocating \(self)")
    }
    
    // MARK: - General Methods
    
    func getDataProvider() -> PropertyProvider {
        return self.dataProvider
    }
    
    var fetchedObjects: [Property] {
        return self.dataProvider.fetchedResultsController.fetchedObjects ?? []
    }
    
    func object(at indexPath: IndexPath) -> Property {
        return self.dataProvider.fetchedResultsController.object(at: indexPath)
    }
    
    func indexPath(forObject object: Property) -> IndexPath? {
        return self.dataProvider.fetchedResultsController.indexPath(forObject: object)
    }
    
    func resetAndReload() {
        self.dataProvider.resetAndReload()
    }
    
}

// MARK: - CoreData

extension PropertiesViewModel {
            
    // MARK: - Old
    
    class func fetchProperties(fetchLimit: Int? = nil) -> [Property] {
                
        let request: NSFetchRequest<Property> = Property.fetchRequest()
        
        if let limit: Int = fetchLimit {
            request.fetchLimit = limit
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: Schema.Property.date.rawValue, ascending: false)]
        
        do {
            let results: [Property] = try PropertiesViewModel.mainContext().fetch(request)
            return results
        } catch let error {
            debugPrint(#function, error)
        }
        
        return []
    }
    
    class func fetchProperty(by propertyId: UUID) -> Property? {
        let request: NSFetchRequest<Property> = Property.fetchRequest()
        
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "\(Schema.Property.uuid.rawValue) == %@", argumentArray: [propertyId])
        
        do {
            let results: [Property] = try PropertiesViewModel.mainContext().fetch(request)
            return results.first
        } catch let error {
            debugPrint(#function, error)
        }
        
        return nil
    }
    
}
