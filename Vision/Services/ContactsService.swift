//
//  ContactsService.swift
//  ContactsPicker
//
//  Created by Idan Moshe on 07/11/2020.
//

import UIKit
import Contacts
import ContactsUI

protocol ContactsServiceDelegate: class {
    func contactsPicker(_ contactsPicker: ContactsService, accessGranted: Bool, error: Error?)
    func contactsPicker(_ contactsPicker: ContactsService, fetchContactsSuccess contacts: [CNContact])
    func contactsPicker(_ contactsPicker: ContactsService, fetchContactsFail error: Error)
}

class ContactsService: NSObject {
    
    static let shared = ContactsService()
    
    weak var delegate: ContactsServiceDelegate?
    
    let contactStore = CNContactStore()
    
    var authorizationStatus: CNAuthorizationStatus {
        return CNContactStore.authorizationStatus(for: .contacts)
    }
    
    lazy var keysToFetch: [CNKeyDescriptor] = {
        return [CNContactNamePrefixKey as CNKeyDescriptor,
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactMiddleNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactPreviousFamilyNameKey as CNKeyDescriptor,
                CNContactNameSuffixKey as CNKeyDescriptor,
                CNContactNicknameKey as CNKeyDescriptor,
                CNContactOrganizationNameKey as CNKeyDescriptor,
                CNContactDepartmentNameKey as CNKeyDescriptor,
                CNContactJobTitleKey as CNKeyDescriptor,
                CNContactPhoneticGivenNameKey as CNKeyDescriptor,
                CNContactPhoneticMiddleNameKey as CNKeyDescriptor,
                CNContactPhoneticFamilyNameKey as CNKeyDescriptor,
                CNContactPhoneticOrganizationNameKey as CNKeyDescriptor,
                CNContactBirthdayKey as CNKeyDescriptor,
                CNContactNonGregorianBirthdayKey as CNKeyDescriptor,
                /* CNContactNoteKey as CNKeyDescriptor, */ // Add entitlement - com.apple.developer.contacts.notes
                CNContactImageDataKey as CNKeyDescriptor,
                CNContactThumbnailImageDataKey as CNKeyDescriptor,
                CNContactImageDataAvailableKey as CNKeyDescriptor,
                CNContactTypeKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactEmailAddressesKey as CNKeyDescriptor,
                CNContactPostalAddressesKey as CNKeyDescriptor,
                CNContactDatesKey as CNKeyDescriptor,
                CNContactUrlAddressesKey as CNKeyDescriptor,
                CNContactRelationsKey as CNKeyDescriptor,
                CNContactSocialProfilesKey as CNKeyDescriptor,
                CNContactInstantMessageAddressesKey as CNKeyDescriptor,
                CNContactViewController.descriptorForRequiredKeys()]
    }()
    
    func requestAccess() {
        switch self.authorizationStatus {
        case .notDetermined:
            self.contactStore.requestAccess(for: .contacts) { (accessGranted: Bool, error: Error?) in
                self.delegate?.contactsPicker(self, accessGranted: accessGranted, error: error)
            }
        case .restricted:
            self.delegate?.contactsPicker(self, accessGranted: false, error: nil)
        case .denied:
            self.delegate?.contactsPicker(self, accessGranted: false, error: nil)
        case .authorized:
            self.delegate?.contactsPicker(self, accessGranted: true, error: nil)
        @unknown default: break
        }
    }
    
    func findContacts(onQueue queue: DispatchQueue = .global(qos: .background), sortOrder: CNContactSortOrder = .givenName) {
        queue.async {
            var contacts: [CNContact] = []
            
            let fetchRequest = CNContactFetchRequest(keysToFetch: self.keysToFetch)
            fetchRequest.sortOrder = sortOrder
            
            do {
                try self.contactStore.enumerateContacts(with: fetchRequest) { (contact: CNContact, stop: UnsafeMutablePointer<ObjCBool>) in
                    contacts.append(contact)
                }
                
                DispatchQueue.main.async {
                    self.delegate?.contactsPicker(self, fetchContactsSuccess: contacts)
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.delegate?.contactsPicker(self, fetchContactsFail: error)
                }
            }
        }
    }
    
    func sortContacts(contacts: [CNContact]) -> [String: [CNContact]] {
        var dataSource: [String: [CNContact]] = [:]
        
        
        
        for contact: CNContact in contacts {
            if let key: Character = contact.givenName.first {
                let firstLetter = String(key)
                if dataSource[firstLetter] == nil {
                    dataSource[firstLetter] = []
                }
                dataSource[firstLetter]!.append(contact)
            }
        }
        
        /* let sortedDataSource = dataSource.sorted { (lhs, rhs) -> Bool in
            return lhs.key < rhs.key
        } */
                
        return dataSource
    }
    
    func findContacts(_ identifiers: [String]) -> [CNContact] {
        let store = CNContactStore()
        do {
            let predicate: NSPredicate = CNContact.predicateForContacts(withIdentifiers: identifiers)
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: self.keysToFetch)
            return contacts
        } catch let error {
            debugPrint("Failed to fetch contact, error: \(error)")
        }
        return []
    }
    
    func showContact(_ contact: CNContact, navigationController: UINavigationController? = nil) {
        let contactViewController = CNContactViewController(for: contact)
        contactViewController.allowsEditing = false
        contactViewController.allowsActions = true
        contactViewController.shouldShowLinkedContacts = true
        navigationController?.pushViewController(contactViewController, animated: true)
    }
    
    func showContact(_ contact: CNContact, presenter: UIViewController) {
        let contactViewController = CNContactViewController(for: contact)
        contactViewController.allowsEditing = false
        contactViewController.allowsActions = true
        contactViewController.shouldShowLinkedContacts = true        
        presenter.present(contactViewController, animated: true, completion: nil)
    }
    
    func showContactsPicker(delegate: CNContactPickerDelegate, presenter: UIViewController) {
        let pickerViewController = CNContactPickerViewController()
        pickerViewController.delegate = delegate
        presenter.present(pickerViewController, animated: true, completion: nil)
    }
        
}
