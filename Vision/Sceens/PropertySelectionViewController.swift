//
//  PropertySelectionViewController.swift
//  Bmore
//
//  Created by Idan Moshe on 19/01/2021.
//

import UIKit

protocol PropertySelectionViewControllerDelegate: class {
    var allowsMultipleSelection: Bool { get }
    // TODO: show/hide navigation controller
    func propertyController(_ propertyController: PropertySelectionViewController, didSelect properties: [Property])
}

class PropertySelectionViewController: UICollectionViewController {
    
    private enum Constants {
        static let itemsPerRow: Int = 2
    }
    
    weak var selectionDelegate: PropertySelectionViewControllerDelegate?
    
    private var viewModel = PropertiesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(self.closeScreen(_:))
        )
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(self.saveAndClose(_:))
        )
        
        if let _ = self.selectionDelegate {
            self.collectionView.allowsMultipleSelection = self.selectionDelegate!.allowsMultipleSelection
        }
        
        self.view.backgroundColor = .white
        self.collectionView.backgroundColor = .white
        
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
    
    // MARK: - General Methods
    
    @objc private func closeScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveAndClose(_ sender: Any) {
        if let indexPathsForSelectedItems: [IndexPath] = self.collectionView.indexPathsForSelectedItems {
            var properties: [Property] = []
            indexPathsForSelectedItems.forEach { (indexPath: IndexPath) in
                properties.append(self.viewModel.properties[indexPath.item])
            }
            self.selectionDelegate?.propertyController(self, didSelect: properties)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.properties.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(className: PropertyCollectionViewCell.self, indexPath: indexPath)
        cell.deleteButton.isHidden = true
        let property: Property = self.viewModel.properties[indexPath.row]
        cell.configure(property)
        
        if let _ = self.selectionDelegate {
            cell.allowsMultipleSelection = self.selectionDelegate!.allowsMultipleSelection
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        let property: Property = self.viewModel.properties[indexPath.row]
//        self.selectionDelegate?.propertyController(self, didSelect: property)
    }
    
}
