//
//  AddTransactionPropertyTableViewController.swift
//  B-more
//
//  Created by Idan Moshe on 10/01/2021.
//

import UIKit

protocol AddTransactionPropertyTableViewControllerDelegate: class {
    func addTransactionPropertyController(_ addTransactionPropertyController: AddTransactionPropertyTableViewController, didSelect property: Property)
}

class AddTransactionPropertyTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel = PropertiesViewModel()
    
    weak var delegate: AddTransactionPropertyTableViewControllerDelegate?
    
    private lazy var noDataLabel: UILabel = {
        let label = UILabel(frame: UIScreen.main.bounds)
        label.textAlignment = .center
        label.text = NSLocalizedString("no_data", comment: "")
        label.font = .systemFont(ofSize: 20.0)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.noDataLabel)
        self.noDataLabel.isHidden = true
        self.noDataLabel.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.noDataLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.noDataLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.noDataLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44.0))
        navBar.prefersLargeTitles = true
        let navItem = UINavigationItem(title: NSLocalizedString("properties", comment: ""))
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.dismiss(animated:completion:)))
        navBar.setItems([navItem], animated: false)
        
        self.tableView.tableHeaderView = navBar
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.tableView.register(PropertyDetailsTableViewCell.self)
        
        DispatchQueue.main.async {
            self.viewModel.fetchProperties()
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows: Int = self.viewModel.properties.count
        
        if rows > 0 {
            self.hideNoData()
        } else {
            self.showNoData()
        }
        
        return rows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PropertyDetailsTableViewCell.self, indexPath: indexPath)
        let property: Property = self.viewModel.properties[indexPath.row]
        cell.configure(property)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let property: Property = self.viewModel.properties[indexPath.row]
        self.delegate?.addTransactionPropertyController(self, didSelect: property)
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - General Methods

extension AddTransactionPropertyTableViewController {
    
    private func showNoData() {
        self.noDataLabel.isHidden = false
    }
    
    private func hideNoData() {
        self.noDataLabel.isHidden = true
    }
    
}
