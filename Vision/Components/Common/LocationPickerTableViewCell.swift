//
//  LocationPickerTableViewCell.swift
//  LocationPicker
//
//  Created by Idan Moshe on 30/01/2021.
//

import UIKit

class LocationPickerTableViewCell: UITableViewCell {
    
    deinit {
        debugPrint("Deallocating \(self)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
