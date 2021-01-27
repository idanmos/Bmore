//
//  TimeTrackingTableViewController.swift
//  Vision
//
//  Created by Idan Moshe on 15/12/2020.
//

import UIKit
import CoreData

class TimeTrackingTableViewController: UITableViewController {
    
    enum Constants {
        static let segueToDetails: String = "SegueToDetails"
    }
    
    enum PickerType: Int {
        case start, end
    }
    
    private let viewModel = TimeTrackingViewModel()
    
    private lazy var datePickerController: DatePickerViewController = {
        let picker = DatePickerViewController()
        picker.modalPresentationStyle = .overFullScreen
        picker.delegate = self
        return picker
    }()
    
    private lazy var dataProvider: TimeTrackingProvider = {
        return TimeTrackingProvider(with: AppDelegate.sharedDelegate().coreDataStack.persistentContainer,
                                    fetchedResultsControllerDelegate: self)
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.title = NSLocalizedString("time_tracking", comment: "")
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(CalendarEventTableViewCell.self)
        
        // self.viewModel.fetchTimeTrack()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows: Int = self.dataProvider.fetchedResultsController.fetchedObjects?.count ?? 0
        
//        if rows == 0 {
//            NoDataView.show(on: self.view)
//        } else {
//            NoDataView.hide(from: self.view)
//        }
        
        return rows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(CalendarEventTableViewCell.self, indexPath: indexPath)
        let timeTrack: TimeTrack = self.dataProvider.fetchedResultsController.object(at: indexPath)
        
        cell.eventTitleLabel.text = NSLocalizedString("start_hour", comment: "")
        cell.eventSubtitleLabel.text = NSLocalizedString("end_hour", comment: "")
        
        if let startDate: Date = timeTrack.startDate {
            cell.eventTopValueLabel.text = self.dateFormatter.string(from: startDate)
        } else {
            cell.eventTopValueLabel.text = NSLocalizedString("not_yet_defined", comment: "")
        }
        
        if let endDate: Date = timeTrack.endDate {
            cell.eventBottomValueLabel.text = self.dateFormatter.string(from: endDate)
        } else {
            cell.eventBottomValueLabel.text = NSLocalizedString("not_yet_defined", comment: "")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timeTrack: TimeTrack = self.dataProvider.fetchedResultsController.object(at: indexPath)
        self.performSegue(withIdentifier: TimeTrackingTableViewController.Constants.segueToDetails, sender: timeTrack)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let timeTrack: TimeTrack = self.dataProvider.fetchedResultsController.object(at: indexPath)
            self.dataProvider.delete(timeTrack: timeTrack) {
                tableView.reloadData()
            }
        } else if editingStyle == .insert {
        }
    }

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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TimeTrackingTableViewController.Constants.segueToDetails,
           let destinationViewController = segue.destination as? TimeTrackDetailsTableViewController,
           let timeTrack = sender as? TimeTrack {
            destinationViewController.timeTrack = timeTrack
//            destinationViewController.startDate = timeTrack.startDate
//            destinationViewController.endDate = timeTrack.endDate
        }
    }

}

// MARK: - Actions

extension TimeTrackingTableViewController {
    
    @IBAction private func onPressEdit(_ sender: Any) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
    
    @IBAction private func onPressAdd(_ sender: Any) {
        self.viewModel.showStartOrEnd(presenter: self) { (startAction: UIAlertAction) in
            self.viewModel.showDatePickerController(tag: TimeTrackingTableViewController.PickerType.start.rawValue,
                                                    title: NSLocalizedString("time_tracking_start_shift", comment: ""),
                                                    delegate: self, presenter: self)
        } endHandler: { (endAction: UIAlertAction) in
            self.viewModel.showDatePickerController(tag: TimeTrackingTableViewController.PickerType.end.rawValue,
                                                    title: NSLocalizedString("time_tracking_end_shift", comment: ""),
                                                    delegate: self, presenter: self)
        }
    }
    
}

// MARK: - DatePickerViewControllerDelegate

extension TimeTrackingTableViewController: DatePickerViewControllerDelegate {
    
    func pickerController(_ pickerController: DatePickerViewController, didFinishPicking date: Date) {
        pickerController.dismiss(animated: true, completion: nil)
                
        guard let tag = TimeTrackingTableViewController.PickerType(rawValue: pickerController.view.tag) else { return }
        
        switch tag {
        case .start:
            self.dataProvider.addTimeTrack(startDate: date, context: self.dataProvider.persistentContainer.viewContext) { (timeTrack: TimeTrack) in
                debugPrint(#file, #function, "add start date")
            }
        case .end:
            self.dataProvider.addTimeTrack(endDate: date, context: self.dataProvider.persistentContainer.viewContext) { (timeTrack: TimeTrack) in
                debugPrint(#file, #function, "add end date")
            }
        }
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        debugPrint(dateformatter.string(from: date))
    }
    
    func pickerControllerDidCancel(_ pickerController: DatePickerViewController) {
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    
}

// MARK: - NSFetchedResultsControllerDelegate

extension TimeTrackingTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}
