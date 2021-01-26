//
//  SelectionMeetingTableViewCell.swift
//  Bmore
//
//  Created by Idan Moshe on 25/01/2021.
//

import UIKit

class SelectionMeetingTableViewCell: UITableViewCell {
    
    var meeting: MeetingEvent? {
        willSet {
            guard let newValue: MeetingEvent = newValue else { return }
            
            let title: String = newValue.title()
            var subtitle: String = ""
                        
            
            if newValue.isAllDay() {
                subtitle += "is_all_day".localized
            } else {
                subtitle += DateFormatter.shortFormatter.string(from: newValue.startDate())
            }

            if let address: String = newValue.locationTitle() {
                self.detailTextLabel?.numberOfLines = 0
                subtitle += "\n"
                subtitle += address
            }
            
            self.textLabel?.text = title
            self.detailTextLabel?.text = subtitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.setSelected(false, animated: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.imageView!.isHidden = !selected
    }
    
}
