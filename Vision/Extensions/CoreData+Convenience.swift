//
//  CoreData+Convenience.swift
//  Vision
//
//  Created by Idan Moshe on 15/12/2020.
//

import UIKit
import CoreData

// MARK: - Creating Contexts

let appTransactionAuthorName = "app"

extension NSPersistentContainer {
    func backgroundContext() -> NSManagedObjectContext{
        let context = newBackgroundContext()
        context.transactionAuthor = appTransactionAuthorName
        return context
    }
}

// MARK: - Saving Contexts

enum ContextSaveContextualInfo: String {
//    case properties = "adding a property"
//    case deleteProperty = "deleting a property"
    
    /// - Tag: Leads
    case leads = "adding contact identifier"
    case deleteLead = "deleting a contact"
    
    /// - Tag: Time Tracking
    case timeTrack = "adding start/end work time"
    case deleteTimeTrack = "deleting a time track"
    
    /// - Tag: Properties
    case addProperty = "adding a property"
    case deleteProperty = "deleting a property"
    case batchAddProperties = "adding a batch of properties"
    case deduplicate = "deduplicating tags"
    case updateProperty = "saving property details"
//    case addTag = "adding a tag"
//    case deleteTag = "deleting a tag"
    
    /// - Tag: Attachments & Images
    case addAttachment = "adding an attachment"
    case deleteAttachment = "deleting an attachment"
    case saveFullImage = "saving a full image"
    
    /// - Tag: Activities
    case addActivity = "add an activity"
    case deleteActivity = "deleting an activity"
}

extension NSManagedObjectContext {
    
    private func handleSavingError(_ error: Error, contextualInfo: ContextSaveContextualInfo) {
        print("Context saving error: \(error)")
        
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.delegate?.window,
                let viewController = window?.rootViewController else { return }
            
            let message = "Failed to save the context when \(contextualInfo.rawValue)."
            
            // Append message to existing alert if present
            if let currentAlert = viewController.presentedViewController as? UIAlertController {
                currentAlert.message = (currentAlert.message ?? "") + "\n\n\(message)"
                return
            }
            
            // Otherwise present a new alert
            let alert = UIAlertController(title: "Core Data Saving Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(alert, animated: true)
        }
    }
    
    func save(with contextualInfo: ContextSaveContextualInfo) {
        guard hasChanges else { return }
        do {
            try save()
        } catch let error {
            handleSavingError(error, contextualInfo: contextualInfo)
        }
    }
    
}
