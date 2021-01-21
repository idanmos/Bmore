//
//  DeviceContact.swift
//  Bmore
//
//  Created by Idan Moshe on 19/01/2021.
//

import UIKit
import Contacts

class DeviceContact {
    
    var contact: CNContact
    init(contact: CNContact) {
        self.contact = contact
    }
    
    var identifier: String {
        return self.contact.identifier
    }
    
    var givenName: String {
        return self.contact.givenName
    }
    
    var familyName: String {
        return self.contact.familyName
    }
    
    var fullName: String {
        return "\(self.givenName) \(self.familyName)"
    }
    
    var phoneNumbers: [String] {
        return self.contact.phoneNumbers.map {( $0.value.stringValue )}
    }
    
    var emailAddresses: [String] {
        return self.contact.emailAddresses.map {( ($0.value as String) )}
    }
    
    var postalAddresses: [String] {
        let addresses: [String] = self.contact.postalAddresses.map {( CNPostalAddressFormatter.string(from: $0.value, style: .mailingAddress) )}
        
        let formatted = addresses.map { (obj: String) -> String in
            return obj.replacingOccurrences(of: "\n", with: ", ")
        }
        
        return formatted
    }
    
    var socialProfiles: [String] {
        return self.contact.socialProfiles.map {( $0.value.urlString )}
    }
    
    var image: UIImage? {
        if let imageData: Data = self.contact.imageData {
            return UIImage(data: imageData)
        } else if let thumbnailImageData: Data = self.contact.thumbnailImageData {
            return UIImage(data: thumbnailImageData)
        }
        return nil
    }
    
    var workplace: String? {
        var place: [String] = []
        if self.contact.jobTitle.count > 0 {
            place.append(self.contact.jobTitle)
        }
        if self.contact.departmentName.count > 0 {
            place.append(self.contact.departmentName)
        }
        if self.contact.organizationName.count > 0 {
            place.append(self.contact.organizationName)
        }
        
        if place.count > 0 {
            return place.joined(separator: ", ")
        }
        
        return nil
    }
    
}
