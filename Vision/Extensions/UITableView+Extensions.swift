//
//  UITableView+Extensions.swift
//  Vision
//
//  Created by Idan Moshe on 07/12/2020.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ className: T.Type) {
        guard Bundle.main.path(forResource: String(describing: className), ofType: "nib") != nil else {
            self.register(className, forCellReuseIdentifier: String(describing: className))
            return
        }
        self.register(UINib(nibName: String(describing: className), bundle: nil), forCellReuseIdentifier: String(describing: className))
    }
    
    func dequeue<T: UITableViewCell>(_ className: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: className), for: indexPath) as! T
    }
    
}
