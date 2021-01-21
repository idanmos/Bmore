//
//  MeetingTableViewCell.swift
//  Vision
//
//  Created by Idan Moshe on 28/12/2020.
//

import UIKit

protocol MeetingTableViewCellDelegate: class {
    func meetingCellOnPressShow(_ meetingCell: MeetingTableViewCell)
    func meetingCellOnPressEdit(_ meetingCell: MeetingTableViewCell)
    func meetingCellOnPressDelete(_ meetingCell: MeetingTableViewCell)
}

class MeetingTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var firstLabel: UILabel!
    @IBOutlet private weak var secondLabel: UILabel!
    @IBOutlet private weak var thirdLabel: UILabel!
    
    weak var delegate: MeetingTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction private func onPressShow(_ sender: Any) {
        self.delegate?.meetingCellOnPressShow(self)
    }
    
    @IBAction private func onPressEdit(_ sender: Any) {
        self.delegate?.meetingCellOnPressEdit(self)
    }
    
    @IBAction private func onPressDelete(_ sender: Any) {
        self.delegate?.meetingCellOnPressDelete(self)
    }
    
    func configure(_ event: MeetingEvent) {
        self.firstLabel.text = nil
        self.secondLabel.text = nil
        self.thirdLabel.text = nil
        
        self.firstLabel.text = event.title()
                
        if event.isAllDay() {
            self.secondLabel.text = NSLocalizedString("is_all_day", comment: "")
        } else {
            self.secondLabel.text = DateFormatter.shortFormatter.string(from: event.startDate())
        }
        
        if let address: String = event.locationTitle() {
            self.thirdLabel.text = address
        }
    }
    
    func configure(_ transaction: Transaction) {
        self.firstLabel.text = nil
        self.secondLabel.text = nil
        self.thirdLabel.text = nil
        
        if let date: Date = transaction.date {
            self.secondLabel.text = DateFormatter.shortFormatter.string(from: date)
        }
    }
    
}
