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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
                
        self.title = "leads".localized
        
//        self.navigationItem.searchController = self.searchController
//        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchData()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.className(), for: indexPath) as! ContactTableViewCell
        let lead: Lead = self.viewModel.dataSource[indexPath.row]
        
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
        } else if editingStyle == .insert {
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
    }

}

// MARK: - General Methods

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
