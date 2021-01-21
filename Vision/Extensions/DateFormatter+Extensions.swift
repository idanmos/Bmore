//
//  DateFormatter+Extensions.swift
//  Vision
//
//  Created by Idan Moshe on 24/12/2020.
//

import Foundation

extension DateFormatter {
    
    static var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        formatter.calendar = .current
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }
    
    static var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.calendar = .current
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }
    
    static var shortQuarterFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "Q,yyyy"
        formatter.calendar = .current
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }
    
    static var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, yyyy"
        formatter.calendar = .current
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }
    
    static var monthOnlyFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.calendar = .current
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }
    
    static var quarterFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "QQQQ, yyyy"
        formatter.calendar = .current
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }
    
    static var yearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        formatter.calendar = .current
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }
    
}
