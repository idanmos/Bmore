//
//  FacebookFeedPostTableViewCell.swift
//  Bmore
//
//  Created by Idan Moshe on 14/02/2021.
//

import UIKit

class FacebookFeedPostTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var typeImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var moreButton: UIButton!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var commentButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    
    var activity: Activity? {
        didSet(newValue) {
            guard let newValue: Activity = newValue else { return }
            
            if let type = ActivityType(rawValue: newValue.type) {
                self.typeImageView.image = type.image
                self.titleLabel.text = type.title
            }
            
            if let timestamp: Date = newValue.timestamp {
                self.dateLabel.text = DateFormatter.shortFormatter.string(from: timestamp)
            }
            
            self.messageLabel.text = newValue.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.typeImageView.layer.cornerRadius = self.typeImageView.frame.size.height/2.0
        self.typeImageView.layer.masksToBounds = true
        self.typeImageView.layer.borderWidth = 1.5
        self.typeImageView.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction private func onPressMoreButton(_ sender: UIButton) {}
    
    @IBAction private func onPressLikeButton(_ sender: UIButton) {}
    
    @IBAction private func onPressCommentButton(_ sender: UIButton) {}
    
    @IBAction private func onPressShareButton(_ sender: UIButton) {}
    
}
