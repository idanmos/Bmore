//
//  SelectionTransactionTableViewCell.swift
//  Bmore
//
//  Created by Idan Moshe on 25/01/2021.
//

import UIKit

class SelectionTransactionTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var selectionImageView: UIImageView!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var dateTitleLabel: UILabel!
    @IBOutlet private weak var dateValueLabel: UILabel!
    @IBOutlet private weak var priceTitleLabel: UILabel!
    @IBOutlet private weak var priceValueLabel: UILabel!
    @IBOutlet private weak var commisionTitleLabel: UILabel!
    @IBOutlet private weak var commisionValueLabel: UILabel!
    
    var transaction: Transaction? {
        willSet {
            guard let newValue = newValue else { return }
            
            self.addressLabel.text = "\(NSLocalizedString("address", comment: "")) - \(NSLocalizedString("not_available", comment: ""))"
            
            if let address: String = newValue.address {
                self.addressLabel.text = address
            } else {
                if let locationType = Application.TransactionLocationType(rawValue: newValue.locationType) {
                    switch locationType {
                    case .property:
                        if let propertyId: UUID = newValue.propertyId,
                           let property: Property = PersistentStorage.shared.fetchProperty(by: propertyId) {
                            self.addressLabel.text = property.address
                        }
                    case .address:
                        break
                    }
                }
            }
                    
            if let date: Date = newValue.date {
                self.dateValueLabel.text = DateFormatter.dayFormatter.string(from: date)
            } else {
                self.dateValueLabel.text = NSLocalizedString("not_available", comment: "")
            }
            
            if let price: NSDecimalNumber = newValue.price {
                self.priceValueLabel.text = Application.priceFormatter.string(from: price)
            } else {
                self.priceValueLabel.text = NSLocalizedString("not_available", comment: "")
            }
            
            if let commision: NSDecimalNumber = newValue.commission, NSDecimalNumber.notANumber != commision {
                if let commisionType = Application.TransactionCommisionType(rawValue: newValue.commisionType) {
                    switch commisionType {
                    case .percent:
                        if let price: NSDecimalNumber = newValue.price {
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
    
    deinit {
        debugPrint("Deallocating \(self)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.setSelected(false, animated: true)
        
        self.dateTitleLabel.text = "date".localized
        self.priceTitleLabel.text = "price".localized
        self.commisionTitleLabel.text = "commision".localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionImageView.isHidden = !selected
    }
    
}
