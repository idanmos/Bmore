//
//  PropertyDetailsHeadTopBottomTableViewCell.swift
//  Vision
//
//  Created by Idan Moshe on 15/12/2020.
//

import UIKit

class PropertyDetailsHeadTopBottomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
