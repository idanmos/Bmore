//
//  PropertiesViewModel.swift
//  Vision
//
//  Created by Idan Moshe on 06/12/2020.
//

import UIKit

class PropertiesViewModel {
    
    var properties: [Property] = []
    var filteredProperties: [Property] = []
    
    func fetchProperties() {
        self.properties = PersistentStorage.shared.fetchProperties()
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
            PersistentStorage.shared.delete(self.properties[index])
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
