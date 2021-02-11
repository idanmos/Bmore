//
//  DashboardTableViewController.swift
//  Bmore
//
//  Created by Idan Moshe on 04/02/2021.
//

import UIKit

class DashboardTableViewController: BaseTableViewController {
    
    private let viewModel = DashboardViewModel()
    private var date = Date()
    
    private lazy var headerView: TransactionHeaderView = {
        return TransactionHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44.0))
    }()
    
    deinit {
        debugPrint("Deallocating \(self)")
        self.removeAllChildren()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.tableView.register(ActivityTableViewCell.self)
        self.tableView.register(PropertyTableViewCell.self)
        self.tableView.register(TransactionTableViewCell.self)
        self.tableView.register(ShowMeetingTableViewCell.self)
        self.tableView.register(ShowTaskTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MeetingService.shared.requestAccess { [weak self] (granted: Bool, error: Error?) in
            guard let self = self else { return }
            
            DispatchMainThreadSafe {
                self.viewModel.fetchData(date: self.date)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dataSource[section].count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        
        if self.viewModel.dataSource[section].first is Transaction {
            return self.headerView
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "performance".localized }
        
        if self.viewModel.dataSource[section].first is Activity {
            return DashboardSectionType.recentActivities.title
        } else if self.viewModel.dataSource[section].first is Transaction {
            return DashboardSectionType.transactions.title
        } else if self.viewModel.dataSource[section].first is MeetingEvent {
            return DashboardSectionType.meetings.title
        } else if self.viewModel.dataSource[section].first is Task {
            return DashboardSectionType.tasks.title
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let obj = self.viewModel.dataSource[indexPath.section][indexPath.row] as? Activity {
            let cell = tableView.dequeue(ActivityTableViewCell.self, indexPath: indexPath)
            if let type = ActivityType(rawValue: obj.type) {
                cell.textLabel?.text = type.title
            }
            if let timestamp: Date = obj.timestamp {
                cell.detailTextLabel?.text = DateFormatter.dayFormatter.string(from: timestamp)
            }
        } else if let obj = self.viewModel.dataSource[indexPath.section][indexPath.row] as? MeetingEvent {
            let cell = tableView.dequeue(ShowMeetingTableViewCell.self, indexPath: indexPath)
            cell.meeting = obj
            return cell
        } else if let obj = self.viewModel.dataSource[indexPath.section][indexPath.row] as? Task {
            let cell = tableView.dequeue(ShowTaskTableViewCell.self, indexPath: indexPath)
            cell.task = obj
            return cell
        } else if let obj = self.viewModel.dataSource[indexPath.section][indexPath.row] as? Transaction {
            let cell = tableView.dequeue(TransactionTableViewCell.self, indexPath: indexPath)
            cell.transaction = obj
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint(#function, "segue.destination", segue.destination)
    }

}
