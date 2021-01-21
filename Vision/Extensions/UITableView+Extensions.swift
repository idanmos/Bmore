//
//  UITableView+Extensions.swift
//  Vision
//
//  Created by Idan Moshe on 07/12/2020.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(className: T.Type) {
        self.register(UINib(nibName: String(describing: className), bundle: nil), forCellReuseIdentifier: String(describing: className))
    }
    
    func dequeue<T: UITableViewCell>(className: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: className), for: indexPath) as! T
    }
    
}
