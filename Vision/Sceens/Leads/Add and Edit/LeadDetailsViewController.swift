//
//  LeadDetailsViewController.swift
//  B-more
//
//  Created by Idan Moshe on 17/01/2021.
//

import UIKit
import Contacts
import ContactsUI

class LeadDetailsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum SectionType: Int, CaseIterable {
        case personalDetails, contactButtons, properties, transactions, meetings, tasks, leadQualification
        
        static let sections: Int = 1
        static let rows: Int = SectionType.allCases.count
        
        var height: CGFloat {
            switch self {
            case .personalDetails: return UITableView.automaticDimension // 197.0
            case .contactButtons: return 55.0
            case .properties: return 44.0
            case .tasks: return 44.0
            case .transactions: return 44.0
            case .meetings: return 44.0
            case .leadQualification: return 44.0
            }
        }
        
        var title: String? {
            switch self {
            case .personalDetails: return nil
            case .contactButtons: return nil
            case .properties: return "properties".localized
            case .tasks: return "tasks".localized
            case .transactions: return "transactions".localized
            case .meetings: return "meetings".localized
            case .leadQualification: return "lead_qualification".localized
            }
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var customNavigationBar: UINavigationBar!
    @IBOutlet private weak var saveBarButton: UIBarButtonItem!
    @IBOutlet private weak var closeBarButton: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Variables
    
    // Determine whether we're in add/edit mode.
    var editedLead: Lead?
    
    private lazy var floatButton = Floaty()
    private var deviceContact: DeviceContact?
    private lazy var properties: [Property] = []
    private lazy var transactions: [Transaction] = []
    private lazy var meetings: [MeetingEvent] = []
    private lazy var tasks: [Task] = []
    
    private lazy var viewModel = LeadAddEditViewModel()
    private lazy var propertiesViewModel = PropertiesViewModel()
    
    private lazy var contactPickerViewController: CNContactPickerViewController = {
        let pickerViewController = CNContactPickerViewController()
        pickerViewController.delegate = self
        return pickerViewController
    }()
    
    // MARK: - Lifecycle
    
    deinit {
        debugPrint("Deallocating \(self)")
        self.editedLead = nil
        self.deviceContact = nil
        self.properties.removeAll()
        self.tasks.removeAll()
        self.transactions.removeAll()
        self.meetings.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.setupUI()
        if let lead: Lead = self.editedLead {
            self.loadEditMode(lead: lead)
        }
    }
    
    private func setupUI() {
        let closeButton = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(self.closeScreen)
        )
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(self.onPressSaveBarButton(_:))
        )
        
        if self.editedLead == nil {
            self.customNavigationBar.topItem?.title = "add_lead".localized
        } else {
            self.customNavigationBar.topItem?.title = "edit_lead".localized
        }
        
        if let modifyDate: Date = self.editedLead?.timestamp {
            self.customNavigationBar.topItem?.prompt = "\("last_edit_date".localized): \(DateFormatter.shortFormatter.string(from: modifyDate))"
        }
        
        self.customNavigationBar.topItem?.leftBarButtonItem = closeButton
        self.customNavigationBar.topItem?.rightBarButtonItem = doneButton
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(LeadPersonalDetailsTableViewCell.self)
        self.tableView.register(LeadContactTableViewCell.self)
        self.tableView.register(LeadDetailDisclosureTableViewCell.self)
        self.tableView.register(LeadQualityTableViewCell.self)
                
        self.floatButton.itemImageColor = .darkGray
                
        self.floatButton.addItem("contacts".localized, icon: UIImage(systemName: "person.badge.plus")) { [weak self] (item: FloatyItem) in
            guard let self = self else { return }
            self.showContactScreen()
            self.floatButton.close()
        }
        
        self.floatButton.addItem("properties".localized, icon: UIImage(systemName: "building.2")) { [weak self] (item: FloatyItem) in
            guard let self = self else { return }
            self.showPropertyScreen(isShowOnlyMode: false)
            self.floatButton.close()
        }
        
        self.floatButton.addItem("transactions".localized, icon: UIImage(systemName: "dollarsign.circle")) { [weak self] (item: FloatyItem) in
            guard let self = self else { return }
            self.showTransactionScreen(isShowOnlyMode: false)
            self.floatButton.close()
        }
        
        self.floatButton.addItem("meetings".localized, icon: UIImage(systemName: "person.2")) { [weak self] (item: FloatyItem) in
            guard let self = self else { return }
            self.showMeetingScreen(isShowOnlyMode: false)
            self.floatButton.close()
        }
        
