//
//  DocumentCollectionViewCell.swift
//  Bmore
//
//  Created by Idan Moshe on 15/02/2021.
//

import UIKit

protocol DocumentCollectionViewCellDelegate: class {
    func documentCell(_ cell: DocumentCollectionViewCell, onLongPress index: Int)
}

class DocumentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var sizeLabel: UILabel!
    
    weak var delegate: DocumentCollectionViewCellDelegate?
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.onLongPressGesture(_:)))
        return gesture
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameLabel.numberOfLines = 0
        self.addGestureRecognizer(self.longPressGesture)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.nameLabel.text = nil
        self.dateLabel.text = nil
        self.sizeLabel.text = nil
    }
    
    func configure(_ file: File) {
        self.nameLabel.text = file.name
        
        if let modificationDate: Date = file.url.modificationDate {
            self.dateLabel.text = DateFormatter.dayFormatter.string(from: modificationDate)
        }
        self.sizeLabel.text = file.getSize()
        
        file.generateThumbnail { [weak self] (image: UIImage) in
            guard let self = self else { return }
            DispatchMainThreadSafe {
                self.imageView.image = image
            }
        }
    }
    
    @objc private func onLongPressGesture(_ sender: UIGestureRecognizer) {
        self.delegate?.documentCell(self, onLongPress: self.tag)        
    }
    
}
