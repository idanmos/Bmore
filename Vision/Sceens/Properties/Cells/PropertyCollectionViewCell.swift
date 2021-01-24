//
//  PropertyCollectionViewCell.swift
//  Vision
//
//  Created by Idan Moshe on 08/12/2020.
//

import UIKit

protocol PropertyCollectionViewCellDelegate: class {
    func propertyCell(_ propertyCell: PropertyCollectionViewCell, didTapOnDeleteAt index: Int)
}

class PropertyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var soldImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var sizeTitleLabel: UILabel!
    @IBOutlet weak var roomsTitleLabel: UILabel!
    @IBOutlet weak var floorTitleLabel: UILabel!
    @IBOutlet weak var balconyTitleLabel: UILabel!
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var balconyLabel: UILabel!
    
    weak var delegate: PropertyCollectionViewCellDelegate?
    var allowsMultipleSelection: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.sizeTitleLabel.text = "size".localized
        self.roomsTitleLabel.text = "rooms".localized
        self.floorTitleLabel.text = "floor".localized
        self.balconyTitleLabel.text = "balcony".localized
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
        self.priceLabel.text = nil
        self.typeLabel.text = nil
        self.sizeLabel.text = nil
        self.roomsLabel.text = nil
        self.floorLabel.text = nil
        self.balconyLabel.text = nil
    }
    
    func configure(_ property: Property) {
        self.addressLabel.text = property.address ?? ""
                
        if let priceString = property.price, let priceInt = Int(priceString) {
            let priceNumber = NSNumber(integerLiteral: priceInt)
            self.priceLabel.text = Application.priceFormatter.string(from: priceNumber)
        } else {
            self.priceLabel.text = ""
        }
        
        self.typeLabel.text = Application.AssetType(rawValue: Int(property.type))!.localized()
        self.sizeLabel.text = "\(property.size)"
        self.roomsLabel.text = "\(property.rooms)"
        self.floorLabel.text = "\(property.floorNumber)"
        self.balconyLabel.text = "\(property.balcony)"
        
        if let firstImage = ImageStorage.shared.loadFirstImage(propertyId: property.propertyId) {
            self.imageView.image = firstImage
        }
        
        self.soldImageView.isHidden = !property.isSold
    }
    
    func makeSelected(_ isCellSelected: Bool) {
        if self.allowsMultipleSelection {
            if isCellSelected {
                self.layer.borderWidth = 1.0
                self.layer.borderColor = UIColor.systemGreen.cgColor
            } else {
                self.layer.borderWidth = 0
                self.layer.borderColor = nil
            }
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        self.layoutIfNeeded()
        self.addressLabel.preferredMaxLayoutWidth = self.addressLabel.bounds.size.width
        layoutAttributes.bounds.size.height = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
    
    @IBAction private func onDelete(_ sender: Any) {
        self.delegate?.propertyCell(self, didTapOnDeleteAt: self.tag)
    }
    
}
