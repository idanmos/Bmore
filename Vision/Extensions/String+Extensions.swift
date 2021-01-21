//
//  String+Extensions.swift
//  B-more
//
//  Created by Idan Moshe on 14/01/2021.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
}
