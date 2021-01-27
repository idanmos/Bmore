//
//  PropertyDetailsTableViewCell.swift
//  B-more
//
//  Created by Idan Moshe on 10/01/2021.
//

import UIKit

class PropertyDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var propertyImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var addressButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.propertyImageView.image = nil
        self.titleLabel.text = nil
        self.priceLabel.text = nil
        self.detailsLabel.text = nil
        self.addressButton.setTitle(nil, for: .normal)
    }
    
    @IBAction private func onPressAddress(_ sender: Any) {
        //
    }
    
    func configure(_ property: Property) {
        /// - Tag: Image
        if let firstImage = ImageStorage.shared.loadFirstImage(propertyId: property.uuid) {
            self.propertyImageView.image = firstImage
        }
        
        /// - Tag: Title
        var title: String = ""
        
        if property.isExclusivity {
            title += NSLocalizedString("exclusivity", comment: "") + ", "
        }
        if let sellOrRent: String = property.sellOrRent {
            title += sellOrRent + ", "
        }
        
        let type: String = Application.AssetType(rawValue: Int(property.type))!.localized()
        title += type
        
        /// - Tag: Price
        if let priceString = property.price, let priceInt = Int(priceString) {
            let priceNumber = NSNumber(integerLiteral: priceInt)
            self.priceLabel.isHidden = false
            self.priceLabel.text = Application.priceFormatter.string(from: priceNumber)
        } else {
            self.priceLabel.isHidden = true
        }
        
        /// - Tag: Details
        var details: String = ""
        details += "\(NSLocalizedString("rooms", comment: "")): \(property.rooms), "
        details += "\(NSLocalizedString("size", comment: "")): \(property.size), "
        details += "\(NSLocalizedString("floor_number", comment: "")): \(property.floorNumber)"
        self.detailsLabel.text = details
        
        /// - Tag: Address
        if let address: String = property.address {
            self.addressButton.isHidden = false
            self.addressButton.setTitle(address, for: .normal)
        } else {
            self.addressButton.isHidden = true
        }
    }
    
}
