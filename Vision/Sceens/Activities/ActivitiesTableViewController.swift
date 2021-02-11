//
//  ActivitiesTableViewController.swift
//  Bmore
//
//  Created by Idan Moshe on 06/02/2021.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel?.text = nil
        self.detailTextLabel?.text = nil
    }
    
}

class ActivitiesTableViewController: UITableViewController {
    // MARK: - Lifecycle
    
    deinit {
        debugPrint("Deallocating \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(ActivityTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ActivityManager.shared.resetAndRefetch()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ActivityManager.shared.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActivityManager.shared.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ActivityTableViewCell.self, indexPath: indexPath)
        
        let activity: Activity = ActivityManager.shared.object(at: indexPath)
        
        if let type = ActivityType(rawValue: activity.type) {
            cell.textLabel?.text = type.title
        }
        if let timestamp: Date = activity.timestamp {
            cell.detailTextLabel?.text = DateFormatter.dayFormatter.string(from: timestamp)
        }
        
        return cell
    }
        
}
