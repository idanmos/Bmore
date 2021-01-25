//
//  SelectionTaskTableViewCell.swift
//  Bmore
//
//  Created by Idan Moshe on 25/01/2021.
//

import UIKit

class SelectionTaskTableViewCell: UITableViewCell {
        
    var task: Task? {
        willSet {
            guard let newValue: Task = newValue else { return }
            
            self.textLabel?.text = newValue.title
            
            let status = Application.TaskStatus(rawValue: newValue.status)!.localized
            let type = Application.TaskType(rawValue: newValue.type)!.localized
            
            self.detailTextLabel?.text = "\("status".localized): \(status) \(Application.SpecialCharacters.largeMiddlePoint) \("type".localized): \(type)"
            
            self.detailTextLabel?.changeFont(ofText: "\("status".localized):", with: .boldSystemFont(ofSize: 12.0))
            self.detailTextLabel?.changeFont(ofText: "\("type".localized):", with: .boldSystemFont(ofSize: 12.0))
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
