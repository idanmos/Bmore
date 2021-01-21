//
//  CheckboxTableViewController.swift
//  B-more
//
//  Created by Idan Moshe on 04/01/2021.
//

import UIKit

protocol CheckboxTableViewControllerDelegate: class {
    func checkboxTableView(_ checkboxTableView: CheckboxTableViewController, didSelectRowAt index: Int)
}

class CheckboxTableViewController: UITableViewController {
    
    var values: [String] = []
    var defaultSelectedIndex: Int?
    
    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveAndClose))
        return button
    }()
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        self.view.frame = UIScreen.main.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: CheckboxTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.navigationItem.leftBarButtonItem == self.navigationItem.backBarButtonItem {
            self.navigationItem.rightBarButtonItem = self.saveBarButtonItem
        } else {
            self.navigationItem.leftBarButtonItem = self.saveBarButtonItem
        }
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className())
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // MARK: General Methods
    
    @objc private func saveAndClose() {
        if let index: Int = self.defaultSelectedIndex {
            self.delegate?.checkboxTableView(self, didSelectRowAt: index)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.values.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className(), for: indexPath)
        cell.textLabel?.text = self.values[indexPath.row]
        
        if let defaultSelectedIndex: Int = self.defaultSelectedIndex {
            cell.accessoryType = (defaultSelectedIndex == indexPath.row) ? .checkmark : .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.defaultSelectedIndex = indexPath.row
        tableView.reloadData()
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
