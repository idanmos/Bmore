//
//  LeadsViewModel.swift
//  Vision
//
//  Created by Idan Moshe on 06/12/2020.
//

import Foundation
import UIKit
import CoreData

enum LeadStatus: Int, CaseIterable {
    case new, working, nurturing, unqualified, qualified
}

enum LeadAction {
    case scheduleSiteVisit
    case sendDocuments
    case makePhoneCall
    case sendSMS
    case sendWhatsApp
    case sendEmail
    case automaticLeadGeneration
    case leadQualification
    case convertToSale
}

class LeadsViewModel: NSObject {
        
    private lazy var fetchedResultsController: NSFetchedResultsController<Lead> = {
        let fetchRequest: NSFetchRequest<Lead> = Lead.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: AppDelegate.sharedDelegate().coreDataStack.mainContext(),
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self
        return controller
    }()
    
    func fetchData() {
        self.fetchedResultsController.managedObjectContext.reset()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            debugPrint(#file, #function, error)
        }
    }
    
    /* var leads: [Lead] {
        return self.fetchedResultsController.fetchedObjects ?? []
    } */
    
    var numberOfSections: Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    var numberOfObjects: Int {
        return self.fetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Lead {
        return self.fetchedResultsController.object(at: indexPath)
    }
    
    func indexPath(forObject object: Lead) -> IndexPath? {
        return self.fetchedResultsController.indexPath(forObject: object)
    }
    
    func delete(_ lead: Lead, shouldSave: Bool = true, handler: (() -> Void)? = nil) {
        debugPrint(#file, #function, lead)
        
        guard let context = lead.managedObjectContext else {
            debugPrint("###\(#function): Failed to retrieve the context from: \(lead)")
            return
        }
        
        context.perform {
            context.delete(lead)
            
            if shouldSave {
                context.save(with: .deleteContact)
            }
            handler?()
        }
    }
        
}

extension Notification.Name {
    static let leadsDidChangeContent = Notification.Name("leadsDidChangeContent")
}

// MARK: - NSFetchedResultsControllerDelegate

extension LeadsViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        debugPrint(#file, #function)
        
        NotificationCenter.default.post(
            name: .leadsDidChangeContent,
            object: nil
        )
    }
    
}
