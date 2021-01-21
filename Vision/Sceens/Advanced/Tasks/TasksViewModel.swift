//
//  TasksViewModel.swift
//  B-more
//
//  Created by Idan Moshe on 11/01/2021.
//

import UIKit

enum TaskEvent {
    case present(taskConfiguration: TaskConfiguration)
    case schedule(taskConfiguration: TaskConfiguration)
    case remove(taskId: String)
    
    static func perform(_ task: TaskEvent) {
        switch task {
        case .present(taskConfiguration: let taskConfiguration):
            break
        case .schedule(taskConfiguration: let taskConfiguration):
            PushNotificationService.shared.schedule(taskConfiguration)
        case .remove(taskId: let taskId):
            PushNotificationService.shared.remove(taskId)
        }
    }
}


class TasksViewModel {
    
    var dataSource: [Task] = []
    
    func fetchData() {
        self.dataSource = PersistentStorage.shared.fetchTasks()
    }
    
    func showAddScreen(presenter: UIViewController, editedTask: Task? = nil) {
        guard let advancedController = presenter.parent as? AdvancedViewController else { return }
        
        guard let newTaskController = UIStoryboard(name: "Tasks", bundle: nil).instantiateViewController(withIdentifier: NewTaskTableViewController.className())
                as? NewTaskTableViewController
        else { return }
        
        newTaskController.editedTask = editedTask
        
        advancedController.navigationController?.pushViewController(newTaskController, animated: true)
    }
    
}
