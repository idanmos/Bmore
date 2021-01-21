//
//  CalendarEventTableViewCell.swift
//  Vision
//
//  Created by Idan Moshe on 16/12/2020.
//

import UIKit

class CalendarEventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sidebarColorView: UIView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventSubtitleLabel: UILabel!
    @IBOutlet weak var eventTopValueLabel: UILabel!
    @IBOutlet weak var eventBottomValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
