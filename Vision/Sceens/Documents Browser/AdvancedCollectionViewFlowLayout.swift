//
//  AdvancedCollectionViewFlowLayout.swift
//  Bmore
//
//  Created by Idan Moshe on 15/02/2021.
//

import UIKit

enum CollectionDisplay {
    case inline
    case list
    case grid
}

class AdvancedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var display : CollectionDisplay = .grid {
            didSet {
                if display != oldValue {
                    self.invalidateLayout()
                }
            }
        }
        
        convenience init(display: CollectionDisplay) {
            self.init()
            
            self.display = display
            self.minimumLineSpacing = 1
            self.minimumInteritemSpacing = 1
            self.configLayout()
        }
        
        func configLayout() {
            switch display {
            case .inline:
                self.scrollDirection = .horizontal
                if let collectionView = self.collectionView {
                    self.itemSize = CGSize(width: collectionView.frame.width * 0.9, height: 300)
                }
                
            case .grid:
                
                self.scrollDirection = .vertical
                if let collectionView = self.collectionView {
                    let optimisedWidth = (collectionView.frame.width - minimumInteritemSpacing) / 3.5
                    self.itemSize = CGSize(width: optimisedWidth , height: optimisedWidth) // keep as square
                }
                
            case .list:
                self.scrollDirection = .vertical
                if let collectionView = self.collectionView {
                    self.itemSize = CGSize(width: collectionView.frame.width , height: 130)
                }
            }
        }
        
        override func invalidateLayout() {
            super.invalidateLayout()
            self.configLayout()
        }
    
}
