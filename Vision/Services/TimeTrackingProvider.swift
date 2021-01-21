//
//  TimeTrackingProvider.swift
//  Vision
//
//  Created by Idan Moshe on 15/12/2020.
//

import UIKit
import CoreData

class TimeTrackingProvider {
    
    private(set) var persistentContainer: NSPersistentContainer
    private weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    init(with persistentContainer: NSPersistentContainer,
         fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?) {
        self.persistentContainer = persistentContainer
        self.fetchedResultsControllerDelegate = fetchedResultsControllerDelegate
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<TimeTrack> = {
        let fetchRequest: NSFetchRequest<TimeTrack> = TimeTrack.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
                
        controller.delegate = fetchedResultsControllerDelegate
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("###\(#function): Failed to performFetch: \(nserror), \(nserror.userInfo)")
        }
        
        return controller
    }()
    
    func addTimeTrack(startDate: Date? = nil,
                      endDate: Date? = nil,
                      context: NSManagedObjectContext,
                      shouldSave: Bool = true,
                      completionHandler: ((_ newTimeTrack: TimeTrack) -> Void)? = nil) {
        context.perform {
            let timeTrack = TimeTrack(context: context)
            timeTrack.startDate = startDate
            timeTrack.endDate = endDate
            
            if shouldSave {
                context.save(with: .timeTrack)
            }
            completionHandler?(timeTrack)
        }
    }
    
    func delete(timeTrack: TimeTrack, shouldSave: Bool = true, completionHandler: (() -> Void)? = nil) {
        guard let context = timeTrack.managedObjectContext else {
            fatalError("###\(#function): Failed to retrieve the context from: \(timeTrack)")
        }
        context.perform {
            context.delete(timeTrack)
            
            if shouldSave {
                context.save(with: .deleteTimeTrack)
            }
            completionHandler?()
        }
    }
    
}
