//
//  SingleTransactionTableViewCell.swift
//  B-more
//
//  Created by Idan Moshe on 09/01/2021.
//

import UIKit

class SingleTransactionTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var dateTitleLabel: UILabel!
    @IBOutlet private weak var dateValueLabel: UILabel!
    @IBOutlet private weak var priceTitleLabel: UILabel!
    @IBOutlet private weak var priceValueLabel: UILabel!
    @IBOutlet private weak var commisionTitleLabel: UILabel!
    @IBOutlet private weak var commisionValueLabel: UILabel!
    
    deinit {
        debugPrint("Deallocating \(self)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dateTitleLabel.text = NSLocalizedString("date", comment: "")
        self.priceTitleLabel.text = NSLocalizedString("price", comment: "")
        self.commisionTitleLabel.text = NSLocalizedString("commision", comment: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ transaction: Transaction) {
        self.addressLabel.text = "\(NSLocalizedString("address", comment: "")) - \(NSLocalizedString("not_available", comment: ""))"
        
        if let address: String = transaction.address {
            self.addressLabel.text = address
        } else {
            if let locationType = Application.TransactionLocationType(rawValue: transaction.locationType) {
                switch locationType {
                case .property:
                    if let propertyId: UUID = transaction.propertyId,
                       let property: Property = AppDelegate.sharedDelegate().coreDataStack.fetchProperty(by: propertyId) {
                        self.addressLabel.text = property.address
                    }
                case .address:
                    break
                }
            }
        }
                
        if let date: Date = transaction.date {
            self.dateValueLabel.text = DateFormatter.dayFormatter.string(from: date)
        } else {
            self.dateValueLabel.text = NSLocalizedString("not_available", comment: "")
        }
        
        if let price: NSDecimalNumber = transaction.price {
            self.priceValueLabel.text = Application.priceFormatter.string(from: price)
        } else {
            self.priceValueLabel.text = NSLocalizedString("not_available", comment: "")
        }
        
        if let commision: NSDecimalNumber = transaction.commission, NSDecimalNumber.notANumber != commision {
            if let commisionType = Application.TransactionCommisionType(rawValue: transaction.commisionType) {
                switch commisionType {
                case .percent:
                    if let price: NSDecimalNumber = transaction.price {
                        let amount: Double = price.doubleValue*commision.doubleValue/100
                        let priceNumber = NSNumber(value: amount)
                        if let formatted = Application.priceFormatter.string(from: priceNumber) {
                            self.commisionValueLabel.text = "\(commision.stringValue)% (\(formatted))"
                        } else {
                            self.commisionValueLabel.text = "\(commision.stringValue)% (\(Application.SpecialCharacters.localizedCurrencySign)\(priceNumber.stringValue))"
                        }
                    } else {
                        self.commisionValueLabel.text = "\(commision.stringValue)%"
                    }
                case .amount:
                    self.commisionValueLabel.text = commision.stringValue + Application.SpecialCharacters.localizedCurrencySign
                }
            }
        } else {
            self.commisionValueLabel.text = NSLocalizedString("not_available", comment: "")
        }
    }
    
}
