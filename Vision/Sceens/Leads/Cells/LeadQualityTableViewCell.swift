//
//  LeadQualityTableViewCell.swift
//  Bmore
//
//  Created by Idan Moshe on 27/01/2021.
//

import UIKit

protocol LeadQualityTableViewCellDelegate: class {
    func leadQualityCell(_ leadQualityCell: LeadQualityTableViewCell, didUpdate rating: Double)
}

class LeadQualityTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var ratingTitleLabel: UILabel!
    @IBOutlet private weak var floatRatingView: FloatRatingView!
    
    weak var delegate: LeadQualityTableViewCellDelegate?
    
    var rating: Double? {
        willSet {
            guard let newValue: Double = newValue else { return }
            self.floatRatingView.rating = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.floatRatingView.backgroundColor = .clear
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = .scaleAspectFit
        self.floatRatingView.type = .wholeRatings
        
        self.ratingTitleLabel.text = "rating".localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - FloatRatingViewDelegate

extension LeadQualityTableViewCell: FloatRatingViewDelegate {
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        //
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        self.delegate?.leadQualityCell(self, didUpdate: rating)
    }
    
}
