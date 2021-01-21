//
//  ContactTableViewCell.swift
//  Vision
//
//  Created by Idan Moshe on 06/12/2020.
//

import UIKit
import Contacts

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var contactNameLabel: UILabel!
    @IBOutlet private weak var contactNoteLabel: UILabel!
    @IBOutlet private weak var contactImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contactImageView.backgroundColor = .clear
        self.contactImageView.layer.cornerRadius = self.contactImageView.frame.size.width/2
        self.contactImageView.clipsToBounds = true
        self.contactImageView.layer.masksToBounds = true
        self.contactImageView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contactNameLabel.text = ""
        self.contactNoteLabel.text = ""
        self.contactImageView.image = UIImage(named: "avatar_placeholder")
    }
    
    @IBAction func onPressInfo(_ sender: Any) {
        //
    }
    
    func configure(_ contact: CNContact) {
        self.contactNameLabel.text = "\(contact.givenName) \(contact.familyName)"
        self.contactNoteLabel.text = contact.phoneNumbers.first?.value.stringValue
        
        if contact.imageDataAvailable, let imageData: Data = contact.imageData {
            self.contactImageView.image = UIImage(data: imageData)
        }
    }

}
