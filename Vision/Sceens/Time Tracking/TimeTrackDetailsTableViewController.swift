//
//  TimeTrackDetailsTableViewController.swift
//  Vision
//
//  Created by Idan Moshe on 16/12/2020.
//

import UIKit

class TimeTrackDetailsTableViewController: UITableViewController {
    
    enum DateState: Int {
        case start, end
    }
    
    private var selectedCell: IndexPath?
    
    var timeTrack: TimeTrack?
    var startDate: Date?
    var endDate: Date?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("time_track_new_day", comment: "")
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(DatePickerTableViewCell.self)
        
        if let timeTrack: TimeTrack = self.timeTrack {
            self.startDate = timeTrack.startDate
            self.endDate = timeTrack.endDate
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(DatePickerTableViewCell.self, indexPath: indexPath)
        cell.delegate = self
        
        if indexPath.row == 0 {
            cell.tag = DateState.start.rawValue
            cell.datePickerTitleLabel.text = NSLocalizedString("start", comment: "")
            
            if let startDate: Date = self.startDate {
                cell.datePickerValueLabel.text = self.dateFormatter.string(from: startDate)
            } else {
                cell.datePickerValueLabel.text = NSLocalizedString("not_yet_defined", comment: "")
            }
        } else if indexPath.row == 1 {
            cell.tag = DateState.end.rawValue
            cell.datePickerTitleLabel.text = NSLocalizedString("end", comment: "")
            
            if let endDate: Date = self.endDate {
                cell.datePickerValueLabel.text = self.dateFormatter.string(from: endDate)
            } else {
                cell.datePickerValueLabel.text = NSLocalizedString("not_yet_defined", comment: "")
            }
        }
        
        if let selectedCell = self.selectedCell, selectedCell == indexPath {
            cell.toggle()
        } else {
            cell.collapse()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell = indexPath
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

// MARK: - Actions

extension TimeTrackDetailsTableViewController {
    
    @IBAction private func onPressSave(_ sender: Any) {
        if let timeTrack: TimeTrack = self.timeTrack {
            timeTrack.startDate = self.startDate
            timeTrack.endDate = self.endDate
            PersistentStorage.shared.saveContext()
        }
        self.navigationController?.popViewController(animated: true)
    }    
    
}

// MARK: - DatePickerTableViewCellDelegate

extension TimeTrackDetailsTableViewController: DatePickerTableViewCellDelegate {
    
    func pickerCell(_ pickerCell: DatePickerTableViewCell, didChange date: Date) {
        guard let tag = DateState(rawValue: pickerCell.tag) else { return }
        
        if tag == .start {
            self.startDate = date
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! DatePickerTableViewCell
            cell.datePickerValueLabel.text = self.dateFormatter.string(from: date)
        } else if tag == .end {
            self.endDate = date
            let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! DatePickerTableViewCell
            cell.datePickerValueLabel.text = self.dateFormatter.string(from: date)
        }
    }
    
}
