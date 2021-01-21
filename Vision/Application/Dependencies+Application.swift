//
//  Dependencies+Application.swift
//  B-more
//
//  Created by Idan Moshe on 18/01/2021.
//

import UIKit

extension UIResponder {
    
    var persistentStorage: PersistentStorage {
        return .shared
    }
    
    var imageStorage: ImageStorage {
        return .shared
    }
    
    var contactsManager: ContactsService {
        return .shared
    }
    
    var facebookManager: FacebookManager {
        return .shared
    }
    
}
