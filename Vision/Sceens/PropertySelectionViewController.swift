//
//  PropertySelectionViewController.swift
//  Bmore
//
//  Created by Idan Moshe on 19/01/2021.
//

import UIKit

protocol PropertySelectionViewControllerDelegate: class {
    func propertyController(_ propertyController: PropertySelectionViewController, didSelect property: Property)
}

class PropertySelectionViewController: UICollectionViewController {
    
    private enum Constants {
        static let itemsPerRow: Int = 2
    }
    
    weak var selectionDelegate: PropertySelectionViewControllerDelegate?
    
    private var viewModel = PropertiesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "properties".localized
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(className: PropertyCollectionViewCell.self)
        
        let columnLayout = FlowLayout(
                cellsPerRow: 2,
                minimumInteritemSpacing: 10,
                minimumLineSpacing: 10,
                sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            )
        
        self.collectionView.collectionViewLayout = columnLayout
        self.collectionView.contentInsetAdjustmentBehavior = .always
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.viewModel.fetchProperties()
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.properties.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(className: PropertyCollectionViewCell.self, indexPath: indexPath)
        cell.deleteButton.isHidden = true
        let property: Property = self.viewModel.properties[indexPath.row]
        cell.configure(property)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let property: Property = self.viewModel.properties[indexPath.row]
        self.selectionDelegate?.propertyController(self, didSelect: property)
    }
    
}