        self.floatButton.addItem("tasks".localized, icon: UIImage(systemName: "list.number")) { [weak self] (item: FloatyItem) in
            guard let self = self else { return }
            self.showTaskScreen(isShowOnlyMode: false)
            self.floatButton.close()
        }
        
        self.floatButton.sticky = true
        self.floatButton.paddingX = self.view.frame.width/2 - self.floatButton.frame.width/2
        self.view.addSubview(self.floatButton)
    }
    
    private func loadEditMode(lead: Lead) {
        self.viewModel.selectedRating = lead.rating
        
        if let properties = lead.properties?.allObjects as? [Property] {
            self.viewModel.selectedProperties = properties
        }
        if let transactions = lead.transactions?.allObjects as? [Transaction] {
            self.viewModel.selectedTransactions = transactions
        }
        if let tasks = lead.tasks?.allObjects as? [Task] {
            self.viewModel.selectedTasks = tasks
        }
        
        if let meetings: Set<String> = lead.meetings, meetings.count > 0 {
            let events: [MeetingEvent] = MeetingService.shared.fetchEvents().filter({ meetings.contains($0.eventIdentifier()) })
            self.viewModel.selectedMeetings = events
        }
        
        if let contactId: String = lead.contactId {
            let contacts = ContactsService.shared.findContacts([contactId])
            if contacts.count > 0 {
                self.deviceContact = DeviceContact(contact: contacts.first!)
            }
        }
        
        self.reloadScreen(animated: true)
    }
    
}

// MARK: - Navigation

extension LeadDetailsViewController {
    
    private func showContactScreen() {
        DispatchMainThreadSafe {
            self.present(self.contactPickerViewController, animated: true, completion: nil)
        }
    }
    
