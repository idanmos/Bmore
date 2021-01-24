//
//  PropertySelectionViewController.swift
//  Bmore
//
//  Created by Idan Moshe on 19/01/2021.
//

import UIKit

protocol PropertySelectionViewControllerDelegate: class {
    var allowsMultipleSelection: Bool { get }
    var selectedProperties: [Property] { get }
    
    // TODO: show/hide navigation controller
    func propertyController(_ propertyController: PropertySelectionViewController, didSelect properties: [Property])
}

class PropertySelectionViewController: UICollectionViewController {
    
    private var viewModel: PropertiesViewModel!
    init(viewModel: PropertiesViewModel) {
        super.init(collectionViewLayout: UICollectionViewLayout())
        
        self.viewModel = viewModel
        
        self.view.frame = UIScreen.main.bounds
        
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
        
        let columnLayout = FlowLayout(
                cellsPerRow: 2,
                minimumInteritemSpacing: 10,
                minimumLineSpacing: 10,
                sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            )
        
        self.collectionView.collectionViewLayout = columnLayout
        self.collectionView.contentInsetAdjustmentBehavior = .always
        
        self.view.backgroundColor = .white
        self.collectionView.backgroundColor = .white
        
        self.title = "properties".localized
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(className: PropertyCollectionViewCell.self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private enum Constants {
        static let itemsPerRow: Int = 2
    }
    
    weak var selectionDelegate: PropertySelectionViewControllerDelegate?
    
    private var selectedPropertiesId: [UUID] = []
    
    deinit {
        debugPrint("dealloc \(self)")
        self.viewModel.properties.removeAll()
        self.viewModel.filteredProperties.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        if let _ = self.selectionDelegate {
            self.collectionView.allowsMultipleSelection = self.selectionDelegate!.allowsMultipleSelection
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.selectedPropertiesId.removeAll()
        
        DispatchMainThreadSafe {
            self.viewModel.fetchProperties()
            
            if let properties: [Property] = self.selectionDelegate?.selectedProperties, properties.count > 0 {
                properties.forEach { (property: Property) in
                    if let propertyId: UUID = property.propertyId {
                        self.selectedPropertiesId.append(propertyId)
                    }
                }
                
                let filtered: [Property] = self.viewModel.properties.filter { (obj: Property) -> Bool in
                    return self.selectedPropertiesId.contains(obj.propertyId!)
                }
                
                let restOfTheProperties: [Property] = self.viewModel.properties.filter { (obj: Property) -> Bool in
                    return self.selectedPropertiesId.contains(obj.propertyId!) == false
                }
                
                self.viewModel.properties.removeAll()
                self.viewModel.properties.append(contentsOf: filtered)
                self.viewModel.properties.append(contentsOf: restOfTheProperties)
            }
            
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
        guard self.selectedPropertiesId.count > 0 else { return }
        
        let properties: [Property] = self.viewModel.properties.filter({ self.selectedPropertiesId.contains($0.propertyId!) })

        self.selectionDelegate?.propertyController(self, didSelect: properties)
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
        
        if let propertyId: UUID = property.propertyId, self.selectedPropertiesId.contains(propertyId) {
            cell.makeSelected(true)
        } else {
            cell.makeSelected(false)
        }
                
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView(collectionView, cellForItemAt: indexPath) as! PropertyCollectionViewCell
        
        let property: Property = self.viewModel.properties[indexPath.row]
        guard let propertyId: UUID = property.propertyId else { return }
        
        if self.selectedPropertiesId.contains(propertyId) {
            self.selectedPropertiesId.removeAll(where: { $0 == propertyId })
            cell.makeSelected(false)
        } else {
            self.selectedPropertiesId.append(propertyId)
            cell.makeSelected(true)
        }
        
        self.collectionView.reloadItems(at: [indexPath])
    }
    
}
