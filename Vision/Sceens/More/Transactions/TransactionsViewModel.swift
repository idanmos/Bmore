//
//  TransactionsViewModel.swift
//  B-more
//
//  Created by Idan Moshe on 30/12/2020.
//

import UIKit
import CoreData

class TransactionsViewModel: BaseViewModel {
    
    var transactions: [Transaction] = []
    var presenter: UIViewController
    
    var navigationController: UINavigationController? {
        return self.presenter.navigationController
    }
    
    init(presenter: UIViewController) {
        self.presenter = presenter
    }
    
    func fetchTransactions() {
        self.transactions = TransactionsViewModel.fetchTransactions()
    }
    
    func showAddScreen() {        
        if let addTransactionController = UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: AddTransactionTableViewController.className()) as? AddTransactionTableViewController {
            self.navigationController?.pushViewController(addTransactionController, animated: true)
        }
    }
    
    func showEditScreen(_ transaction: Transaction) {
        if let addTransactionController = UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: AddTransactionTableViewController.className()) as? AddTransactionTableViewController {
            addTransactionController.editedTransaction = transaction
            self.navigationController?.pushViewController(addTransactionController, animated: true)
        }
    }
    
}

// MARK: - CoreData

extension TransactionsViewModel {
    
    class func fetchTransactions(fetchLimit: Int? = nil) -> [Transaction] {
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        if let limit: Int = fetchLimit {
            request.fetchLimit = limit
        }
                
        do {
            let results: [Transaction] = try TransactionsViewModel.mainContext().fetch(request)
            return results
        } catch let error {
            debugPrint(#function, error)
        }
        
        return []
    }
    
    private class func saveOrEdit(_ transaction: Transaction, configuration: TransactionConfiguration) {
        transaction.status = Int16(configuration.status)
        transaction.type = Int16(configuration.type)
        transaction.date = configuration.date
        transaction.price = NSDecimalNumber(string: configuration.price)
        transaction.commisionType = Int16(configuration.commisionType)
        transaction.commission = NSDecimalNumber(string: configuration.commision)
        
        TransactionsViewModel.saveContext()
    }
    
    class func save(_ configuration: TransactionConfiguration) {
        let transaction = Transaction(context: TransactionsViewModel.mainContext())
        transaction.uuid = UUID()
        self.saveOrEdit(transaction, configuration: configuration)
        
        ActivityManager.shared.save(.addTransaction)
    }
    
    class func edit(_ transaction: Transaction, configuration: TransactionConfiguration) {
        self.saveOrEdit(transaction, configuration: configuration)
        
        ActivityManager.shared.save(.editTransaction)
    }
        
    class func delete(_ transaction: Transaction) {
        TransactionsViewModel.mainContext().delete(transaction)
        TransactionsViewModel.saveContext()
        
        ActivityManager.shared.save(.deleteTransaction)
    }
    
}
