//
//  PropertyDetailsTitleAndSubtitleTableViewCell.swift
//  Vision
//
//  Created by Idan Moshe on 07/12/2020.
//

import UIKit

class PropertyDetailsTitleAndSubtitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var largeTitleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
