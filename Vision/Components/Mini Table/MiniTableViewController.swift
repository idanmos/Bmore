//
//  MiniTableViewController.swift
//  Vision
//
//  Created by Idan Moshe on 09/12/2020.
//

import UIKit

protocol MiniTableViewControllerDelegate: class {
    func miniTableView(_ miniTableView: MiniTableViewController, didSelectRowAt index: Int)
}

class MiniTableViewController: UIViewController {
    
    private var values: [String]
    private var defaultSelectedIndex: Int?
    
    init(values: [String], defaultSelectedIndex: Int? = nil) {
        self.values = values
        self.defaultSelectedIndex = defaultSelectedIndex
        super.init(nibName: MiniTableViewController.className(), bundle: nil)
        self.view.frame = UIScreen.main.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var aspectRatioConstraint: NSLayoutConstraint!
    
    weak var delegate: MiniTableViewControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className())
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.tableView.contentSize.height < self.tableView.frame.size.height {
            self.aspectRatioConstraint.isActive = false
            self.tableView.heightAnchor.constraint(equalToConstant: self.tableView.contentSize.height).isActive = true
        }
    }
    
    @IBAction private func closeScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MiniTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, indexPath: indexPath)
        cell.textLabel?.text = values[indexPath.row]
        cell.textLabel?.textAlignment = .center
        
        if let defaultSelectedIndex: Int = self.defaultSelectedIndex {
            cell.accessoryType = (defaultSelectedIndex == indexPath.row) ? .checkmark : .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.miniTableView(self, didSelectRowAt: indexPath.row)
    }
    
}
