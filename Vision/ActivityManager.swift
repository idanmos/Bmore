//
//  ActivityManager.swift
//  Bmore
//
//  Created by Idan Moshe on 06/02/2021.
//

import UIKit
import CoreData

enum ActivityType: Int16 {
    case addProperty, editProperty, deleteProperty
    case addTask, editTask, deleteTask
    case addMeeting, editMeeting, deleteMeeting
    case addTransaction, editTransaction, deleteTransaction
    case addLead, editLead, deleteLead
    case addTimeTracking, editTimeTracking, deleteTimeTracking
}

class ActivityManager {
    
    static let shared = ActivityManager()
    
    // MARK: - NSFetchedResultsController
    
    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Activity> = {
        let fetchRequest = NSFetchRequest<Activity>(entityName: "Activity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.mainContext(),
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self.fetchedResultsControllerDelegate
        
        do {
            try controller.performFetch()
        } catch {
            debugPrint(#file, #function, error)
        }
        
        return controller
    }()
    
    private var dataSource: [Activity] = []
     
    // MARK: - Core Data
    
    func mainContext() -> NSManagedObjectContext {
        return AppDelegate.sharedDelegate().coreDataStack.mainContext()
    }
    
    func saveContext() {
        AppDelegate.sharedDelegate().coreDataStack.saveContext()
    }
    
    func fetchData() {
        self.fetchedResultsController.managedObjectContext.reset()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            debugPrint(#file, #function, error)
        }
    }
    
    func resetAndRefetch() {
        self.mainContext().reset()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            debugPrint(#file, #function, error)
        }
    }
    
    var activities: [Activity] {
        return self.fetchedResultsController.fetchedObjects ?? []
    }
    
    var numberOfSections: Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    var numberOfObjects: Int {
        return self.fetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Activity {
        return self.fetchedResultsController.object(at: indexPath)
    }
    
    func indexPath(forObject object: Activity) -> IndexPath? {
        return self.fetchedResultsController.indexPath(forObject: object)
    }
    
    func save(_ type: ActivityType, _ handler: (() -> Void)? = nil) {
        let context = self.mainContext()
        
        context.perform {
            let activity = Activity(context: context)
            activity.uuid = UUID()
            activity.timestamp = Date()
            activity.type = type.rawValue
            
            context.save(with: .addActivity)
            DispatchMainThreadSafe { handler?() }
        }
    }
     
    func delete(_ activity: Activity, handler: (() -> Void)? = nil) {
        debugPrint(#file, #function, activity)
        
        guard let context = activity.managedObjectContext else {
            debugPrint("###\(#function): Failed to retrieve the context from: \(activity)")
            return
        }
        
        context.perform {
            context.delete(activity)
            context.save(with: .deleteActivity)
            DispatchMainThreadSafe { handler?() }
        }
    }
    
}
