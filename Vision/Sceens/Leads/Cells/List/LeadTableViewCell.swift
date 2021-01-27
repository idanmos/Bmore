//
//  LeadTableViewCell.swift
//  Bmore
//
//  Created by Idan Moshe on 27/01/2021.
//

import UIKit

class LeadTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var floatRatingView: FloatRatingView!
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var bottomLabel: UILabel!
    
    var lead: Lead? {
        willSet {
            guard let newValue: Lead = newValue else { return }
            
            self.floatRatingView.rating = newValue.rating
            
            if let contactId: String = newValue.contactId {
                if let contact = ContactsService.shared.findContacts([contactId]).first {
                    let deviceContact = DeviceContact(contact: contact)
                    self.topLabel.text = deviceContact.fullName
                    
                    var subtitle: String = ""
                    if let phoneNumber: String = deviceContact.phoneNumbers.first {
                        subtitle += "\(phoneNumber)\n"
                    }
                    if let emailAddress: String = deviceContact.emailAddresses.first {
                        subtitle += "\(emailAddress)"
                    }
                    
                    self.bottomLabel.text = subtitle
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.topLabel.text = nil
        self.bottomLabel.text = nil
        self.floatRatingView.rating = 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.floatRatingView.isUserInteractionEnabled = false
        self.floatRatingView.backgroundColor = .clear
        self.floatRatingView.contentMode = .scaleAspectFit
        self.floatRatingView.type = .wholeRatings
        
        self.bottomLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
