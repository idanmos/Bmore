//
//  AssetDetailsExtraInfoTableViewCell.swift
//  Vision
//
//  Created by Idan Moshe on 08/12/2020.
//

import UIKit

class AssetDetailsExtraInfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var topTitleLabel: UILabel!
    
    @IBOutlet private weak var saleOrRentTitleLabel: UILabel!
    @IBOutlet private weak var typeTitleLabel: UILabel!
    @IBOutlet private weak var sizeTitleLabel: UILabel!
    @IBOutlet private weak var priceTitleLabel: UILabel!
    @IBOutlet private weak var roomsTitleLabel: UILabel!
    @IBOutlet private weak var floorNumberTitleLabel: UILabel!
    @IBOutlet private weak var balconyTitleLabel: UILabel!
    @IBOutlet private weak var parkingTitleLabel: UILabel!
    @IBOutlet private weak var entryDateTitleLabel: UILabel!
    @IBOutlet private weak var exclusivityDateTitleLabel: UILabel!
    
    @IBOutlet weak var saleOrRentLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var floorNumberLabel: UILabel!
    @IBOutlet weak var balconyLabel: UILabel!
    @IBOutlet weak var parkingLabel: UILabel!
    @IBOutlet weak var entryDateLabel: UILabel!
    @IBOutlet weak var exclusivityDateLabel: UILabel!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.topTitleLabel.text = "more_info".localized
        self.saleOrRentTitleLabel.text = NSLocalizedString("sell_or_rent", comment: "")
        self.typeTitleLabel.text = NSLocalizedString("property_type", comment: "")
        self.sizeTitleLabel.text = NSLocalizedString("size_in_meters", comment: "")
        self.priceTitleLabel.text = NSLocalizedString("price", comment: "")
        self.roomsTitleLabel.text = NSLocalizedString("number_of_rooms", comment: "")
        self.floorNumberTitleLabel.text = NSLocalizedString("floor_number", comment: "")
        self.balconyTitleLabel.text = NSLocalizedString("balcony", comment: "")
        self.parkingTitleLabel.text = NSLocalizedString("parking", comment: "")
        self.entryDateTitleLabel.text = NSLocalizedString("entry_date", comment: "")
        self.exclusivityDateTitleLabel.text = NSLocalizedString("exclusivity", comment: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.saleOrRentLabel.text = ""
        self.typeLabel.text = ""
        self.sizeLabel.text = ""
        self.priceLabel.text = ""
        self.roomsLabel.text = ""
        self.floorNumberLabel.text = ""
        self.balconyLabel.text = ""
        self.parkingLabel.text = ""
        self.entryDateLabel.text = ""
        self.exclusivityDateLabel.text = ""
    }
    
    func configure(_ property: Property) {
        self.saleOrRentLabel.text = property.sellOrRent ?? ""
        self.typeLabel.text = Application.AssetType(rawValue: Int(property.type))?.localized()
        self.sizeLabel.text = "\(property.size)"
        
        if let priceString = property.price, let priceInt = Int(priceString) {
            let priceNumber = NSNumber(integerLiteral: priceInt)
            self.priceLabel.text = Application.priceFormatter.string(from: priceNumber)
        } else {
            self.priceLabel.text = ""
        }
        
        self.roomsLabel.text = "\(property.rooms)"
        self.floorNumberLabel.text = "\(property.floorNumber) מתוך \(property.totalFloorNumber)"
        self.balconyLabel.text = "\(property.balcony)"
        self.parkingLabel.text = "\(property.parking)"
        
        if property.enterDateIsNow {
            self.entryDateLabel.text = "מיידי"
        } else if let entryDate = property.entryDate {
            self.entryDateLabel.text = self.dateFormatter.string(from: entryDate)
        } else {
            self.entryDateLabel.text = ""
        }
        
        if property.isExclusivity {
            if let exclusivityEndDate: Date = property.exclusivityEndDate {
                self.exclusivityDateLabel.text = NSLocalizedString("yes", comment: "") + ", " + NSLocalizedString("until", comment: "") + " " + self.dateFormatter.string(from: exclusivityEndDate)
            } else {
                self.exclusivityDateLabel.text = NSLocalizedString("yes", comment: "")
            }
        } else {
            self.exclusivityDateLabel.text = NSLocalizedString("no", comment: "")
        }
    }
    
}
