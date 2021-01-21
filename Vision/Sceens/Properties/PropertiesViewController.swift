//
//  PropertiesViewController.swift
//  Vision
//
//  Created by Idan Moshe on 06/12/2020.
//

import UIKit

class PropertiesViewController: UIViewController {
    
    enum Constants {
        static let segueToDetails: String = "SegueToDetails"
        static let itemsPerRow: Int = 2
    }
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var viewModel = PropertiesViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        self.collectionView.register(className: AssetCollectionViewCell.self)
        
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
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? AssetDetailsViewController {
            guard let property = sender as? Property else { return }
            viewController.property = property
        }
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PropertiesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.properties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(className: AssetCollectionViewCell.self, indexPath: indexPath)
        let property: Property = self.viewModel.properties[indexPath.row]
        cell.configure(property)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let property: Property = self.viewModel.properties[indexPath.row]
        self.performSegue(withIdentifier: PropertiesViewController.Constants.segueToDetails, sender: property)
    }
    
}

// MARK: - Actions

extension PropertiesViewController {
    
    @IBAction private func onPressAdd(_ sender: Any) {
        let addPropertyViewController = AddPropertyViewController(nibName: AddPropertyViewController.className(), bundle: nil)
        self.navigationController?.pushViewController(addPropertyViewController, animated: true)
    }
    
}

// MARK: - UISearchResultsUpdating

extension PropertiesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // guard let searchText: String = searchController.searchBar.text, searchController.isActive else { return }
    }
    
}

// MARK: - UISearchBarDelegate

extension PropertiesViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    
}
