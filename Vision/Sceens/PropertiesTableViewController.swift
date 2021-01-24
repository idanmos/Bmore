//
//  PropertiesTableViewController.swift
//  Bmore
//
//  Created by Idan Moshe on 24/01/2021.
//

import UIKit

class PropertiesTableViewController: UITableViewController {
    
    private var properties: [Property] = []
    init(properties: [Property]) {
        super.init(style: .plain)
        
        self.properties = properties
        
        self.title = "properties".localized
        
        self.view.frame = UIScreen.main.bounds
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(self.closeScreen(_:))
        )
        
        self.tableView.backgroundColor = .white
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(PropertyTableViewCell.self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        debugPrint("dealloc \(self)")
        self.properties.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.properties.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PropertyTableViewCell.self, indexPath: indexPath)
        let property: Property = self.properties[indexPath.row]
        cell.configure(property)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        OperationQueue.main.addOperation {
            let propertiesStoryboard = UIStoryboard(name: "Properties", bundle: nil)
            guard let detailsViewController = propertiesStoryboard.instantiateViewController(withIdentifier: PropertyDetailsViewController.className())
                    as? PropertyDetailsViewController
            else { return }
            
            let property: Property = self.properties[indexPath.row]
            detailsViewController.property = property
            self.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
    
    //MARK: - Actions
    
    @objc private func closeScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
