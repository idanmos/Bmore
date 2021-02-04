//
//  TaskCheckboxTableViewCell.swift
//  Bmore
//
//  Created by Idan Moshe on 04/02/2021.
//

import UIKit

extension UIImage {
    static let checkBoxUnSelected = UIImage(systemName: "square")
    static let checkBoxSelected = UIImage(systemName: "checkmark.square")
}

class TaskCheckboxTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var indicatorView: UIView!
    @IBOutlet private weak var checkBoxDateLabel: UILabel!
    @IBOutlet private weak var checkBoxTitleLabel: UILabel!
    @IBOutlet private weak var checkBoxSubtitleLabel: UILabel!
    @IBOutlet private weak var checkboxButton: UIButton!
    
    var task: Task? {
        willSet {
            guard let newValue = newValue else { return }
            
            self.checkBoxTitleLabel.text = newValue.title
                        
            let status = Application.TaskStatus(rawValue: newValue.status)!
            let type = Application.TaskType(rawValue: newValue.type)!
            
            self.checkboxButton.isSelected = (status == .closed)
            self.indicatorView.backgroundColor = status.color
            self.checkBoxTitleLabel.text = newValue.title ?? ""
            
            if let date: Date = newValue.date {
                self.checkBoxDateLabel.text = DateFormatter.dayFormatter.string(from: date)
                self.checkBoxSubtitleLabel.text = type.localized
            } else {
                self.checkBoxDateLabel.text = type.localized
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.checkboxButton.addTarget(
            self,
            action: #selector(self.onPressCheckBox(_:)),
            for: .touchUpInside
        )
        
        self.checkboxButton.setImage(.checkBoxUnSelected, for: .normal)
        self.checkboxButton.setImage(.checkBoxSelected, for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func onPressCheckBox(_ sender: UIButton) {
        sender.isSelected.toggle()
                
        if let task: Task = self.task {
            if sender.isSelected {
                task.status = Application.TaskStatus.closed.rawValue
                self.indicatorView.backgroundColor = Application.TaskStatus.closed.color
            } else {
                task.status = Application.TaskStatus.inProgress.rawValue
                self.indicatorView.backgroundColor = Application.TaskStatus.inProgress.color
            }
        }
        
        AppDelegate.sharedDelegate().coreDataStack.saveContext()
    }
    
}
