//
//  LeadsTableViewController.swift
//  Vision
//
//  Created by Idan Moshe on 06/12/2020.
//

import UIKit
import Contacts
import ContactsUI

class LeadsTableViewController: UITableViewController {
    
    private var viewModel = LeadsViewModel()
    
    deinit {
        debugPrint("Deallocating \(self)")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        MeetingService.shared.requestAccess()
        
        self.title = "leads".localized
        
//        self.navigationItem.searchController = self.searchController
//        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.reloadScreen),
            name: .leadsDidChangeContent,
            object: nil
        )
        
        self.tableView.register(LeadTableViewCell.self)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = true // self.splitViewController?.isCollapsed
        super.viewWillAppear(animated)
        
        self.viewModel.fetchData()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(LeadTableViewCell.self, indexPath: indexPath)
        let lead: Lead = self.viewModel.object(at: indexPath)
        cell.lead = lead
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let leadDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: LeadDetailsViewController.className())
                as? LeadDetailsViewController
        else { return }
        
        leadDetailsViewController.editedLead = self.viewModel.object(at: indexPath)
        self.present(leadDetailsViewController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .none:
            break
        case .delete:
            let lead: Lead = self.viewModel.object(at: indexPath)
//            self.viewModel.delete(lead)
//            tableView.deleteRows(at: [indexPath], with: .fade)
            self.viewModel.delete(lead) {
                debugPrint(#file, #function, "self.viewModel.delete(lead)", "inside handler")
                self.didUpdateLead(nil)
            }
            
        case .insert:
            break
        @unknown default:
            break
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
    }

}

// MARK: - General Methods

extension LeadsTableViewController {
    
    @objc private func reloadScreen() {
        debugPrint(#file, #function)
        
        DispatchMainThreadSafe {
            self.tableView.reloadSections(
                IndexSet(integer: 0),
                with: .automatic
            )
        }
    }
    
    /**
     didUpdatePost is called as part of PostInteractionDelegate, or whenever a post update requires a UI update (including master-detail selections).
     
     Respond by updating the UI as follows.
     - add: make the new item visible and select it.
     - add 1000: preserve the current selection if any; otherwise select the first item.
     - delete: select the first item if possible.
     - delete all: clear the detail view.
     - update from detailViewController: reload the row, make it visible, and select it.
     - initial load: select the first item if needed.
     */
    private func didUpdateLead(_ lead: Lead?, shouldReloadRow: Bool = false) {
        debugPrint(#function, "lead: \(String(describing: lead))", "shouldReloadRow: \(shouldReloadRow)")
        
        let rowCount = self.viewModel.numberOfObjects
        // navigationItem.leftBarButtonItem?.isEnabled = (rowCount > 0) ? true : false
        
        // Get the indexPath for the post. Use the currently selected indexPath if any, or the first row otherwise.
        // indexPath will remain nil if the tableView has no data.
        var indexPath: IndexPath?
        if let lead: Lead = lead {
            indexPath = self.viewModel.indexPath(forObject: lead)
        } else {
            indexPath = self.tableView.indexPathForSelectedRow
            if indexPath == nil && self.tableView.numberOfRows(inSection: 0) > 0 {
                indexPath = IndexPath(row: 0, section: 0)
            }
        }
        
        // Update the masterViewController: make sure the row is visible and the content is up to date.
        if let indexPath: IndexPath = indexPath {
            if shouldReloadRow {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            if let isCollapsed: Bool = self.splitViewController?.isCollapsed, !isCollapsed {
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            }
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
        
        // Update the detailViewController if needed.
        // shouldReloadRow is true when the change was made in the detailViewController, so no need to update.
        guard !shouldReloadRow else { return }
        
        // Reload the detailViewController if needed.
        /* guard let detailViewController = detailViewController else { return }
        
        if let indexPath = indexPath {
            detailViewController.post = dataProvider.fetchedResultsController.object(at: indexPath)
        } else {
            detailViewController.post = post
        }
        detailViewController.refreshUI() */
    }
    
}

// MARK: - Actions

extension LeadsTableViewController {
    
    @IBAction private func onPressAddContacts(_ sender: Any) {
        if let leadDetailsController = self.storyboard?.instantiateViewController(withIdentifier: LeadDetailsViewController.className())
            as? LeadDetailsViewController {
            self.present(leadDetailsController, animated: true, completion: nil)
        }
    }
    
}

// MARK: - UISearchResultsUpdating

//extension LeadsTableViewController: UISearchResultsUpdating {
//
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let searchText: String = searchController.searchBar.text, searchController.isActive else { return }
//
//        let predicate: NSPredicate
//        if searchText.isEmpty {
//            predicate = CNContact.predicateForContactsInContainer(withIdentifier: self.contactsProvider.contactStore.defaultContainerIdentifier())
//        } else {
//            predicate = CNContact.predicateForContacts(matchingName: searchText)
//        }
//
//        do {
//            var filtered: [CNContact] = []
//
//            let filteredContacts = try self.contactsProvider.contactStore.unifiedContacts(matching: predicate, keysToFetch: self.contactsProvider.keysToFetch)
//            for contact: CNContact in filteredContacts {
//                filtered.append(contact)
//            }
//
//            self.viewModel.filteredContacts = filtered
//
//            self.tableView.reloadData()
//        } catch let error {
//            debugPrint(#function, error)
//        }
//    }
//
//}


// MARK: - CNContactPickerDelegate

extension LeadsTableViewController: CNContactPickerDelegate {
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        debugPrint(#function)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        self.tableView.reloadData()
    }
    
}
