//
//  GoalCollectionViewCell.swift
//  B-more
//
//  Created by Idan Moshe on 07/01/2021.
//

import UIKit

class GoalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                self.imageView.layer.borderColor = UIColor.gray.cgColor
                self.titleLabel.textColor = .gray
            } else {
                self.imageView.layer.borderColor = UIColor.black.cgColor
                self.titleLabel.textColor = .label
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageView.layer.borderWidth = 1.5
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2.0
        self.imageView.clipsToBounds = true
    }
    
    func configure(_ category: TargetCategory) {
        self.titleLabel.text = category.title()
        self.imageView.image = category.image()
    }
    
    func configure(_ category: MoreCategory) {
        self.titleLabel.text = category.title()
        self.imageView.image = category.image()
    }
        
}
