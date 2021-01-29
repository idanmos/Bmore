//
//  AddTransactionTableViewController.swift
//  B-more
//
//  Created by Idan Moshe on 31/12/2020.
//

import UIKit

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
        case price = 2
        case commision = 3
        
        func rows() -> Int {
            switch self {
            case .statusAndType: return 2
            case .date: return 2
            case .price: return 1
            case .commision: return 2
            }
        }
        
        func height(indexPath: IndexPath) -> CGFloat {
            switch self {
            case .statusAndType: return 44.0
            case .date: return indexPath.row == 0 ? 55.0 : 216.0
            case .price: return 55.0
            case .commision: return 44.0
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
    
    /// - Tag: Price
    @IBOutlet private weak var priceTitleLabel: UILabel!
    @IBOutlet private weak var priceTextField: UITextField!
    
    /// - Tag: Commision
    @IBOutlet private weak var commisionTitleLabel: UILabel!
    @IBOutlet private weak var commisionSegmentControl: UISegmentedControl!
    @IBOutlet private weak var commisionTextField: UITextField!
    
    // MARK: - Variables
        
    var editedTransaction: Transaction?
    
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
        return section.height(indexPath: indexPath)
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
                                                     price: self.priceTextField.text,
                                                     commisionType: self.commisionSegmentControl.selectedSegmentIndex,
                                                     commision: self.commisionTextField.text)
        
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
    
    /// - Tag: Commision
    
    @IBAction private func onCommisionChange(_ sender: Any) {
        guard let control = sender as? UISegmentedControl else { return }
        
        if control.selectedSegmentIndex == 0 {
            self.commisionTextField.placeholder = NSLocalizedString("percentage", comment: "")
        } else if control.selectedSegmentIndex == 1 {
            self.commisionTextField.placeholder = NSLocalizedString("amount", comment: "")
        }
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
}
