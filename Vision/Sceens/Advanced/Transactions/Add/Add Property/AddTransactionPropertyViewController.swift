//
//  AddTransactionPropertyViewController.swift
//  B-more
//
//  Created by Idan Moshe on 10/01/2021.
//

import UIKit

protocol AddTransactionPropertyViewControllerDelegate: class {
    func addTransactionPropertyController(_ addTransactionPropertyController: AddTransactionPropertyViewController, didSelect property: Property)
}

class AddTransactionPropertyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var navBar: UINavigationBar!
    
    private var viewModel = PropertiesViewModel()
    
    weak var delegate: AddTransactionPropertyViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBar.topItem?.title = NSLocalizedString("properties", comment: "")
        self.navBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.OnPressClose(_:)))
                
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(PropertyDetailsTableViewCell.self)
        
        DispatchQueue.main.async {
            self.viewModel.fetchProperties()
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows: Int = self.viewModel.properties.count
        return rows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PropertyDetailsTableViewCell.self, indexPath: indexPath)
        let property: Property = self.viewModel.properties[indexPath.row]
        cell.configure(property)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let property: Property = self.viewModel.properties[indexPath.row]
        self.delegate?.addTransactionPropertyController(self, didSelect: property)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction private func OnPressClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - General Methods

extension AddTransactionPropertyViewController {
}
