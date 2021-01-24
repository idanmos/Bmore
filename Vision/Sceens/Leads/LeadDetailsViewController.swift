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
    private lazy var dataSource: [SectionType] = SectionType.allCases
    private var deviceContact: DeviceContact?
    private lazy var properties: [Property] = []
    private lazy var propertiesViewModel = PropertiesViewModel()
    
    private lazy var contactPickerViewController: CNContactPickerViewController = {
        let pickerViewController = CNContactPickerViewController()
        pickerViewController.delegate = self
        return pickerViewController
    }()
    
    // MARK: - Lifecycle
    
    deinit {
        debugPrint("dealloc \(self)")
        self.editedLead = nil
        self.deviceContact = nil
        self.properties.removeAll()
        self.dataSource.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
        
    private func setupUI() {
        let closeButton = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(self.onPressCloseBarButton(_:))
        )
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(self.onPressSaveBarButton(_:))
        )
        
        self.customNavigationBar.topItem?.leftBarButtonItem = closeButton
        self.customNavigationBar.topItem?.rightBarButtonItem = doneButton
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(LeadPersonalDetailsTableViewCell.self)
        self.tableView.register(LeadContactTableViewCell.self)
        self.tableView.register(LeadDetailDisclosureTableViewCell.self)
                
        self.floatButton.itemImageColor = .darkGray
                
        self.floatButton.addItem("contacts".localized, icon: UIImage(systemName: "person.badge.plus")) { [weak self] (item: FloatyItem) in
            guard let self = self else { return }
            self.present(self.contactPickerViewController, animated: true, completion: nil)
            self.floatButton.close()
        }
        
        self.floatButton.addItem("properties".localized, icon: UIImage(systemName: "building.2")) { [weak self] (item: FloatyItem) in
            guard let self = self else { return }
            let viewController = PropertySelectionViewController(viewModel: self.propertiesViewModel)
            viewController.selectionDelegate = self
            let navController = UINavigationController(rootViewController: viewController)
            self.present(navController, animated: true, completion: nil)
            self.floatButton.close()
        }
        
        self.floatButton.addItem("transactions".localized, icon: UIImage(systemName: "dollarsign.circle")) { (item: FloatyItem) in
            //
            self.floatButton.close()
        }
        
        self.floatButton.addItem("meetings".localized, icon: UIImage(systemName: "person.2")) { (item: FloatyItem) in
            //
            self.floatButton.close()
        }
        
        self.floatButton.addItem("tasks".localized, icon: UIImage(systemName: "list.number")) { (item: FloatyItem) in
            //
            self.floatButton.close()
        }
        
        self.floatButton.sticky = true
        self.floatButton.paddingX = self.view.frame.width/2 - self.floatButton.frame.width/2
        self.view.addSubview(self.floatButton)
    }
    
}

// MARK: - Navigation

extension LeadDetailsViewController {}

// MARK: - Actions

extension LeadDetailsViewController {
    
    @IBAction private func onPressCloseBarButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func onPressSaveBarButton(_ sender: UIBarButtonItem) {
        //
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension LeadDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
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
        } else {
            let cell = tableView.dequeue(LeadDetailDisclosureTableViewCell.self, indexPath: indexPath)
            cell.textLabel?.text = type.title
            cell.detailTextLabel?.text = nil
            
            if type == .properties {
                if self.properties.count > 0 {
                    cell.detailTextLabel?.text = "\(self.properties.count)"
                } else {
                    cell.detailTextLabel?.text = "none".localized
                }
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
        
        if type == .properties {
            let viewController = PropertiesTableViewController(properties: self.properties)
            let navController = UINavigationController(rootViewController: viewController)
            self.present(navController, animated: true, completion: nil)
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
//        self.viewModel.add(contacts)
        
//        let rows: [IndexPath] = [
//            IndexPath(row: SectionType.personalDetails.rawValue, section: 0),
//            IndexPath(row: SectionType.contactButtons.rawValue, section: 0)
//        ]
        self.tableView.reloadData()
    }
    
}

// MARK: - PropertySelectionViewControllerDelegate

extension LeadDetailsViewController: PropertySelectionViewControllerDelegate {
    
    var allowsMultipleSelection: Bool {
        return true
    }
    
    var selectedProperties: [Property] {
        return self.properties
    }
    
    func propertyController(_ propertyController: PropertySelectionViewController, didSelect properties: [Property]) {
        propertyController.dismiss(animated: true, completion: nil)
        
        self.properties = properties
                
        self.tableView.reloadData()
    }
    
}
