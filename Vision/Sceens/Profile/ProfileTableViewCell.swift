//
//  ProfileTableViewCell.swift
//  Bmore
//
//  Created by Idan Moshe on 03/02/2021.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageContainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileAccountLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileImageView.image = nil
        self.profileNameLabel.text = nil
        self.profileAccountLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImageView.tintColor = .white
        
        self.profileImageContainerView.backgroundColor = .belizeHole
        self.profileImageContainerView.layer.cornerRadius = self.profileImageContainerView.frame.size.height/2.0
        self.profileImageContainerView.layer.masksToBounds = true
        self.profileImageContainerView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
