//
//  TasksViewModel.swift
//  B-more
//
//  Created by Idan Moshe on 11/01/2021.
//

import UIKit
import CoreData

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


class TasksViewModel: BaseViewModel {
    
    // MARK: - NSFetchedResultsController
    
    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: TasksViewModel.mainContext(),
                                                    sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self.fetchedResultsControllerDelegate
        
        do {
            try controller.performFetch()
        } catch {
            debugPrint(#file, #function, error)
        }
        
        return controller
    }()
    
    var dataSource: [Task] = []
    
    func fetchData() {
        self.dataSource = TasksViewModel.fetchTasks()
    }
    
    func showAddScreen(presenter: UIViewController, editedTask: Task? = nil) {
        guard let advancedController = presenter.parent as? MoreViewController else { return }
        
        guard let newTaskController = UIStoryboard(name: "Tasks", bundle: nil).instantiateViewController(withIdentifier: NewTaskTableViewController.className())
                as? NewTaskTableViewController
        else { return }
        
        newTaskController.editedTask = editedTask
        
        advancedController.navigationController?.pushViewController(newTaskController, animated: true)
    }
    
}

// MARK: - CoreData

extension TasksViewModel {
        
    func resetAndRefetch() {
        TasksViewModel.mainContext().reset()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            debugPrint(#file, #function, error)
        }
    }
    
    func numberOfSections() -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func getAll<T: NSManagedObject>() -> [T] {
        return self.fetchedResultsController.fetchedObjects as? [T] ?? []
    }
    
    func object<T: NSManagedObject>(at indexPath: IndexPath) -> T? {
        return self.fetchedResultsController.object(at: indexPath) as? T
    }
    
    class func fetchTasks(fetchLimit: Int? = nil) -> [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        if let limit: Int = fetchLimit {
            request.fetchLimit = limit
        }
                
        do {
            let results: [Task] = try TasksViewModel.mainContext().fetch(request)
            return results
        } catch let error {
            debugPrint(#function, error)
        }
        
        return []
    }
    
    private static func saveOrEdit(_ task: Task, configuration: TaskConfiguration) {
        task.timestamp = Date()
        task.title = configuration.title
        task.status = configuration.status.rawValue
        task.type = configuration.type.rawValue
        task.date = configuration.date
        task.contactId = configuration.contactId
        task.comments = configuration.comments
        task.isPushEnabled = configuration.isPushEnabled
        TasksViewModel.saveContext()
    }
    
    class func save(_ configuration: TaskConfiguration) {
        let task = Task(context: TasksViewModel.mainContext())
        task.uuid = UUID()
        TasksViewModel.saveOrEdit(task, configuration: configuration)
    }
    
    class func edit(_ task: Task, configuration: TaskConfiguration) {
        TasksViewModel.saveOrEdit(task, configuration: configuration)
    }
        
    class func delete(_ task: Task) {
        self.mainContext().delete(task)
        self.saveContext()
    }
    
}
