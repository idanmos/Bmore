//
//  LabelAndTextViewTableViewCell.swift
//  Vision
//
//  Created by Idan Moshe on 10/12/2020.
//

import UIKit

class LabelAndTextViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.layer.borderWidth = 1.5
        self.textView.layer.borderColor = UIColor.systemGroupedBackground.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
