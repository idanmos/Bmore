//
//  NewTaskTableViewController.swift
//  B-more
//
//  Created by Idan Moshe on 13/01/2021.
//

import UIKit

class NewTaskTableViewController: UITableViewController {
    
    private enum SectionType: Int, CaseIterable {
        case title = 0
        case status = 1
        case type = 2
        case date = 3
        case contact = 4
        case comments = 5
        case alerts = 6
        case reminders = 7
        
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
            case .alerts: return 2
            case .reminders: return 1
            }
        }
        
        func height(indexPath: IndexPath, isExpanded: Bool? = nil) -> CGFloat {
            switch self {
            case .title: return 44.0
            case .status: return 44.0
            case .type: return 44.0
            case .date, .alerts:
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
            case .contact: return 44.0
            case .comments: return 120.0
            case .reminders: return 44.0
            }
        }
    }
    
    @IBOutlet private weak var dateValueLabel: UILabel!
    @IBOutlet private weak var dateSwitch: UISwitch!
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    @IBOutlet private weak var alertValueLabel: UILabel!
    @IBOutlet private weak var alertsSwitch: UISwitch!
    @IBOutlet private weak var alertDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.sections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SectionType(rawValue: section)?.rows() ?? 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let type = SectionType(rawValue: indexPath.section) else { return UITableView.automaticDimension }
        
        var height: CGFloat
        
        if type == .date {
            height = type.height(indexPath: indexPath, isExpanded: self.dateSwitch.isOn)
        } else if type == .alerts {
            height = type.height(indexPath: indexPath, isExpanded: self.alertsSwitch.isOn)
        } else {
            height = type.height(indexPath: indexPath)
        }
        
        return height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

// MARK: - General Methods

extension NewTaskTableViewController {
    
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
    
    private func showAlertDatePicker() {
        self.showPickerView(pickerView: self.alertDatePicker,
                            valueLabel: self.alertValueLabel)
    }
    
    private func hideAlertDatePicker() {
        self.hidePickerView(pickerView: self.alertDatePicker,
                            valueLabel: self.alertValueLabel)
    }
        
}

// MARK: - Actions

extension NewTaskTableViewController {
    
    @IBAction func OnPressDatePickerSwitch(_ sender: UISwitch) {
        self.dateValueLabel.text = NSLocalizedString("today", comment: "")
        
        if sender.isOn {
            self.showDatePicker()
        } else {
            self.hideDatePicker()
        }
    }
    
    @IBAction func OnPressAlertsDatePickerSwitch(_ sender: UISwitch) {
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
    
    @IBAction func onAlertsDatePickerValueChange(_ sender: UIDatePicker) {
        self.alertValueLabel.text = DateFormatter.dayFormatter.string(from: sender.date)
    }
    
}
