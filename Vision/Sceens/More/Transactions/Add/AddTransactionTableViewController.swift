//
//  AddTransactionTableViewController.swift
//  B-more
//
//  Created by Idan Moshe on 31/12/2020.
//

import UIKit
import LocationPicker
import ContactsUI

class AddTransactionTableViewController: UITableViewController {
    
    // MARK: - Enums
    
    private enum Constants {
        static let defaultCellHeight: CGFloat = 55.0
        static let defaultItemsPerRow: Int = 1
        static let pickerItemsPerRow: Int = 2
        static let pickerCellExpandedHeight: CGFloat = 216.0
        static let pickerCellCollapsedHeight: CGFloat = 0.0
        static let pickerCellRow: Int = 1
    }
    
    private enum SectionType: Int, CaseIterable {
        case statusAndType = 0
        case date = 1
        case location = 2
        case price = 3
        case commision = 4
        case contact = 5
        
        func rows() -> Int {
            switch self {
            case .statusAndType: return 2
            case .date: return 2
            case .location: return 3
            case .price: return 1
            case .commision: return 2
            case .contact: return 1
            }
        }
        
        func height(indexPath: IndexPath, isLocationProperty: Bool) -> CGFloat {
            switch self {
            case .statusAndType: return 44.0
            case .date: return indexPath.row == 0 ? 55.0 : 216.0
            case .location:
                if indexPath.row == 0 {
                    return 44.0
                } else if indexPath.row == 1 && isLocationProperty {
                    return 55.0
                } else if indexPath.row == 2 && !isLocationProperty {
                    return 44.0
                }
                return 0
            case .price: return 55.0
            case .commision: return 44.0
            case .contact: return 44.0
            }
        }
    }
    
    // MARK: - Outlets
    
    /// - Tag: Status
    @IBOutlet private weak var statusTitleLabel: UILabel!
    @IBOutlet private weak var statusSegmentControl: UISegmentedControl!
    
    /// - Tag: Type
    @IBOutlet private weak var typeTitleLabel: UILabel!
    @IBOutlet private weak var typeSegmentControl: UISegmentedControl!
    
    /// - Tag: Date
    @IBOutlet private weak var dateTitleLabel: UILabel!
    @IBOutlet private weak var dateValueLabel: UILabel!
    @IBOutlet private weak var dateSwitch: UISwitch!
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    /// - Tag: Property
    @IBOutlet private weak var locationTitleLabel: UILabel!
    @IBOutlet private weak var locationSegmentControl: UISegmentedControl!
    @IBOutlet private weak var propertyTitleLabel: UILabel!
    @IBOutlet private weak var propertyValueLabel: UILabel!
    @IBOutlet private weak var addressTextField: UITextField!
    
    /// - Tag: Price
    @IBOutlet private weak var priceTitleLabel: UILabel!
    @IBOutlet private weak var priceTextField: UITextField!
    
    /// - Tag: Commision
    @IBOutlet private weak var commisionTitleLabel: UILabel!
    @IBOutlet private weak var commisionSegmentControl: UISegmentedControl!
    @IBOutlet private weak var commisionTextField: UITextField!
    
    /// - Tag: Contact
    @IBOutlet private weak var contactTitleLabel: UILabel!
    @IBOutlet private weak var contactTextField: UITextField!
    @IBOutlet private weak var addContactButton: UIButton!
    @IBOutlet private weak var deleteContactButton: UIButton!
    
    // MARK: - Variables
    
    private var location: Location?
    
    var editedTransaction: Transaction? {
        didSet(newValue) {
            if let _ = newValue {
                self.propertyId = newValue!.propertyId
            }
        }
    }
    
    var propertyId: UUID?
    private var contactId: String?
    
