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
    private var isShowOnlyMode: Bool = false
    
    init(dataSource: [Any], leadType: LeadSelectionType, isShowOnlyMode: Bool) {
        super.init(style: .plain)
        self.view.frame = UIScreen.main.bounds
        self.dataSource = dataSource
        self.leadType = leadType
        self.isShowOnlyMode = isShowOnlyMode
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
                        
        // register cells
        self.tableView.register(SelectionPropertyTableViewCell.self)
        self.tableView.register(SelectionTransactionTableViewCell.self)
        self.tableView.register(SelectionTaskTableViewCell.self)
        self.tableView.register(SelectionMeetingTableViewCell.self)
        
        self.tableView.register(PropertyTableViewCell.self)
        self.tableView.register(SingleTransactionTableViewCell.self)
        self.tableView.register(ShowMeetingTableViewCell.self)
        self.tableView.register(ShowTaskTableViewCell.self)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isShowOnlyMode {
            self.tableView.allowsSelection = false
            self.tableView.allowsMultipleSelection = false
        } else {
            self.tableView.allowsSelection = true
            self.tableView.allowsMultipleSelection = true
        }
        
        if self.isShowOnlyMode {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIView(frame: .zero))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .save,
                target: self,
                action: #selector(self.saveAndClose(_:))
            )
        }
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
            if self.isShowOnlyMode {
                let cell = tableView.dequeue(PropertyTableViewCell.self, indexPath: indexPath)
                cell.configure(obj)
                return cell
            } else {
                let cell = tableView.dequeue(SelectionPropertyTableViewCell.self, indexPath: indexPath)
                cell.property = obj
                return cell
            }
        } else if let obj = self.dataSource[indexPath.row] as? Transaction {
            if self.isShowOnlyMode {
                let cell = tableView.dequeue(SingleTransactionTableViewCell.self, indexPath: indexPath)
                cell.configure(obj)
                return cell
            } else {
                let cell = tableView.dequeue(SelectionTransactionTableViewCell.self, indexPath: indexPath)
                cell.transaction = obj
                return cell
            }
        } else if let obj = self.dataSource[indexPath.row] as? MeetingEvent {
            if self.isShowOnlyMode {
                let cell = tableView.dequeue(ShowMeetingTableViewCell.self, indexPath: indexPath)
                cell.meeting = obj
                return cell
            } else {
                let cell = tableView.dequeue(SelectionMeetingTableViewCell.self, indexPath: indexPath)
                cell.meeting = obj
                return cell
            }
        } else if let obj = self.dataSource[indexPath.row] as? Task {
            if self.isShowOnlyMode {
                let cell = tableView.dequeue(ShowTaskTableViewCell.self, indexPath: indexPath)
                cell.task = obj
                return cell
            } else {
                let cell = tableView.dequeue(SelectionTaskTableViewCell.self, indexPath: indexPath)
                cell.task = obj
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.isShowOnlyMode else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let obj = self.dataSource[indexPath.row] as? Property {
            self.showPropertyScreen(obj)
        } else if let obj = self.dataSource[indexPath.row] as? Transaction {
            self.showTransactionScreen(obj)
        } else if let obj = self.dataSource[indexPath.row] as? MeetingEvent {
            MeetingService.shared.show(presenter: self, event: obj.event)
        } else if let obj = self.dataSource[indexPath.row] as? Task {
            self.showTaskScreen(obj)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint(#function, segue, sender as Any)
    }
    
    private func showPropertyScreen(_ property: Property) {
        let propertyStoryboard = FactoryController.Screen.properties.storyboard
        guard let propertyDetailsController = propertyStoryboard
                .instantiateViewController(withIdentifier: PropertyDetailsViewController.className())
                as? PropertyDetailsViewController
        else { return }
        propertyDetailsController.property = property
        self.navigationController?.pushViewController(propertyDetailsController, animated: true)
    }
    
    private func showTransactionScreen(_ transaction: Transaction) {
        if let addTransactionController = UIStoryboard(name: "More", bundle: nil)
            .instantiateViewController(withIdentifier: AddTransactionTableViewController.className())
            as? AddTransactionTableViewController {
            addTransactionController.editedTransaction = transaction
            self.navigationController?.pushViewController(addTransactionController, animated: true)
        }
    }
    
    private func showTaskScreen(_ task: Task) {
        guard let newTaskController = UIStoryboard(name: "Tasks", bundle: nil)
                .instantiateViewController(withIdentifier: NewTaskTableViewController.className())
                as? NewTaskTableViewController
        else { return }
        
        newTaskController.editedTask = task
        
        self.navigationController?.pushViewController(newTaskController, animated: true)
    }

}
