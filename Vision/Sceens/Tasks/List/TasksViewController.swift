//
//  TasksViewController.swift
//  B-more
//
//  Created by Idan Moshe on 11/01/2021.
//

import UIKit

class TasksViewController: BaseTableViewController {
        
    private let viewModel = TasksViewModel()
    
    private lazy var addBarButton: UIBarButtonItem = {
        let control = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onPressAddButton(_:)))
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "tasks".localized
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = self.addBarButton
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className())
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchData()
        
        self.tableView.register(TaskTableViewCell.self)
        self.tableView.reloadData()
    }

    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TaskTableViewCell.self, indexPath: indexPath)
        let task: Task = self.viewModel.dataSource[indexPath.row]
        cell.configure(task)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let task: Task = self.viewModel.dataSource[indexPath.row]
            
            // remove push task
            if let uuid = task.uuid {
                TaskEvent.perform(.remove(taskId: uuid.uuidString))
            }
            
            // remove from core data
            TasksViewModel.delete(task)
            
            // remove from data source
            self.viewModel.dataSource.remove(at: indexPath.row)
            
            // remove from tableView
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task: Task = self.viewModel.dataSource[indexPath.row]
        self.viewModel.showAddScreen(presenter: self, editedTask: task)
    }
    
}

// MARK: - General Methods

extension TasksViewController {
    
    private func refreshData() {
    }
    
}

// MARK: - Actions

extension TasksViewController {
    
    @objc private func onPressAddButton(_ sender: Any) {
        self.viewModel.showAddScreen(presenter: self)
    }
    
}

