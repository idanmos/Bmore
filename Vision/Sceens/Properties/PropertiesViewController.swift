//
//  PropertiesViewController.swift
//  Vision
//
//  Created by Idan Moshe on 06/12/2020.
//

import UIKit

class PropertiesViewController: BaseTableViewController {
    
    // MARK: - Variables
        
    private var viewModel = PropertiesViewModel()
    
    private lazy var addButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onPressAdd(_:)))
        return button
    }()
    
    private lazy var mapButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(self.onPressMap(_:)))
        return button
    }()
        
    // MARK: - Lifecycle
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        self.title = "properties".localized
        
        self.navigationItem.rightBarButtonItems = [self.addButtonItem, self.mapButtonItem]
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        self.tableView.register(PropertyTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.resetAndReload()
        self.tableView.reloadData()
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension PropertiesViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.fetchedObjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PropertyTableViewCell.self, indexPath: indexPath)
        let property: Property = self.viewModel.object(at: indexPath)
        cell.configure(property)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let property: Property = self.viewModel.object(at: indexPath)
        let viewController = FactoryController.Screen.propertyDetails(property: property).viewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let property: Property = self.viewModel.object(at: indexPath)
            self.viewModel.getDataProvider().delete(property) { [weak self] in
                self?.viewModel.resetAndReload()
                self?.tableView.reloadData()
            }
        } else if editingStyle == .insert {
        }
    }
    
}

// MARK: - General Methods

extension PropertiesViewController {    
}

// MARK: - Action Handlers

extension PropertiesViewController {
    
    @objc private func onPressAdd(_ sender: UIBarButtonItem) {
        guard let viewController = UIStoryboard(name: "Properties", bundle: nil).instantiateViewController(withIdentifier: AddPropertyTableViewController.className())
                as? AddPropertyTableViewController
        else { return }
        viewController.dataProvider = self.viewModel.getDataProvider()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func onPressMap(_ sender: UIBarButtonItem) {
        let viewController = PropertiesMapViewController(viewModel: self.viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func onPressMenu(_ sender: UIBarButtonItem) {
        //
    }
    
}
