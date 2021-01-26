//
//  ShowTaskTableViewCell.swift
//  Bmore
//
//  Created by Idan Moshe on 26/01/2021.
//

import UIKit

class ShowTaskTableViewCell: UITableViewCell {
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
