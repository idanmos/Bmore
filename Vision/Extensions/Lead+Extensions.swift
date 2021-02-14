//
//  Lead+Extensions.swift
//  Bmore
//
//  Created by Idan Moshe on 14/02/2021.
//

import UIKit
import CoreData
import Contacts

extension Lead {
    
    var contact: CNContact? {
        if let _id: String = self.contactId {
            let contacts = ContactsService.shared.findContacts([_id])
            return contacts.first
        }
        return nil
    }
    
    var phoneNumbers: [String] {
        if let contact: CNContact = self.contact {
            return contact.phoneNumbers.map(\.value.stringValue)
        }
        return []
    }
    
    var emailAddresses: [String] {
        if let contact: CNContact = self.contact {
            return contact.emailAddresses.map({ ($0.value as String) })
        }
        return []
    }
    
}