    private lazy var locationPicker: LocationPickerViewController = {
        let locationPicker = LocationPickerViewController()
        locationPicker.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.closeLocationController))
        locationPicker.title = NSLocalizedString("place", comment: "")
        locationPicker.modalPresentationStyle = .fullScreen
        locationPicker.showCurrentLocationButton = true
        locationPicker.useCurrentLocationAsHint = true
        locationPicker.selectCurrentLocationInitially = true
        return locationPicker
    }()
    
    // MARK: - Class Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.title = NSLocalizedString("new_transaction", comment: "")
        
        self.setupUI()
    }
    
    private func setupUI() {
        /// - Tag: Status
        self.statusTitleLabel.text = NSLocalizedString("status", comment: "")
        self.statusSegmentControl.setTitle(NSLocalizedString("pending", comment: ""), forSegmentAt: 0)
        self.statusSegmentControl.setTitle(NSLocalizedString("closed", comment: ""), forSegmentAt: 1)
        self.statusSegmentControl.setTitle(NSLocalizedString("canceled", comment: ""), forSegmentAt: 2)
        
        /// - Tag: Type
        self.typeTitleLabel.text = NSLocalizedString("type", comment: "")
        self.typeSegmentControl.setTitle(NSLocalizedString("none", comment: ""), forSegmentAt: 0)
        self.typeSegmentControl.setTitle(NSLocalizedString("expense", comment: ""), forSegmentAt: 1)
        self.typeSegmentControl.setTitle(NSLocalizedString("revenue", comment: ""), forSegmentAt: 2)
        
        /// - Tag: Date
        self.dateTitleLabel.text = NSLocalizedString("date", comment: "")
        self.dateValueLabel.text = nil
        self.datePicker.isHidden = true
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.dateValueLabel.isHidden = true
        
        /// - Tag: Location
        self.locationTitleLabel.text = NSLocalizedString("location", comment: "")
        self.locationSegmentControl.setTitle(NSLocalizedString("property", comment: ""), forSegmentAt: 0)
        self.locationSegmentControl.setTitle(NSLocalizedString("address", comment: ""), forSegmentAt: 1)
        self.propertyTitleLabel.text = NSLocalizedString("property", comment: "")
        self.propertyValueLabel.text = nil
        self.addressTextField.placeholder = NSLocalizedString("address", comment: "")
        self.addressTextField.addMapTollbar(target: self, action: #selector(self.showLocationPicker))
        
        /// - Tag: Price
        self.priceTitleLabel.text = NSLocalizedString("total_price", comment: "")
        self.priceTextField.placeholder = NSLocalizedString("price", comment: "")
        self.priceTextField.keyboardType = .decimalPad
        self.priceTextField.addTollbar(target: self, action: #selector(self.closeKeyboard))
        
        /// - Tag: Commision
        self.commisionTitleLabel.text = NSLocalizedString("commision", comment: "")
        self.commisionSegmentControl.setTitle(NSLocalizedString("percent", comment: ""), forSegmentAt: 0)
        self.commisionSegmentControl.setTitle(NSLocalizedString("amount", comment: ""), forSegmentAt: 1)
        self.onCommisionChange(self.commisionSegmentControl as Any)
        self.commisionTextField.keyboardType = .decimalPad
        self.commisionTextField.addTollbar(target: self, action: #selector(self.closeKeyboard))
        
        /// - Tag: Contact
        self.contactTitleLabel.text = NSLocalizedString("contact", comment: "")
        self.contactTextField.placeholder = NSLocalizedString("contact_details", comment: "")
        self.contactTextField.isUserInteractionEnabled = false
        
        /// - Tag: Edit Mode
        if let obj: Transaction = self.editedTransaction {
            /// - Tag: Status
            if let status = Application.TransactionStatus(rawValue: obj.status) {
                switch status {
                case .pending:
                    self.statusSegmentControl.selectedSegmentIndex = 0
                case .closed:
                    self.statusSegmentControl.selectedSegmentIndex = 1
                case .canceled:
                    self.statusSegmentControl.selectedSegmentIndex = 2
                }
            }
            
            /// - Tag: Type
            if let type = Application.TransactionType(rawValue: obj.type) {
                switch type  {
                case .none:
                    self.typeSegmentControl.selectedSegmentIndex = 0
                case .expense:
                    self.typeSegmentControl.selectedSegmentIndex = 1
                case .revenue:
                    self.typeSegmentControl.selectedSegmentIndex = 2
                }
            }
            
            /// - Tag: Date
            if let date: Date = obj.date {
                self.datePicker.date = date
                self.dateValueLabel.text = DateFormatter.dayFormatter.string(from: date)
                self.dateSwitch.isOn = true
                
                self.showPickerView()
            }
            
            /// - Tag: Location
            if let locationType = Application.TransactionLocationType(rawValue: obj.locationType) {
                switch locationType {
                case .property:
                    self.locationSegmentControl.selectedSegmentIndex = 0
                case .address:
                    self.locationSegmentControl.selectedSegmentIndex = 1
                }
            }
            
            if let _ = obj.placemark {
                let locationObject = Location(name: obj.address, location: obj.location, placemark: obj.placemark!)
                self.location = locationObject
                self.addressTextField.text = locationObject.title
            }
            
            /// - Tag: Price
            if let _ = obj.price {
                self.priceTextField.text = obj.price!.stringValue
            }
            
            /// - Tag: Commision
            if let commision: NSDecimalNumber = obj.commission, NSDecimalNumber.notANumber != commision {
                self.commisionTextField.text = commision.stringValue
                
                if let commisionType = Application.TransactionCommisionType(rawValue: obj.commisionType) {
                    switch commisionType {
                    case .percent:
                        self.commisionSegmentControl.selectedSegmentIndex = 0
                    case .amount:
                        self.commisionSegmentControl.selectedSegmentIndex = 1
                    }
                }
            }
            
            /// - Tag: Contact
            if let _ = obj.contactId {
                let contacts: [CNContact] = ContactsService.shared.findContacts([obj.contactId!])
                if let contact: CNContact = contacts.first {
                    self.saveAndShow(contact)
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let type = SectionType(rawValue: section) else { return 0 }
        return type.rows()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SectionType(rawValue: indexPath.section) else { return 0 }
        
        if section == .date && indexPath.row == Constants.pickerCellRow {
            return self.dateSwitch.isOn ? Constants.pickerCellExpandedHeight : Constants.pickerCellCollapsedHeight
        }
        
        let isLocationProperty: Bool = (self.locationSegmentControl.selectedSegmentIndex == 0)
        return section.height(indexPath: indexPath, isLocationProperty: isLocationProperty)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - Actions

extension AddTransactionTableViewController {
    
    @IBAction private func onPressSave(_ sender: Any) {
        let configuration = TransactionConfiguration(status: self.statusSegmentControl.selectedSegmentIndex,
                                                     type: self.typeSegmentControl.selectedSegmentIndex,
                                                     date: self.datePicker.date,
                                                     locationType: self.locationSegmentControl.selectedSegmentIndex,
                                                     propertyId: self.propertyId,
                                                     address: self.location?.title,
                                                     location: self.location?.location,
                                                     placemark: self.location?.placemark,
                                                     price: self.priceTextField.text,
                                                     commisionType: self.commisionSegmentControl.selectedSegmentIndex,
                                                     commision: self.commisionTextField.text,
                                                     contactId: self.contactId)
        
        if let obj: Transaction = self.editedTransaction {
            TransactionsViewModel.edit(obj, configuration: configuration)
        } else {
            TransactionsViewModel.save(configuration)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    /// - Tag: Status
    
    @IBAction private func onStatusChange(_ sender: Any) {
        //
    }
    
    /// - Tag: Type
    
    @IBAction private func onTypeChange(_ sender: Any) {
        //
    }
    
    /// - Tag: Date
    
    @IBAction private func onDateSwitchChange(_ sender: Any) {
        guard let dateSwitch = sender as? UISwitch else { return }
        
        self.dateValueLabel.text = NSLocalizedString("today", comment: "")
        
        if dateSwitch.isOn {
            self.showPickerView()
        } else {
            self.hidePickerView()
        }
    }
    
    @IBAction private func onDatePickerChange(_ sender: Any) {
        guard let picker = sender as? UIDatePicker else { return }
        self.dateValueLabel.text = DateFormatter.dayFormatter.string(from: picker.date)
    }
    
    ///  - Tag: Location
    
    @IBAction private func onLocationChange(_ sender: Any) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    @IBAction private func onPressPropertyInfo(_ sender: Any) {
        guard let propertyId: UUID = self.propertyId else { return }
        guard let obj: Property = PropertyViewModel.fetchProperty(by: propertyId) else { return }
        
        let propertiesStoryboard = UIStoryboard(name: "Properties", bundle: nil)
        guard let detailsViewController = propertiesStoryboard.instantiateViewController(withIdentifier: PropertyDetailsViewController.className())
                as? PropertyDetailsViewController
        else { return }
        
        detailsViewController.property = obj
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    @IBAction private func onPressAddProperty(_ sender: Any) {
        let viewController = AddTransactionPropertyViewController(nibName: AddTransactionPropertyViewController.className(), bundle: nil)
        viewController.delegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func onPressDeleteProperty(_ sender: Any) {
        self.propertyId = nil
        self.propertyValueLabel.text = nil
    }
    
    /// - Tag: Commision
    
    @IBAction private func onCommisionChange(_ sender: Any) {
        guard let control = sender as? UISegmentedControl else { return }
        
        if control.selectedSegmentIndex == 0 {
            self.commisionTextField.placeholder = NSLocalizedString("percentage", comment: "")
        } else if control.selectedSegmentIndex == 1 {
            self.commisionTextField.placeholder = NSLocalizedString("amount", comment: "")
        }
    }
    
    /// - Tag: Contact
    
    @IBAction private func onAddContact(_ sender: Any) {
        ContactsService.shared.showContactsPicker(delegate: self, presenter: self)
    }
    
    @IBAction private func onDeleteContact(_ sender: Any) {
        self.contactTextField.text = nil
    }
    
}

// MARK: - General Methods

extension AddTransactionTableViewController {
    
    @objc private func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    private func showPickerView() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        self.datePicker.alpha = 0.0
        self.dateValueLabel.alpha = 0.0
        
        UIView.animate(withDuration: CATransaction.animationDuration()) {
            self.datePicker.alpha = 1.0
            self.dateValueLabel.alpha = 1.0
        } completion: { (isFinished: Bool) in
            self.datePicker.isHidden = false
            self.dateValueLabel.isHidden = false
        }
    }
    
    private func hidePickerView() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        UIView.animate(withDuration: CATransaction.animationDuration()) {
            self.datePicker.alpha = 0.0
            self.dateValueLabel.alpha = 0.0
        } completion: { (isFinished: Bool) in
            self.datePicker.isHidden = true
            self.dateValueLabel.isHidden = true
        }
    }
    
    @objc private func showLocationPicker() {
        self.view.endEditing(true)
        
        self.locationPicker.completion = { location in
            guard let location = location else { return }
            self.location = location
            self.addressTextField.text = location.title
        }

        let navController = UINavigationController(rootViewController: self.locationPicker)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
}

// MARK: - AddTransactionPropertyTableViewControllerDelegate

extension AddTransactionTableViewController: AddTransactionPropertyViewControllerDelegate {
    
    func addTransactionPropertyController(_ addTransactionPropertyController: AddTransactionPropertyViewController, didSelect property: Property) {
        self.propertyId = property.uuid
        
        var completeString: String = ""
        
        if let address: String = property.address {
            completeString += address
        } else {
            let type: String = Application.AssetType(rawValue: Int(property.type))!.localized()
            completeString += type
            
            if let priceString = property.price, let priceInt = Int(priceString) {
                let priceNumber = NSNumber(integerLiteral: priceInt)
                
                if let result = Application.priceFormatter.string(from: priceNumber) {
                    completeString += ", "
                    completeString += result
                }
            }
        }
        
        self.propertyValueLabel.text = completeString
    }
    
}

// MARK: - Location Picker

extension AddTransactionTableViewController {
    
    @objc private func closeLocationController() {
        self.locationPicker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - CNContactPickerDelegate

extension AddTransactionTableViewController: CNContactPickerDelegate {
    
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
