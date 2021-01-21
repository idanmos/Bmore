//
//  LeadPersonalDetailsTableViewCell.swift
//  B-more
//
//  Created by Idan Moshe on 17/01/2021.
//

import UIKit

class LeadPersonalDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leadImageButton: UIButton!
    @IBOutlet weak var leadNameLabel: UILabel!
    @IBOutlet weak var leadPhoneNumberLabel: UILabel!
    @IBOutlet weak var leadEmailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onPressLeadImage(_ sender: Any) {
    }
    
}
