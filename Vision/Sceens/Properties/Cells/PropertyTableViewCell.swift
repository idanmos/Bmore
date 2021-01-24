//
//  PropertyTableViewCell.swift
//  Bmore
//
//  Created by Idan Moshe on 24/01/2021.
//

import UIKit

class PropertyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var parkingLabel: UILabel!
    @IBOutlet weak var balconyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.priceLabel.text = nil
        self.typeLabel.text = nil
        self.sizeLabel.text = nil
        self.roomsLabel.text = nil
        self.floorLabel.text = nil
        self.parkingLabel.text = nil
        self.balconyLabel.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ property: Property) {
        self.addressLabel.text = property.address ?? ""
                
        if let priceString = property.price, let priceInt = Int(priceString) {
            let priceNumber = NSNumber(integerLiteral: priceInt)
            self.priceLabel.text = Application.priceFormatter.string(from: priceNumber)
        } else {
            self.priceLabel.text = ""
        }
        
        self.typeLabel.text = Application.AssetType(rawValue: Int(property.type))!.localized()
        self.sizeLabel.text = "\(property.size)"
        self.roomsLabel.text = "\(property.rooms)"
        self.floorLabel.text = "\(property.floorNumber) / \(property.totalFloorNumber)"
        self.parkingLabel.text = "\(property.parking)"
        self.balconyLabel.text = "\(property.balcony)"
    }
    
}