    private func showPropertyScreen(isShowOnlyMode: Bool) {
        DispatchMainThreadSafe {
            let viewController: BaseSelectionTableViewController
            if isShowOnlyMode {
                viewController = BaseSelectionTableViewController(
                    dataSource: self.viewModel.selectedProperties,
                    leadType: .properties,
                    isShowOnlyMode: true
                )
            } else {
                viewController = BaseSelectionTableViewController(
                    dataSource: self.viewModel.getProperties(),
                    leadType: .properties,
                    isShowOnlyMode: false
                )
            }
            
            viewController.delegate = self
            viewController.title = LeadSelectionType.properties.title()
            let navController = viewController.wrappedNavigationController()
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    private func showTransactionScreen(isShowOnlyMode: Bool) {
        DispatchMainThreadSafe {
            let viewController: BaseSelectionTableViewController
            
            if isShowOnlyMode {
                viewController = BaseSelectionTableViewController(
                    dataSource: self.viewModel.selectedTransactions,
                    leadType: .transactions,
                    isShowOnlyMode: true
                )
            } else {
                viewController = BaseSelectionTableViewController(
                    dataSource: self.viewModel.getTransactions(),
                    leadType: .transactions,
                    isShowOnlyMode: false
                )
            }
            
            viewController.delegate = self
            viewController.title = LeadSelectionType.transactions.title()
            let navController = viewController.wrappedNavigationController()
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    private func showMeetingScreen(isShowOnlyMode: Bool) {
        DispatchMainThreadSafe {
            let viewController: BaseSelectionTableViewController
            
            if isShowOnlyMode {
                viewController = BaseSelectionTableViewController(
                    dataSource: self.viewModel.selectedMeetings,
                    leadType: .meetings,
                    isShowOnlyMode: true
                )
            } else {
                viewController = BaseSelectionTableViewController(
                    dataSource: self.viewModel.getMeetings(),
                    leadType: .meetings,
                    isShowOnlyMode: false
                )
            }
            
            viewController.delegate = self
            viewController.title = LeadSelectionType.meetings.title()
            let navController = viewController.wrappedNavigationController()
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    private func showTaskScreen(isShowOnlyMode: Bool) {
        DispatchMainThreadSafe {
            let viewController: BaseSelectionTableViewController
            
            if isShowOnlyMode {
                viewController = BaseSelectionTableViewController(
                    dataSource: self.viewModel.selectedTasks,
                    leadType: .tasks,
                    isShowOnlyMode: true
                )
            } else {
                viewController = BaseSelectionTableViewController(
                    dataSource: self.viewModel.getTasks(),
                    leadType: .tasks,
                    isShowOnlyMode: false
                )
            }
            
            viewController.delegate = self
            viewController.title = LeadSelectionType.tasks.title()
            let navController = viewController.wrappedNavigationController()
            self.present(navController, animated: true, completion: nil)
        }
    }
    
}

// MARK: - Actions

extension LeadDetailsViewController {
    
    @IBAction private func onPressSaveBarButton(_ sender: UIBarButtonItem) {
        var lead: Lead
        if self.editedLead == nil {
            lead = Lead(context: PersistentStorage.shared.mainContext())
        } else {
            lead = self.editedLead!
        }
        
        lead.leadId = UUID()
        lead.timestamp = Date()
        lead.rating = self.viewModel.selectedRating
        lead.contactId = self.deviceContact?.identifier
        lead.properties = NSSet(array: self.viewModel.selectedProperties)
        lead.tasks = NSSet(array: self.viewModel.selectedTasks)
        lead.transactions = NSSet(array: self.viewModel.selectedTransactions)
        
        let meetingsId: [String] = self.viewModel.selectedMeetings.map({ $0.eventIdentifier() })
        lead.meetings = Set<String>(meetingsId)
        
        PersistentStorage.shared.saveContext()
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension LeadDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = SectionType(rawValue: indexPath.row) else { return UITableViewCell() }
        
        if type == .personalDetails {
            let cell = tableView.dequeue(LeadPersonalDetailsTableViewCell.self, indexPath: indexPath)
            cell.contact = self.deviceContact
            return cell
        } else if type == .contactButtons {
            let cell = tableView.dequeue(LeadContactTableViewCell.self, indexPath: indexPath)
            cell.deviceContact = self.deviceContact
            return cell
        } else if type == .leadQualification {
            let cell = tableView.dequeue(LeadQualityTableViewCell.self, indexPath: indexPath)
            cell.delegate = self
            cell.rating = self.viewModel.selectedRating
            return cell
        } else {
            let cell = tableView.dequeue(LeadDetailDisclosureTableViewCell.self, indexPath: indexPath)
            cell.textLabel?.text = type.title
            cell.detailTextLabel?.text = nil
            
            if type == .properties {
                cell.detailTextLabel?.text = self.detailTextLabel(self.viewModel.selectedProperties)
            } else if type == .transactions {
                cell.detailTextLabel?.text = self.detailTextLabel(self.viewModel.selectedTransactions)
            } else if type == .meetings {
                cell.detailTextLabel?.text = self.detailTextLabel(self.viewModel.selectedMeetings)
            } else if type == .tasks {
                cell.detailTextLabel?.text = self.detailTextLabel(self.viewModel.selectedTasks)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SectionType(rawValue: indexPath.row)?.height ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let type = SectionType(rawValue: indexPath.row) else { return }
        
        switch type {
        case .personalDetails:
            break
        case .contactButtons:
            break
        case .properties: self.showPropertyScreen(isShowOnlyMode: true)
        case .transactions: self.showTransactionScreen(isShowOnlyMode: true)
        case .meetings: self.showMeetingScreen(isShowOnlyMode: true)
        case .tasks: self.showTaskScreen(isShowOnlyMode: true)
        case .leadQualification:
            break
        }
    }
    
    // MARK: - Table View Helper Methods
    
    private func detailTextLabel(_ array: [Any]) -> String {
        return array.count > 0 ? "\(array.count)" : "none".localized
    }
    
    private func reloadScreen(animated: Bool) {
        if animated {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        } else {
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - CNContactPickerDelegate

extension LeadDetailsViewController: CNContactPickerDelegate {
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        debugPrint(#function)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        self.deviceContact = DeviceContact(contact: contact)
        self.reloadScreen(animated: true)
    }
    
}

// MARK: - BaseSelectionTableViewControllerDelegate

extension LeadDetailsViewController: BaseSelectionTableViewControllerDelegate {
    
    func selectionController(_ selectionController: BaseSelectionTableViewController, didSelect objects: [Any], leadType: LeadSelectionType) {
        switch leadType {
        case .none:
            break
        case .properties:
            self.viewModel.selectedProperties = objects as! [Property]
        case .transactions:
            self.viewModel.selectedTransactions = objects as! [Transaction]
        case .meetings:
            self.viewModel.selectedMeetings = objects as! [MeetingEvent]
        case .tasks:
            self.viewModel.selectedTasks = objects as! [Task]
        }
        
        self.reloadScreen(animated: true)
    }
    
}

// MARK: - LeadQualityTableViewCellDelegate

extension LeadDetailsViewController: LeadQualityTableViewCellDelegate {
    
    func leadQualityCell(_ leadQualityCell: LeadQualityTableViewCell, didUpdate rating: Double) {
        self.viewModel.selectedRating = rating
    }
    
}
