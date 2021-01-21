//
//  TransactionsViewModel.swift
//  B-more
//
//  Created by Idan Moshe on 30/12/2020.
//

import UIKit

class TransactionsViewModel {
    
    var transactions: [Transaction] = []
    var presenter: UIViewController
    
    var navigationController: UINavigationController? {
        return self.presenter.navigationController
    }
    
    init(presenter: UIViewController) {
        self.presenter = presenter
    }
    
    func fetchTransactions() {
        self.transactions = PersistentStorage.shared.fetchTransactions()
    }
    
    func showAddScreen() {
        if let addTransactionController = UIStoryboard(name: "Advanced", bundle: nil).instantiateViewController(withIdentifier: AddTransactionTableViewController.className()) as? AddTransactionTableViewController {
            self.navigationController?.pushViewController(addTransactionController, animated: true)
        }
    }
    
    func showEditScreen(_ transaction: Transaction) {
        if let addTransactionController = UIStoryboard(name: "Advanced", bundle: nil).instantiateViewController(withIdentifier: AddTransactionTableViewController.className()) as? AddTransactionTableViewController {
            addTransactionController.editedTransaction = transaction
            self.navigationController?.pushViewController(addTransactionController, animated: true)
        }
    }
    
}
