//
//  TransactionTableViewCell.swift
//  Bmore
//
//  Created by Idan Moshe on 04/02/2021.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    
    var transaction: Transaction? {
        willSet {
            guard let newValue: Transaction = newValue else { return }
            
            /// - Tag: Date
            if let date: Date = newValue.date {
                self.dateLabel.text = DateFormatter.dayFormatter.string(from: date)
            } else {
                self.dateLabel.text = NSLocalizedString("not_available", comment: "")
            }
            
            /// - Tag: Status
            if let status = Application.TransactionStatus(rawValue: newValue.status) {
                self.statusLabel.text = "\(Application.SpecialCharacters.largeMiddlePoint) \(status.title)"
                
                if status == .pending {
                    self.statusLabel.textColor = .systemOrange
                } else if status == .closed {
                    self.statusLabel.textColor = .systemGreen
                } else {
                    self.statusLabel.textColor = .label
                }
            } else {
                self.statusLabel.text = "not_available".localized
            }
            
            /// - Tag: Type
            if let type = Application.TransactionType(rawValue: newValue.type) {
                self.typeLabel.text = type.title
            } else {
                self.typeLabel.text = "not_available".localized
            }
            
            /// - Tag: Amount
            if let price: NSDecimalNumber = newValue.price {
                self.amountLabel.text = Application.priceFormatter.string(from: price)
            } else {
                self.amountLabel.text = "\("price".localized) - \("not_available".localized)"
            }
        }
    }
    
    deinit {
        debugPrint("Deallocating \(self)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
