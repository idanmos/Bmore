//
//  UITableViewCell+Extension.swift
//  Bmore
//
//  Created by Idan Moshe on 07/02/2021.
//

import UIKit

extension UITableViewCell {
    func hideSystemSeparator() {
        separatorInset = UIEdgeInsets(top: 0, left: max(UIScreen.main.bounds.width, UIScreen.main.bounds.height), bottom: 0, right: 0)
    }
}
