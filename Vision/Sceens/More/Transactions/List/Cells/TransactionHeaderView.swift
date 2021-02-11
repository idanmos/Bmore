//
//  TransactionHeaderView.swift
//  Bmore
//
//  Created by Idan Moshe on 04/02/2021.
//

import UIKit

class TransactionHeaderView: StoryboardCustomClearXibView {
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dateLabel.text = "date".localized
        self.statusLabel.text = "status".localized
        self.typeLabel.text = "type".localized
        self.amountLabel.text = "amount".localized
    }
    
}
