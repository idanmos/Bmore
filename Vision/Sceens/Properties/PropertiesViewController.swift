//
//  PropertiesViewController.swift
//  Vision
//
//  Created by Idan Moshe on 06/12/2020.
//

import UIKit

class PropertiesViewController: UIViewController {
    
    private enum Constants {
        static let segueToAdd: String = "SegueToAdd"
        static let segueToDetails: String = "SegueToDetails"
        static let itemsPerRow: Int = 2
    }
    
    @IBOutlet private weak var searchContainerView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var viewModel = PropertiesViewModel()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchResultsUpdater = self
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.sizeToFit()
        controller.searchBar.delegate = self
        
        if #available(iOS 12, *) {
            controller.obscuresBackgroundDuringPresentation = false
        } else {
            controller.dimsBackgroundDuringPresentation = false
        }
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "properties".localized
        
        self.searchContainerView.addSubview(self.searchController.searchBar)
        
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

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PropertiesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchController.isActive ? self.viewModel.filteredProperties.count : self.viewModel.properties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(className: PropertyCollectionViewCell.self, indexPath: indexPath)
        cell.tag = indexPath.item
        cell.delegate = self
        
        var property: Property
        if self.searchController.isActive {
            property = self.viewModel.filteredProperties[indexPath.row]
        } else {
            property = self.viewModel.properties[indexPath.row]
        }
        
        cell.configure(property)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        var property: Property
        if self.searchController.isActive {
            property = self.viewModel.filteredProperties[indexPath.row]
        } else {
            property = self.viewModel.properties[indexPath.row]
        }
        self.performSegue(withIdentifier: PropertiesViewController.Constants.segueToDetails, sender: property)
    }
    
}

// MARK: - General Methods

extension PropertiesViewController {    
}

// MARK: - Navigation

extension PropertiesViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PropertiesViewController.Constants.segueToDetails,
           let viewController = segue.destination as? PropertyDetailsViewController, let property = sender as? Property {
            viewController.property = property
        }
    }
    
}

// MARK: - Actions

extension PropertiesViewController {
    
    @IBAction private func onPressAdd(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.segueToAdd, sender: self)
    }
    
}

// MARK: - PropertyCollectionViewCellDelegate

extension PropertiesViewController: PropertyCollectionViewCellDelegate {
    
    func propertyCell(_ propertyCell: PropertyCollectionViewCell, didTapOnDeleteAt index: Int) {
        self.viewModel.delete(index: index, collectionView: self.collectionView, presenter: self)
    }
}

// MARK: - UISearchResultsUpdating

extension PropertiesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText: String = searchController.searchBar.text, searchController.isActive else { return }
        self.viewModel.filter(searchText: searchText, collectionView: self.collectionView)
    }
    
}

// MARK: - UISearchBarDelegate

extension PropertiesViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.searchBarCancelButtonClicked(collectionView: self.collectionView, view: self.view)
    }
    
}
