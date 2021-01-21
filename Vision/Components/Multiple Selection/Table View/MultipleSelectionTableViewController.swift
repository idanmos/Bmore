//
//  MultipleSelectionTableViewController.swift
//  Vision
//
//  Created by Idan Moshe on 13/12/2020.
//

import UIKit

class MultipleSelectionTableViewController: UITableViewController {
    
    private var values: [String]
    private var defaultSelectedIndices: [Int]
    
    init(values: [String], defaultSelectedIndices: [Int]) {
        self.values = values
        self.defaultSelectedIndices = defaultSelectedIndices
        super.init(nibName: MultipleSelectionTableViewController.className(), bundle: nil)
        self.view.frame = UIScreen.main.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
        self.tableView.register(MultipleSelectionTableViewCell.self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.values.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(MultipleSelectionTableViewCell.self, indexPath: indexPath)
        cell.topLabel.text = self.values[indexPath.row]
        
        if indexPath.row == self.defaultSelectedIndices[indexPath.row] {
            cell.setSelected(true, animated: true)
        }
        
        return cell
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
