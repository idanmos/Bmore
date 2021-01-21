//
//  CoreDataOperation.swift
//  B-more
//
//  Created by Idan Moshe on 15/01/2021.
//

import CoreData
import Foundation

class CoreDataOperation: Operation {

    // MARK: - Properties

    private let privateManagedObjectContext: NSManagedObjectContext

    // MARK: - Initialization

    init(parentManagedObjectContext: NSManagedObjectContext) {
        self.privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.privateManagedObjectContext.parent = parentManagedObjectContext
    }
    
    override func main() {
        super.main()
        
        self.saveChanges()
    }
    
    private func saveChanges() {
        self.privateManagedObjectContext.perform {
            guard self.privateManagedObjectContext.hasChanges else { return }

            do {
                try self.privateManagedObjectContext.save()
            } catch {
                let saveError = error as NSError

                debugPrint("Unable to Save Changes")
                debugPrint("\(saveError), \(saveError.localizedDescription)")
            }
        }
    }

}
