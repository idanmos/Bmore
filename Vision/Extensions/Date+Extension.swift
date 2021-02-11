//
//  Date+Extension.swift
//  Vision
//
//  Created by Idan Moshe on 24/12/2020.
//

import Foundation

// MARK: Calculations

extension Date {
        
    var startOfDay: Date { return Calendar.localizedCurrent.startOfDay(for: self) }
    
    var startOfWeek: Date { return Calendar.localizedCurrent.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date! }
    
    var endOfWeek: Date { Calendar.localizedCurrent.date(byAdding: .day, value: 6, to: self.startOfWeek)! }
    
    var quarterSymbols: [String] {
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
    
    func adding(years: Int? = 0, months: Int? = 0, days: Int? = 0, hours: Int? = 0, minutes: Int? = 0, seconds: Int? = 0) -> Date {
        return Calendar.current.date(byAdding: DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds), to: self) ?? self
    }
    
    func days(until date: Date, timeZone: TimeZone? = nil) -> Int {
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        let firstMidnightDate = calendar.startOfDay(for: self)
        let secondMidnightDate = calendar.startOfDay(for: date)
        return calendar.dateComponents([.day], from: firstMidnightDate, to: secondMidnightDate).day ?? 0
    }
    
}

// MARK: - Components
extension Date {
    /// The `year` date component of `self`. The time zone used is equal to the `Calendar.current.timeZone`.
    var year: Int {
        return Calendar.localizedCurrent.component(.year, from: self)
    }

    /// The `month` date component of `self`. The time zone used is equal to the `Calendar.current.timeZone`.
    var month: Int {
        return Calendar.localizedCurrent.component(.month, from: self)
    }

    /// The `day` date component of `self`. The time zone used is equal to the `Calendar.current.timeZone`.
    var day: Int {
        return Calendar.localizedCurrent.component(.day, from: self)
    }

    /// The `hour` date component of `self`. The time zone used is equal to the `Calendar.current.timeZone`.
    var hour: Int {
        return Calendar.localizedCurrent.component(.hour, from: self)
    }

    /// The `minute` date component of `self`. The time zone used is equal to the `Calendar.current.timeZone`.
    var minute: Int {
        return Calendar.localizedCurrent.component(.minute, from: self)
    }

    /// The `second` date component of `self`. The time zone used is equal to the `Calendar.current.timeZone`.
    var second: Int {
        return Calendar.localizedCurrent.component(.second, from: self)
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
