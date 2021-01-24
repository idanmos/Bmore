//
//  MeetingEvent.swift
//  Vision
//
//  Created by Idan Moshe on 27/12/2020.
//

import UIKit
import EventKit

enum MeetingEventStatus : Int {
    case none = 0
    case confirmed = 1
    case tentative = 2
    case canceled = 3
}

class MeetingEvent {
    
    var event: EKEvent
    init(event: EKEvent) {
        self.event = event
    }
    
    func eventIdentifier() -> String {
        return self.event.eventIdentifier
    }
    
    func title() -> String {
        return self.event.title
    }
    
    func startDate() -> Date {
        return self.event.startDate
    }
    
    func endDate() -> Date {
        return self.event.endDate
    }
    
    func isAllDay() -> Bool {
        return self.event.isAllDay
    }
    
    func status() -> MeetingEventStatus {
        return MeetingEventStatus(rawValue: self.event.status.rawValue) ?? .none
    }
    
    func locationTitle() -> String? {
        if let obj = self.event.structuredLocation {
            if let title = obj.title {
                return title
            }
        }
        
        return nil
    }
    
}
