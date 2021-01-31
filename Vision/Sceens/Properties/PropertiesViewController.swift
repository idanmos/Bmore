//
//  PropertiesViewController.swift
//  Vision
//
//  Created by Idan Moshe on 06/12/2020.
//

import UIKit

class PropertiesViewController: BaseViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let segueToAdd: String = "SegueToAdd"
        static let segueToDetails: String = "SegueToDetails"
        static let segueToMap: String = "SegueToMap"
        static let itemsPerRow: Int = 2
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var searchContainerView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Variables
        
    private var viewModel = PropertiesViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "properties".localized
                
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
        self.viewModel.resetAndReload()
        self.collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PropertiesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.fetchedObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(className: PropertyCollectionViewCell.self, indexPath: indexPath)
        cell.tag = indexPath.item
        cell.delegate = self
        let property: Property = self.viewModel.object(at: indexPath)
        cell.configure(property)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let property: Property = self.viewModel.object(at: indexPath)
        
        self.performSegue(
            withIdentifier: Constants.segueToDetails,
            sender: property
        )
    }
    
}

// MARK: - General Methods

extension PropertiesViewController {    
}

// MARK: - Navigation

extension PropertiesViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueToDetails {
            if let viewController = segue.destination as? PropertyDetailsViewController {
                if let property = sender as? Property {
                    viewController.property = property
                }
            }
        } else if segue.identifier == Constants.segueToAdd {
            if let viewController = segue.destination as? AddPropertyTableViewController {
                if let provider = sender as? PropertyProvider {
                    viewController.dataProvider = provider
                }
            }
        } else if segue.identifier == Constants.segueToMap {
            if let viewController = segue.destination as? AssetsMapViewController {
                viewController.viewModel = self.viewModel
            }
        }
    }
    
}

// MARK: - Action Handlers

extension PropertiesViewController {
    
    @IBAction private func onPressAdd(_ sender: Any) {
        self.performSegue(
            withIdentifier: Constants.segueToAdd,
            sender: self.viewModel.getDataProvider()
        )
    }
    
}

// MARK: - PropertyCollectionViewCellDelegate

extension PropertiesViewController: PropertyCollectionViewCellDelegate {
    
    func propertyCell(_ propertyCell: PropertyCollectionViewCell, didTapOnDeleteAt index: Int) {
        let property: Property = self.viewModel.fetchedObjects[index]
        
        self.viewModel.getDataProvider().delete(property) { [weak self] in
            guard let self = self else { return }
            self.viewModel.resetAndReload()
            self.collectionView.reloadData()
        }
    }
}
