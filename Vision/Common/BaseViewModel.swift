//
//  BaseViewModel.swift
//  Bmore
//
//  Created by Idan Moshe on 29/01/2021.
//

import UIKit
import Foundation
import CoreData

class BaseViewModel: NSObject {
    
    class func mainContext() -> NSManagedObjectContext {
        return AppDelegate.sharedDelegate().coreDataStack.mainContext()
    }
    
    class func saveContext() {
        AppDelegate.sharedDelegate().coreDataStack.saveContext()
    }
    
}
