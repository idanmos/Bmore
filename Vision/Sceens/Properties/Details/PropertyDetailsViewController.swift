//
//  PropertyDetailsViewController.swift
//  Vision
//
//  Created by Idan Moshe on 07/12/2020.
//

import UIKit
import Contacts

class PropertyDetailsViewController: UITableViewController {
    
    enum CellType {
        case gallery, titleAndSubtitle, map, extraInfo, contact
    }
        
    @IBOutlet private weak var shareBarButton: UIBarButtonItem!
    
    var property: Property!
    
    private var images: [UIImage] = []
    private var cellsType: [CellType] = []
    private var contact: CNContact?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("property_details", comment: "")
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        // self.tableView.contentInset = UIEdgeInsets(top: -self.view.statusBarFrame(), left: 0, bottom: 0, right: 0)
        self.tableView.separatorStyle = .none
        
        self.tableView.register(PropertyDetailsHeadTopBottomTableViewCell.self)
        self.tableView.register(GalleryTableViewCell.self)
        self.tableView.register(PropertyDetailsTitleAndSubtitleTableViewCell.self)
        self.tableView.register(AssetDetailsMapTableViewCell.self)
        self.tableView.register(AssetDetailsExtraInfoTableViewCell.self)
        
        self.cellsType.append(.gallery)
        self.cellsType.append(.titleAndSubtitle)
        self.cellsType.append(.extraInfo)
        
        self.contact = getContact()
        if let _ = self.contact {
            self.cellsType.append(.contact)
        }
        
        self.cellsType.append(.map)
        
        if let propertyId: UUID = self.property.propertyId {
            self.images = ImageStorage.shared.load(propertyId: propertyId)
        }
        
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellsType.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.cellsType[indexPath.row] == .gallery {
            let cell = tableView.dequeue(GalleryTableViewCell.self, indexPath: indexPath)
            cell.configure(images: images)
            cell.selectionStyle = .none
            return cell
        }  else if self.cellsType[indexPath.row] == .titleAndSubtitle {
            let cell = tableView.dequeue(PropertyDetailsTitleAndSubtitleTableViewCell.self, indexPath: indexPath)
            cell.largeTitleLabel.text = self.property.address
            cell.bodyLabel.text = self.property.extraInfo
            cell.selectionStyle = .none
            return cell
        } else if self.cellsType[indexPath.row] == .map {
            let cell = tableView.dequeue(AssetDetailsMapTableViewCell.self, indexPath: indexPath)
            cell.configure(property: self.property)
            cell.selectionStyle = .none
            return cell
        } else if self.cellsType[indexPath.row] == .extraInfo {
            let cell = tableView.dequeue(AssetDetailsExtraInfoTableViewCell.self, indexPath: indexPath)
            cell.configure(self.property)
            cell.selectionStyle = .none
            return cell
        }  else if self.cellsType[indexPath.row] == .contact {
            let cell = tableView.dequeue(PropertyDetailsHeadTopBottomTableViewCell.self, indexPath: indexPath)
            cell.headlineLabel.text = NSLocalizedString("contact_info", comment: "")
            if let contact: CNContact = self.contact {
                cell.topLabel.text = "\(contact.givenName) \(contact.familyName)"
                cell.bottomLabel.text = contact.phoneNumbers.first?.value.stringValue
            }
            return cell
        }
        
        return UITableViewCell(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.cellsType[indexPath.row] == .gallery {
            return 300
        } else if self.cellsType[indexPath.row] == .map {
            return 330
        } else if self.cellsType[indexPath.row] == .titleAndSubtitle {
            return UITableView.automaticDimension
        } else if self.cellsType[indexPath.row] == .extraInfo {
            return UITableView.automaticDimension
        } else if self.cellsType[indexPath.row] == .contact {
            return UITableView.automaticDimension
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.cellsType[indexPath.row] == .contact {
            if let contact: CNContact = self.contact {
                ContactsService.shared.showContact(contact, navigationController: self.navigationController)
//                ContactsService.shared.showContact(contact, presenter: self)
            }
        }
    }
    
}

// MARK: - Actions

extension PropertyDetailsViewController {
    
    @IBAction private func onPressShareBarButton(_ sender: Any) {
        var message: String = NSLocalizedString("share", comment: "")
        
        if let _ = self.property.address {
            message += self.property.address! + "\n"
        }
        if let _ = self.property.extraInfo {
            message += self.property.extraInfo! + "\n"
        }
        if self.property.rooms > 0.0 {
            message += "\(NSLocalizedString("number_of_rooms", comment: "")): \(self.property.rooms)\n"
        }
        
        message += "\(NSLocalizedString("floor_number", comment: "")): \(self.property.floorNumber) \(NSLocalizedString("out_of", comment: "")) \(self.property.totalFloorNumber)"
        message += "\n"
        message += "\(NSLocalizedString("size_in_meters", comment: "")): \(self.property.size)"
        
        if let priceString = self.property.price, let priceInt = Int(priceString) {
            let priceNumber = NSNumber(integerLiteral: priceInt)
            message += "\n\(NSLocalizedString("price", comment: "")): "
            message += Application.priceFormatter.string(from: priceNumber) ?? priceString
        }
        
        if let contact: CNContact = self.contact {
            message += "\n\n"
            message += NSLocalizedString("contact_info", comment: "") + ":\n"
            
            message += "\(contact.givenName) \(contact.familyName)"
            
            if let phoneNumber = contact.phoneNumbers.first {
                message += "\n"
                message += phoneNumber.value.stringValue
            }
        }
        
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        
        self.present(activityController, animated: true, completion: nil)
    }
    
}

// MARK: - General Methods

extension PropertyDetailsViewController {
    
    private func getContact() -> CNContact? {
        guard let contactIdentifier: String = self.property.contactIdentifier else { return nil }
        return ContactsService.shared.findContacts([contactIdentifier]).first
    }
    
}
