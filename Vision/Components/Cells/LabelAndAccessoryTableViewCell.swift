//
//  LabelAndAccessoryTableViewCell.swift
//  Vision
//
//  Created by Idan Moshe on 10/12/2020.
//

import UIKit

class LabelAndAccessoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var accessoryLabel: UILabel!
    @IBOutlet weak var accessoryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
