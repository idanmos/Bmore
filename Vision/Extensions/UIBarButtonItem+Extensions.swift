//
//  UIBarButtonItem+Extensions.swift
//  B-more
//
//  Created by Idan Moshe on 01/01/2021.
//

import UIKit

extension UIBarButtonItem {
    
    func replace(target: AnyObject? = nil, action: Selector? = nil) {
        self.target = target
        self.action = action
    }
    
}
