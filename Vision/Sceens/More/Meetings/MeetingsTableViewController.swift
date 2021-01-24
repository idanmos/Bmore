//
//  MeetingsTableViewController.swift
//  Vision
//
//  Created by Idan Moshe on 27/12/2020.
//

import UIKit

class MeetingsTableViewController: UITableViewController {
    
    private let viewModel = MeetingsViewModel()
    
    private lazy var addBarButton: UIBarButtonItem = {
        let control = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onPressAddButton(_:)))
        return control
    }()
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if let advancedController = parent as? MoreViewController {
            if Application.isHebrew() {
                advancedController.navigationItem.leftBarButtonItem = self.addBarButton
                advancedController.navigationItem.rightBarButtonItem = self.editButtonItem
            } else {
                advancedController.navigationItem.leftBarButtonItem = self.editButtonItem
                advancedController.navigationItem.rightBarButtonItem = self.addBarButton
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(MeetingTableViewCell.self)
        
        self.viewModel.requestAccess { [weak self] (accessGranted: Bool, error: Error?) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.viewModel.fetchEvents()
                self.tableView.reloadData()
            }
        }
        
        self.viewModel.eventsObserver = {
            DispatchQueue.main.async {
                self.viewModel.fetchEvents()
                self.tableView.reloadData()
            }
        }
    }
    
    deinit {
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(MeetingTableViewCell.self, indexPath: indexPath)
        let event: MeetingEvent = self.viewModel.events[indexPath.row]
        cell.tag = indexPath.row
        cell.delegate = self
        cell.configure(event)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let event: MeetingEvent = self.viewModel.events[indexPath.row]
            self.viewModel.delete(event: event.event)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - MeetingTableViewCellDelegate

extension MeetingsTableViewController: MeetingTableViewCellDelegate {
    
    func meetingCellOnPressShow(_ meetingCell: MeetingTableViewCell) {
        let indexPath = IndexPath(row: meetingCell.tag, section: 0)
        let event: MeetingEvent = self.viewModel.events[indexPath.row]
        self.viewModel.show(presenter: self, event: event.event)
        self.tableView.reloadData()
    }
    
    func meetingCellOnPressEdit(_ meetingCell: MeetingTableViewCell) {
        let indexPath = IndexPath(row: meetingCell.tag, section: 0)
        let event: MeetingEvent = self.viewModel.events[indexPath.row]
        self.viewModel.edit(presenter: self, event: event.event)
        self.tableView.reloadData()
    }
    
    func meetingCellOnPressDelete(_ meetingCell: MeetingTableViewCell) {
        let alertController = UIAlertController(title: NSLocalizedString("delete", comment: ""), message: NSLocalizedString("delete_message_dialog", comment: ""), preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .destructive, handler: { [weak self] (action: UIAlertAction) in
            guard let self = self else { return }
            
            let indexPath = IndexPath(row: meetingCell.tag, section: 0)
            let event: MeetingEvent = self.viewModel.events[indexPath.row]
            self.viewModel.delete(event: event.event)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - Actions

extension MeetingsTableViewController {
    
    @objc private func onPressAddButton(_ sender: UIBarButtonItem) {
        self.viewModel.create(presenter: self)
    }
    
}
