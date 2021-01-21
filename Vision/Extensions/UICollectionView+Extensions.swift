//
//  UICollectionView+Extensions.swift
//  Vision
//
//  Created by Idan Moshe on 08/12/2020.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(className: T.Type) {
        self.register(UINib(nibName: String(describing: className), bundle: nil), forCellWithReuseIdentifier: String(describing: className))
    }
    
    func dequeue<T: UICollectionViewCell>(className: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: className), for: indexPath) as! T
    }
    
}
