//
//  Calendar+Extension.swift
//  Vision
//
//  Created by Idan Moshe on 24/12/2020.
//

import Foundation

extension Calendar {
    
    static var localizedCurrent: Calendar {
        var obj = Calendar.current
        obj.timeZone = .current
        obj.locale = .current
        return obj
    }
    
}
