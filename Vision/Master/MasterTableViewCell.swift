//
//  MasterTableViewCell.swift
//  Bmore
//
//  Created by Idan Moshe on 28/01/2021.
//

import UIKit

class MasterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuImageView: UIImageView! {
        didSet(newValue) {
            if newValue != nil {
                if let image: UIImage = newValue.image {
                    newValue.image = image.withAlignmentRectInsets(UIEdgeInsets(top: -7, left: -7, bottom: -7, right: -7))
                }
            }
        }
    }
    
    @IBOutlet weak var menuTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.menuImageView.tintColor = .white
        self.menuImageView.layer.cornerRadius = 5.0
        self.menuImageView.clipsToBounds = true
        self.menuImageView.layer.masksToBounds = true
        self.menuImageView.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
