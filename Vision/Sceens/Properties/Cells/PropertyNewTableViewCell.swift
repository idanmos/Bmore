//
//  PropertyNewTableViewCell.swift
//  Bmore
//
//  Created by Idan Moshe on 11/02/2021.
//

import UIKit

class PropertyNewTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var propertyImageView: UIImageView!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var bedroomValueLabel: UILabel!
    @IBOutlet private weak var bathroomValueLabel: UILabel!
    @IBOutlet private weak var sizeValueLabel: UILabel!
    @IBOutlet private weak var priceValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(self.containerView)
        
        self.containerView.layer.round(
            roundedRect: self.containerView.bounds,
            byRoundingCorners: .allCorners,
            cornerRadii: CGSize(width: 10.0, height: 10.0),
            strokeColor: UIColor.lightGray.cgColor
        )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
