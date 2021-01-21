//
//  LeadPersonalDetailsTableViewCell.swift
//  B-more
//
//  Created by Idan Moshe on 17/01/2021.
//

import UIKit

class LeadPersonalDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var leadImageView: UIImageView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var leadNameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var workplaceLabel: UILabel!
    @IBOutlet private weak var leadPhoneNumberLabel: UILabel!
    @IBOutlet private weak var leadEmailLabel: UILabel!
    @IBOutlet private weak var socialProfilelButton: UIButton!
    
    var contact: DeviceContact? {
        willSet {
            self.leadImageView.image = UIImage(systemName: "person.circle")
            
            self.socialProfilelButton.setTitle("", for: .normal)
            self.socialProfilelButton.isHidden = true
            
            self.stackView.arrangedSubviews.forEach { (obj: UIView) in
                if obj is UILabel {
                    (obj as! UILabel).text = nil
                    (obj as! UILabel).isHidden = true
                }
            }
            
            guard let contact = newValue else { return }
            
            DispatchMainThreadSafe { [weak self] in
                guard let self = self else { return }
                if let image: UIImage = contact.image {
                    self.leadImageView.image = image
                }
                
                if contact.fullName.count > 0 {
                    self.leadNameLabel.text = contact.fullName
                    self.leadNameLabel.isHidden = false
                }
                
                let postalAddress: String = contact.postalAddresses.joined(separator: "\n")
                if postalAddress.count > 0 {
                    self.addressLabel.text = postalAddress
                    self.addressLabel.isHidden = false
                }
                
                if let workplace: String = contact.workplace, workplace.count > 0 {
                    self.workplaceLabel.text = workplace
                    self.workplaceLabel.isHidden = false
                }
                
                let phoneNumbers: String = contact.phoneNumbers.joined(separator: "\n")
                if phoneNumbers.count > 0 {
                    self.leadPhoneNumberLabel.text = phoneNumbers
                    self.leadPhoneNumberLabel.isHidden = false
                }
                
                let emailAddresses: String = contact.emailAddresses.joined(separator: "\n")
                if emailAddresses.count > 0 {
                    self.leadEmailLabel.text = emailAddresses
                    self.leadEmailLabel.isHidden = false
                }
                
                let socialProfile: String = contact.socialProfiles.joined(separator: "\n")
                if socialProfile.count > 0 {
                    self.socialProfilelButton.setTitle(socialProfile, for: .normal)
                    self.socialProfilelButton.isHidden = false
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.leadImageView.contentMode = .scaleToFill
        self.leadImageView.makeAsCircle(borderColor: .black, borderWidth: 1.0)
        
        self.socialProfilelButton.titleLabel?.numberOfLines = 0
        
        self.stackView.arrangedSubviews.forEach { (obj: UIView) in
            if obj is UILabel {
                (obj as! UILabel).numberOfLines = 0
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
        
    @IBAction private func onPressSocialProfile(_ sender: Any) {
        guard let contact = self.contact else { return }
        guard let socialProfile: String = contact.socialProfiles.first else { return }
        guard let url = URL(string: socialProfile) else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
