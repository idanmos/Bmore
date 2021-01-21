//
//  Date+Extension.swift
//  Vision
//
//  Created by Idan Moshe on 24/12/2020.
//

import Foundation

extension Date {
    
    func startOfWeek(using calendar: Calendar = .localizedCurrent) -> Date {
        calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
    
    func endOfWeek(using calendar: Calendar = .localizedCurrent) -> Date {
        return calendar.date(byAdding: .day, value: 6, to: self.startOfWeek())!
    }
    
    func quarterSymbols() -> [String] {
        let symbols: [String] = Calendar.localizedCurrent.monthSymbols
        let month: Int = Calendar.localizedCurrent.component(.month, from: self)
        
        let firstQuarterRange = 1...3
        let secondQuarterRange = 4...6
        let thirdQuarterRange = 7...9
        let forthQuarterRange = 10...12
        
        if firstQuarterRange.contains(month) {
            return [symbols[0], symbols[1], symbols[2]]
        } else if secondQuarterRange.contains(month) {
            return [symbols[3], symbols[4], symbols[5]]
        } else if thirdQuarterRange.contains(month) {
            return [symbols[6], symbols[7], symbols[8]]
        } else if forthQuarterRange.contains(month) {
            return [symbols[9], symbols[10], symbols[11]]
        }
        
        return []
    }
    
    func monthName() -> String {
        return DateFormatter.monthOnlyFormatter.string(from: self)
    }
    
    func monthValue() -> Int {
        Calendar.localizedCurrent.component(.month, from: self)
    }
    
}

extension Date {

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

    var isInThisYear:  Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(as: Date()) }

    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
}
