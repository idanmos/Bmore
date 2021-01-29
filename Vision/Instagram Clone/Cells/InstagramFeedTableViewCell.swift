//
//  InstagramFeedTableViewCell.swift
//  B-more
//
//  Created by Idan Moshe on 10/01/2021.
//

import UIKit

class InstagramFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var galleryContentView: UIView!
    @IBOutlet weak var galleryPagerView: UIView!
    @IBOutlet weak var galleryPagerLabel: UILabel!
    @IBOutlet weak var galleryTaggingButton: UIButton!
    @IBOutlet weak var galleryPageControl: UIPageControl!
    @IBOutlet weak var firstLeftButton: UIButton!
    @IBOutlet weak var secondLeftButton: UIButton!
    @IBOutlet weak var thirdLeftButton: UIButton!
    @IBOutlet weak var firstRightButton: UIButton!
    @IBOutlet weak var bottomPersonNameLabel: UILabel!
    @IBOutlet weak var bottomActivityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var seeTranslationLabel: UILabel!
    
    private lazy var pageController: GalleryViewController = {
        let viewController = GalleryViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        viewController.view.frame = self.galleryContentView.bounds
        return viewController
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.personImageView.layer.cornerRadius = self.personImageView.frame.size.width/2
        self.personImageView.clipsToBounds = true
        self.personImageView.layer.borderWidth = 1.5
        self.personImageView.layer.borderColor = UIColor.black.cgColor
        
        self.galleryContentView.addSubview(self.pageController.view)
        self.pageController.view.constraints(to: self.galleryContentView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(images: [UIImage]) {
        self.pageController.images = images
    }
    
    @IBAction func onPressMoreButton(_ sender: Any) {
    }
    
    @IBAction func onPressGalleryTaggingButton(_ sender: Any) {
    }
    
    @IBAction func onPressRightLeftButton(_ sender: Any) {
    }
    
    @IBAction func onPressSecondLeftButton(_ sender: Any) {
    }
    
    @IBAction func onPressThirdLeftButton(_ sender: Any) {
    }
    
    @IBAction func onPressFirstRightButton(_ sender: Any) {
    }
    
}
