//
//  MeetingService.swift
//  Bmore
//
//  Created by Idan Moshe on 25/01/2021.
//

import UIKit
import EventKit
import EventKitUI

class MeetingService: NSObject {
    
    static let shared = MeetingService()
    
    private enum Constants {
        static let oneMonth: TimeInterval = 30*24*3600
    }
    
    lazy var dataSource: [MeetingEvent] = []
    var isAccessGranted: Bool = false
    
    private let eventStore = EKEventStore()
    private var calendar: EKCalendar!

    private func createCalendar() {
        let calendar = EKCalendar(for: .event, eventStore: self.eventStore)
        calendar.title = "app_name".localized
        calendar.source = self.eventStore.defaultCalendarForNewEvents?.source
        
        do {
            try self.eventStore.saveCalendar(calendar, commit: true)
            self.calendar = calendar
        } catch let error {
            debugPrint(#file, #function, error)
        }
    }
    
    func getCalendar() -> EKCalendar? {
        let calendars: [EKCalendar] = self.eventStore.calendars(for: .event)
        
        if calendars.count > 0 {
            if let filteredCalendar = calendars.first(where: { $0.title == NSLocalizedString("app_name", comment: "") }) {
                return filteredCalendar
            }
        }
        
        return nil
    }
    
    func requestAccess(completionHandler: ((Bool, Error?) -> Void)? = nil) {
        self.eventStore.requestAccess(to: .event) { (accessGranted: Bool, error: Error?) in
            debugPrint(#file, #function, "accessGranted", accessGranted, error as Any)
            
            self.isAccessGranted = accessGranted
            
            if let obj: EKCalendar = self.getCalendar() {
                self.calendar = obj
            } else {
                self.createCalendar()
            }
            if let handler = completionHandler { handler(accessGranted, error) }
        }
    }
    
    func create(presenter: UIViewController) {
        let eventViewController = EKEventEditViewController()
        eventViewController.editViewDelegate = self
        eventViewController.eventStore = self.eventStore
        presenter.present(eventViewController, animated: true, completion: nil)
    }
    
    func edit(presenter: UIViewController, event: EKEvent) {
        let eventViewController = EKEventEditViewController()
        eventViewController.editViewDelegate = self
        eventViewController.eventStore = self.eventStore
        eventViewController.event = event
        presenter.present(eventViewController, animated: true, completion: nil)
    }
    
    func show(presenter: UIViewController, event: EKEvent) {
        let eventViewController = EKEventViewController()
        eventViewController.event = event
        presenter.present(eventViewController, animated: true, completion: nil)
    }
    
    func delete(event: EKEvent) {
        do {
            try self.eventStore.remove(event, span: .futureEvents)
            self.dataSource.removeAll { (obj: MeetingEvent) -> Bool in
                return obj.event == event
            }
        } catch let error {
            debugPrint(#file, #function, error)
        }
    }
    
    func fetchEvents() -> [MeetingEvent] {
        let startDate = Date().addingTimeInterval(-(Constants.oneMonth*12))
        let endDate = Date().addingTimeInterval(Constants.oneMonth*12)
        
        let predicate: NSPredicate = self.eventStore.predicateForEvents(
            withStart: startDate,
            end: endDate,
            calendars: [self.calendar]
        )
        
        let events: [EKEvent] = self.eventStore.events(matching: predicate)
        
        return events.map({ return MeetingEvent(event: $0) })
    }
    
    deinit {
        debugPrint("Deallocating \(self)")
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - EKEventEditViewDelegate

extension MeetingService: EKEventEditViewDelegate {
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
        
        NotificationCenter.default.post(name: .eventEditDidEndNotification, object: action as Any)
        
        if controller.view.tag == 1234321 {
            // add action
            debugPrint(#file, #function, "add action")
        } else {
            debugPrint(#file, #function, "edit action")
        }
    }
    
    func eventEditViewControllerDefaultCalendar(forNewEvents controller: EKEventEditViewController) -> EKCalendar {
        return self.calendar
    }
    
}

extension Notification.Name {
    
    static let eventEditDidEndNotification = Notification.Name("eventEditDidEndNotification")
    
}
