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
    
    private lazy var headerView: TransactionHeaderView = {
        let header = TransactionHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItems = [self.addBarButton, self.editButtonItem]
        
        self.viewModel = TransactionsViewModel(presenter: self)
        
        self.tableView.register(TransactionTableViewCell.self)
        self.tableView.tableHeaderView = self.headerView
        
        self.headerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.headerView.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
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
        let cell = tableView.dequeue(TransactionTableViewCell.self, indexPath: indexPath)
        let transaction: Transaction = self.viewModel.transactions[indexPath.row]
        cell.transaction = transaction
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let transaction: Transaction = self.viewModel.transactions[indexPath.row]
            TransactionsViewModel.delete(transaction)
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

extension TransactionsTableViewController {
    
    @objc func saveAndClose(_ sender: Any) {
        //
    }
    
}

// MARK: - Actions

extension TransactionsTableViewController {
    
    @objc private func onPressAddButton(_ sender: Any) {
        self.viewModel.showAddScreen()
    }
    
}

