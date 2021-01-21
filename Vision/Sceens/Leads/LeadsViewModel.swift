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
    
    var dataSource: [Lead] = []
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Lead> = {
        let fetchRequest: NSFetchRequest<Lead> = Lead.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: PersistentStorage.shared.mainContext(),
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self
        return controller
    }()
    
    func fetchData() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            debugPrint(#file, #function, error)
        }
        
        self.dataSource = self.fetchedResultsController.fetchedObjects ?? []
    }
    
    
    
}

// MARK: - NSFetchedResultsControllerDelegate

extension LeadsViewModel: NSFetchedResultsControllerDelegate {}
