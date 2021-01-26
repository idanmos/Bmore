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
    @IBOutlet private weak var personalDetailsLabel: UILabel!
    @IBOutlet private weak var socialProfilelButton: UIButton!
    
    
    
    var contact: DeviceContact? {
        willSet {
            self.leadImageView.image = UIImage(systemName: "person.circle")
            
            self.socialProfilelButton.setTitle("", for: .normal)
            self.socialProfilelButton.isHidden = true
            
            self.personalDetailsLabel.numberOfLines = 0
            self.personalDetailsLabel.text = nil
            self.personalDetailsLabel.isHidden = true
            
            guard let contact = newValue else { return }
            
            DispatchMainThreadSafe { [weak self] in
                guard let self = self else { return }
                if let image: UIImage = contact.image {
                    self.leadImageView.image = image
                }
                
                var personalDetails: String = ""
                
                if contact.fullName.count > 0 {
                    personalDetails += contact.fullName
                    personalDetails += "\n"
                }
                
                let postalAddress: String = contact.postalAddresses.joined(separator: "\n")
                if postalAddress.count > 0 {
                    personalDetails += postalAddress
                    personalDetails += "\n"
                }
                
                if let workplace: String = contact.workplace, workplace.count > 0 {
                    personalDetails += workplace
                    personalDetails += "\n"
                }
                
                let phoneNumbers: String = contact.phoneNumbers.joined(separator: "\n")
                if phoneNumbers.count > 0 {
                    personalDetails += phoneNumbers
                    personalDetails += "\n"
                }
                
                let emailAddresses: String = contact.emailAddresses.joined(separator: "\n")
                if emailAddresses.count > 0 {
                    personalDetails += emailAddresses
                }
                
                if personalDetails.count > 0 {
                    self.personalDetailsLabel.text = personalDetails
                    self.personalDetailsLabel.isHidden = false
                    
                    if contact.fullName.count > 0 {
                        self.personalDetailsLabel.changeFont(ofText: contact.fullName, with: .boldSystemFont(ofSize: 18.0))
                    }
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
