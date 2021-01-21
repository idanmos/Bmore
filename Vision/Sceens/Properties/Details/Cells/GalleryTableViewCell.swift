//
//  GalleryTableViewCell.swift
//  Vision
//
//  Created by Idan Moshe on 07/12/2020.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {
        
    private lazy var pageController: GalleryViewController = {
        let viewController = GalleryViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        viewController.view.frame = self.contentView.bounds
        return viewController
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        self.contentView.addSubview(self.pageController.view)
        self.pageController.view.constraints(to: self.contentView)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(images: [UIImage]) {
        self.pageController.images = images
    }
    
}
