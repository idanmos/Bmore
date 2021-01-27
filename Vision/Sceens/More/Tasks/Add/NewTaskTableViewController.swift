//
//  NewTaskTableViewController.swift
//  B-more
//
//  Created by Idan Moshe on 13/01/2021.
//

import UIKit
import ContactsUI

class NewTaskTableViewController: UITableViewController {
    
    private enum SectionType: Int, CaseIterable {
        case title = 0
        case status = 1
        case type = 2
        case date = 3
        case contact = 4
        case comments = 5
        case alerts = 6
        
        func title() -> String {
            switch self {
            case .title: return NSLocalizedString("title", comment: "")
            case .status: return NSLocalizedString("status", comment: "")
            case .type: return NSLocalizedString("type", comment: "")
            case .date: return NSLocalizedString("due_date", comment: "")
            case .contact: return NSLocalizedString("contact", comment: "")
            case .comments: return NSLocalizedString("comments", comment: "")
            case .alerts: return NSLocalizedString("alerts", comment: "")
            }
        }
        
        static func sections() -> Int {
            return SectionType.allCases.count
        }
        
        func rows() -> Int {
            switch self {
            case .title: return 1
            case .status: return 1
            case .type: return 1
            case .date: return 2
            case .contact: return 1
            case .comments: return 1
            case .alerts: return 1
            }
        }
        
        func height(indexPath: IndexPath, isExpanded: Bool? = nil) -> CGFloat {
            switch self {
            case .title, .contact, .alerts, .type, .status: return 44.0
            case .date:
                if indexPath.row == 0 {
                    return 55.0
                } else {
                    if let isExpanded: Bool = isExpanded {
                        if isExpanded {
                            return 216.0
                        } else {
                            return 0.0
                        }
                    }
                }
                return UITableView.automaticDimension
            case .comments: return 120.0
            }
        }
    }
    
    // MARK: - Outlets
    
    /// - Tag: Title
    @IBOutlet private weak var titleTextField: UITextField!
    
    /// - Tag: Status
    @IBOutlet private weak var statusSegmentControl: UISegmentedControl!
    
    /// - Tag: Type
    @IBOutlet private weak var typeSegmentControl: UISegmentedControl!
    
    /// - Tag: Date
    @IBOutlet private weak var dateTitleLabel: UILabel!
    @IBOutlet private weak var dateValueLabel: UILabel!
    @IBOutlet private weak var dateSwitch: UISwitch!
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    /// - Tag: Contact
    @IBOutlet private weak var contactTextField: UITextField!
    @IBOutlet private weak var contactAddButton: UIButton!
    @IBOutlet private weak var contactDeleteButton: UIButton!
    
    /// - Tag: Comments
    @IBOutlet weak var commentsTextView: UITextView!
    
    /// - Tag: Alerts
    @IBOutlet private weak var alertTitleLabel: UILabel!
    @IBOutlet private weak var alertSwitch: UISwitch!
    
    // MARK: - Variables
    
