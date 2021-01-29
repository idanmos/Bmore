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
    
    var properties: [Property] = []
    var filteredProperties: [Property] = []
    
    deinit {
        debugPrint("dealloc \(self)")
        self.properties.removeAll()
        self.filteredProperties.removeAll()
    }
    
    // MARK: - General Methods
    
    func fetchProperties() {
        self.properties = PropertiesViewModel.fetchProperties()
    }
    
    func searchBarCancelButtonClicked(collectionView: UICollectionView, view: UIView) {
        self.filteredProperties.removeAll()
        
        DispatchQueue.main.async {
            view.endEditing(true)
            collectionView.reloadData()
        }
    }
    
    func filter(searchText: String, collectionView: UICollectionView) {
        self.filteredProperties = self.properties.filter({ (obj: Property) -> Bool in
            return (obj.address?.contains(searchText) ?? false) || ((obj.extraInfo?.contains(searchText) ?? false))
        })
        
        collectionView.reloadData()
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
