//
//  UICollectionViewFlowLayout+Extensions.swift
//  Bmore
//
//  Created by Idan Moshe on 15/02/2021.
//

import UIKit

extension UICollectionViewFlowLayout {
    
    static func grid(numberOfItems: Int) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        
        let interItemSpacing: CGFloat = 10 // space between items
        let maxWidth = UIScreen.main.bounds.size.width // device's width
        let numberOfItems: CGFloat = CGFloat(numberOfItems) // items
        let totalSpacing: CGFloat = numberOfItems * interItemSpacing
        let itemWidth: CGFloat = (maxWidth - totalSpacing) / numberOfItems
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 5.0
        flowLayout.sectionInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        return flowLayout
    }
    
}
