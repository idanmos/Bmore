//
//  BaseSelectionTableViewController.swift
//  Bmore
//
//  Created by Idan Moshe on 25/01/2021.
//

import UIKit

enum LeadSelectionType {
    case none, properties, transactions, meetings, tasks
    
    func title() -> String {
        switch self {
        case .none: return ""
        case .properties: return "properties".localized
        case .transactions: return "transactions".localized
        case .meetings: return "meetings".localized
        case .tasks: return "tasks".localized
        }
    }
}

protocol BaseSelectionTableViewControllerDelegate: class {
    func selectionController(_ selectionController: BaseSelectionTableViewController, didSelect objects: [Any], leadType: LeadSelectionType)
}

class BaseSelectionTableViewController: UITableViewController {
    
    weak var delegate: BaseSelectionTableViewControllerDelegate?
    
    private var dataSource: [Any] = []
    
    private var leadType: LeadSelectionType = .none
    
    init(dataSource: [Any], leadType: LeadSelectionType) {
        super.init(style: .plain)
        self.view.frame = UIScreen.main.bounds
        self.dataSource = dataSource
        self.leadType = leadType
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        debugPrint("Deallocating \(self)")
        self.dataSource.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(self.closeScreen)
        )
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(self.saveAndClose(_:))
        )
        
        self.tableView.register(SelectionPropertyTableViewCell.self)
        self.tableView.register(SelectionTransactionTableViewCell.self)
        self.tableView.register(SelectionTaskTableViewCell.self)
        self.tableView.register(SelectionMeetingTableViewCell.self)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.allowsSelection = true
        self.tableView.allowsMultipleSelection = true
    }
    
    @objc private func saveAndClose(_ sender: Any) {
        guard let indexPathsForSelectedRows: [IndexPath] = self.tableView.indexPathsForSelectedRows, indexPathsForSelectedRows.count > 0 else {
            self.delegate?.selectionController(self, didSelect: [], leadType: self.leadType)
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        var selectedObjects: [Any] = []
        for indexPath: IndexPath in indexPathsForSelectedRows {
            let obj = self.dataSource[indexPath.row]
            selectedObjects.append(obj)
        }
        
        self.delegate?.selectionController(self, didSelect: selectedObjects, leadType: self.leadType)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let obj = self.dataSource[indexPath.row] as? Property {
            let cell = tableView.dequeue(SelectionPropertyTableViewCell.self, indexPath: indexPath)
            cell.property = obj
            return cell
        } else if let obj = self.dataSource[indexPath.row] as? Transaction {
            let cell = tableView.dequeue(SelectionTransactionTableViewCell.self, indexPath: indexPath)
            cell.transaction = obj
            return cell
        } else if let obj = self.dataSource[indexPath.row] as? MeetingEvent {
            let cell = tableView.dequeue(SelectionMeetingTableViewCell.self, indexPath: indexPath)
            cell.meeting = obj
            return cell
        } else if let obj = self.dataSource[indexPath.row] as? Task {
            let cell = tableView.dequeue(SelectionTaskTableViewCell.self, indexPath: indexPath)
            cell.task = obj
            return cell
        }
        
        return UITableViewCell()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