    var editedTask: Task?
    private var contactId: String?
    
    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveAndClose))
        return saveButton
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.setupUI()
    }
    
    private func setupUI() {
        self.title = "new_task".localized
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveAndClose))
        
        /// - Tag: Title
        self.titleTextField.placeholder = "title".localized
        self.titleTextField.addTollbar(target: self.titleTextField, action: #selector(self.titleTextField.resignFirstResponder))
        
        /// - Tag: Status
        self.statusSegmentControl.setTitle("pending".localized, forSegmentAt: 0)
        self.statusSegmentControl.setTitle("in_progress".localized, forSegmentAt: 1)
        self.statusSegmentControl.setTitle("closed".localized, forSegmentAt: 2)
        self.statusSegmentControl.setTitle("canceled".localized, forSegmentAt: 3)
        
        /// - Tag: Type
        self.typeSegmentControl.setTitle("call".localized, forSegmentAt: 0)
        self.typeSegmentControl.setTitle("email".localized, forSegmentAt: 1)
        self.typeSegmentControl.setTitle("meeting".localized, forSegmentAt: 2)
        self.typeSegmentControl.setTitle("other".localized, forSegmentAt: 3)
        
        /// - Tag: Date
        self.dateTitleLabel.text = "date".localized
        self.dateValueLabel.text = nil
        self.datePicker.isHidden = true
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.dateValueLabel.isHidden = true
        
        /// - Tag: Contact
        self.contactTextField.placeholder = "contact_details".localized
        
        /// - Tag: Comments
        self.commentsTextView.text = nil
        self.commentsTextView.addTollbar(target: self.commentsTextView, action: #selector(self.commentsTextView.resignFirstResponder))
        
        /// - Tag: Alerts
        self.alertTitleLabel.text = "push_notification".localized
        
        /// - Tag: Edit Mode
        if let _ = self.editedTask {
            self.restore(self.editedTask!)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.sections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SectionType(rawValue: section)?.rows() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let type = SectionType(rawValue: indexPath.section) else { return UITableView.automaticDimension }
        
        var height: CGFloat
        
        if type == .date {
            height = type.height(indexPath: indexPath, isExpanded: self.dateSwitch.isOn)
        } else if type == .alerts {
            height = type.height(indexPath: indexPath, isExpanded: self.alertSwitch.isOn)
        } else {
            height = type.height(indexPath: indexPath)
        }
        
        return height
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let type = SectionType(rawValue: section) else { return nil }
        return type.title()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // guard let type = SectionType(rawValue: indexPath.section) else { return }
    }

}

// MARK: - General Methods

extension NewTaskTableViewController {
    
    private func restore(_ editedTask: Task) {
        self.titleTextField.text = editedTask.title
        self.statusSegmentControl.selectedSegmentIndex = Int(editedTask.status)
        self.typeSegmentControl.selectedSegmentIndex = Int(editedTask.type)
        
        if let date: Date = editedTask.date {
            self.datePicker.date = date
            self.dateSwitch.isOn = true
            self.showDatePicker()
        }
        
        self.contactId = editedTask.contactId
        if let _ = self.contactId {
            let contacts: [CNContact] = ContactsService.shared.findContacts([self.contactId!])
            if let contact: CNContact = contacts.first {
                self.saveAndShow(contact)
            }
        }
        
        self.commentsTextView.text = editedTask.comments
        self.alertSwitch.isOn = editedTask.isPushEnabled
    }
    
    @objc private func saveAndClose() {
        guard let title: String = self.titleTextField.text, !title.isEmpty else {
            self.showAlert(title: "error".localized, message: "title_cannot_be_empty".localized) { (alertAction: UIAlertAction) in
                self.titleTextField.becomeFirstResponder()
            }
            return
        }
        
        if self.alertSwitch.isOn && !self.dateSwitch.isOn {
            AlertViewModel.showAlert(.needPushAndDate)
            return
        }
        
        var configuration: TaskConfiguration
        if let _ = self.editedTask {
            configuration = TaskConfiguration(taskId: self.editedTask!.taskId!)
        } else {
            configuration = TaskConfiguration(taskId: UUID().uuidString)
        }
        
        configuration.title = title
        configuration.status = Application.TaskStatus(rawValue: Int16(self.statusSegmentControl.selectedSegmentIndex))!
        configuration.type = Application.TaskType(rawValue: Int16(self.typeSegmentControl.selectedSegmentIndex))!
        configuration.date = self.dateSwitch.isOn ? self.datePicker.date : nil
        configuration.contactId = self.contactId
        configuration.comments = self.commentsTextView.text
        configuration.isPushEnabled = self.alertSwitch.isOn
        
        if let _ = self.editedTask {
            AppDelegate.sharedDelegate().coreDataStack.edit(self.editedTask!, configuration: configuration)
        } else {
            AppDelegate.sharedDelegate().coreDataStack.save(configuration)
        }
        
        if configuration.isPushEnabled {
            if let _ = configuration.date {
                TaskEvent.perform(.schedule(taskConfiguration: configuration))
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
        
    private func showPickerView(pickerView: UIDatePicker, valueLabel: UILabel) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        pickerView.alpha = 0.0
        valueLabel.alpha = 0.0
        
        UIView.animate(withDuration: 0.25) {
            pickerView.alpha = 1.0
            valueLabel.alpha = 1.0
        } completion: { (isFinished: Bool) in
            pickerView.isHidden = false
            valueLabel.isHidden = false
        }
    }
    
    private func hidePickerView(pickerView: UIDatePicker, valueLabel: UILabel) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        UIView.animate(withDuration: 0.25) {
            pickerView.alpha = 0.0
            valueLabel.alpha = 0.0
        } completion: { (isFinished: Bool) in
            pickerView.isHidden = true
            valueLabel.isHidden = true
        }
    }
    
    private func showDatePicker() {
        self.showPickerView(pickerView: self.datePicker,
                            valueLabel: self.dateValueLabel)
    }
    
    private func hideDatePicker() {
        self.hidePickerView(pickerView: self.datePicker,
                            valueLabel: self.dateValueLabel)
    }
        
}

// MARK: - Actions

extension NewTaskTableViewController {
    
    /// - Tag: Date
    @IBAction func OnPressDatePickerSwitch(_ sender: UISwitch) {
        self.dateValueLabel.text = NSLocalizedString("today", comment: "")
        
        if sender.isOn {
            self.showDatePicker()
        } else {
            self.hideDatePicker()
        }
    }
        
    @IBAction func onDatePickerValueChange(_ sender: UIDatePicker) {
        self.dateValueLabel.text = DateFormatter.dayFormatter.string(from: sender.date)
    }
        
    /// - Tag: Contacts
    @IBAction private func onAddContact(_ sender: Any) {
        ContactsService.shared.showContactsPicker(delegate: self, presenter: self)
    }
    
    @IBAction private func onDeleteContact(_ sender: Any) {
        self.contactTextField.text = nil
    }
    
    /// - Tag: Alerts
    @IBAction func OnPressAlertsDatePickerSwitch(_ sender: UISwitch) {
        //
    }
    
    /// - Tag: Reminders
    
}

// MARK: - CNContactPickerDelegate

extension NewTaskTableViewController: CNContactPickerDelegate {
    
    private func saveAndShow(_ contact: CNContact) {
        self.contactId = contact.identifier
        
        var text: String = "\(contact.givenName) \(contact.familyName)"
        if let phoneNumber: String = contact.phoneNumbers.first?.value.stringValue {
            text += ", "
            text += phoneNumber
        }
        self.contactTextField.text = text
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        debugPrint(#function)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        debugPrint(#function, contact)
        self.saveAndShow(contact)
    }
    
}
