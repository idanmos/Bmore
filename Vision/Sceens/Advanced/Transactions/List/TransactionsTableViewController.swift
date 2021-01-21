//
//  TransactionsTableViewController.swift
//  B-more
//
//  Created by Idan Moshe on 30/12/2020.
//

import UIKit

class TransactionsTableViewController: UITableViewController {
    
    private var viewModel: TransactionsViewModel!
    
    private lazy var addBarButton: UIBarButtonItem = {
        let control = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onPressAddButton(_:)))
        return control
    }()
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if let advancedController = parent as? AdvancedViewController {
            if Application.isHebrew() {
                advancedController.navigationItem.leftBarButtonItem = self.addBarButton
                advancedController.navigationItem.rightBarButtonItem = self.editButtonItem
            } else {
                advancedController.navigationItem.leftBarButtonItem = self.editButtonItem
                advancedController.navigationItem.rightBarButtonItem = self.addBarButton
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        self.viewModel = TransactionsViewModel(presenter: self)
        
        self.tableView.register(SingleTransactionTableViewCell.self)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchTransactions()
        self.tableView.reloadData()
    }
    
    deinit {
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.transactions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SingleTransactionTableViewCell.self, indexPath: indexPath)
        let transaction: Transaction = self.viewModel.transactions[indexPath.row]
        cell.configure(transaction)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 172.0
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let transaction: Transaction = self.viewModel.transactions[indexPath.row]
            PersistentStorage.shared.delete(transaction)
            self.viewModel.transactions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction: Transaction = self.viewModel.transactions[indexPath.row]
        self.viewModel.showEditScreen(transaction)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}

// MARK: - General Methods

extension TransactionsTableViewController {}

// MARK: - Actions

extension TransactionsTableViewController {
    
    @objc private func onPressAddButton(_ sender: Any) {
        self.viewModel.showAddScreen()
    }
    
}

