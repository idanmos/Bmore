//
//  PropertyViewModel.swift
//  Vision
//
//  Created by Idan Moshe on 06/12/2020.
//

import UIKit
import CoreData

class PropertyViewModel: BaseViewModel {
    
    // MARK: - Variables
    
    var properties: [Property] = []
    var filteredProperties: [Property] = []
    
    // MARK: - Lifecycle
    
    deinit {
        debugPrint("dealloc \(self)")
        self.properties.removeAll()
        self.filteredProperties.removeAll()
    }
    
    // MARK: - General Methods
    
    func fetchProperties() {
        self.properties = PropertyViewModel.fetchProperties()
    }
    
    func searchBarCancelButtonClicked(collectionView: UICollectionView, view: UIView) {
        self.filteredProperties.removeAll()
        
        DispatchQueue.main.async {
            view.endEditing(true)
            collectionView.reloadData()
        }
    }
    
    func delete(index: Int, collectionView: UICollectionView, presenter: UIViewController) {
        let alertController = UIAlertController(title: "מחיקה", message: "האם למחוק?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "אישור", style: .destructive) { [weak self] (action: UIAlertAction) in
            guard let self = self else { return }
            PropertyViewModel.delete(self.properties[index])
            self.properties.remove(at: index)
            collectionView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "ביטול", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        presenter.present(alertController, animated: true, completion: nil)
    }
    
    func filter(searchText: String, collectionView: UICollectionView) {
        self.filteredProperties = self.properties.filter({ (obj: Property) -> Bool in
            return (obj.address?.contains(searchText) ?? false) || ((obj.extraInfo?.contains(searchText) ?? false))
        })
        
        collectionView.reloadData()
    }
    
}

// MARK: - CoreData

extension PropertyViewModel {
    
    class func fetchProperties(fetchLimit: Int? = nil) -> [Property] {
                
        let request: NSFetchRequest<Property> = Property.fetchRequest()
        
        if let limit: Int = fetchLimit {
            request.fetchLimit = limit
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let results: [Property] = try PropertyViewModel.mainContext().fetch(request)
            return results
        } catch let error {
            debugPrint(#function, error)
        }
        
        return []
    }
    
    class func fetchProperty(by propertyId: UUID) -> Property? {
        let request: NSFetchRequest<Property> = Property.fetchRequest()
        
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "propertyId == %@", argumentArray: [propertyId])
        
        do {
            let results: [Property] = try PropertyViewModel.mainContext().fetch(request)
            return results.first
        } catch let error {
            debugPrint(#function, error)
        }
        
        return nil
    }
    
    class func save(_ info: [Application.PropertySaveKeys: Any]) {
        let property = Property(context: PropertyViewModel.mainContext())
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
        
        PropertyViewModel.saveContext()
    }
    
    class func delete(_ property: Property) {
        ImageStorage.shared.delete(propertyId: property.uuid)
        
        PropertyViewModel.mainContext().delete(property)
        PropertyViewModel.saveContext()
    }
    
}
