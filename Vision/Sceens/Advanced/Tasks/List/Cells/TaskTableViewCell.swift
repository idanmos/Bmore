//
//  TaskTableViewCell.swift
//  B-more
//
//  Created by Idan Moshe on 15/01/2021.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ task: Task) {
        self.textLabel?.text = task.title
        
        let status = Application.TaskStatus(rawValue: task.status)!.localized
        let type = Application.TaskType(rawValue: task.type)!.localized
        
        self.detailTextLabel?.text = "\("status".localized): \(status) \(Application.SpecialCharacters.largeMiddlePoint) \("type".localized): \(type)"
        
        self.detailTextLabel?.changeFont(ofText: "\("status".localized):", with: .boldSystemFont(ofSize: 12.0))
        self.detailTextLabel?.changeFont(ofText: "\("type".localized):", with: .boldSystemFont(ofSize: 12.0))
    }
    
}
