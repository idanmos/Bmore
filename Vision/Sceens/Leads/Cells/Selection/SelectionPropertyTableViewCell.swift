//
//  SelectionPropertyTableViewCell.swift
//  Bmore
//
//  Created by Idan Moshe on 25/01/2021.
//

import UIKit

class SelectionPropertyTableViewCell: UITableViewCell {

    @IBOutlet private weak var selectionImageView: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var sizeLabel: UILabel!
    @IBOutlet private weak var roomsLabel: UILabel!
    @IBOutlet private weak var floorLabel: UILabel!
    @IBOutlet private weak var parkingLabel: UILabel!
    @IBOutlet private weak var balconyLabel: UILabel!
    
    var property: Property? {
        willSet {
            guard let newValue: Property = newValue else { return }
            
            self.addressLabel.text = newValue.address ?? ""
                    
            if let priceString = newValue.price, let priceInt = Int(priceString) {
                let priceNumber = NSNumber(integerLiteral: priceInt)
                self.priceLabel.text = Application.priceFormatter.string(from: priceNumber)
            } else {
                self.priceLabel.text = ""
            }
            
            self.typeLabel.text = Application.AssetType(rawValue: Int(newValue.type))!.localized()
            self.sizeLabel.text = "\(newValue.size)"
            self.roomsLabel.text = "\(newValue.rooms)"
            self.floorLabel.text = "\(newValue.floorNumber) / \(newValue.totalFloorNumber)"
            self.parkingLabel.text = "\(newValue.parking)"
            self.balconyLabel.text = "\(newValue.balcony)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.setSelected(false, animated: true)
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
        self.selectionImageView.isHidden = !selected
    }
    
}
