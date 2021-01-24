//
//  MeetingsViewModel.swift
//  Vision
//
//  Created by Idan Moshe on 27/12/2020.
//

import UIKit
import EventKit
import EventKitUI

class MeetingsViewModel: NSObject {
    
    enum Constants {
        static let oneMonth: TimeInterval = 30*24*3600
    }
    
    private let eventStore = EKEventStore()
    private var calendar: EKCalendar!
    var events: [MeetingEvent] = []
    var eventsObserver: () -> Void = {}
    
    override init() {
        super.init()
    }
    
    private func createCalendar() {
        let calendar = EKCalendar(for: .event, eventStore: self.eventStore)
        calendar.title = NSLocalizedString("app_name", comment: "")
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
            if let obj: EKCalendar = self.getCalendar() {
                self.calendar = obj
            } else {
                self.createCalendar()
            }
            if let handler = completionHandler { handler(accessGranted, error) }
        }
    }
    
    func create(presenter: UITableViewController) {
        let eventViewController = EKEventEditViewController()
        eventViewController.view.tag = 1234321
        eventViewController.editViewDelegate = self
        eventViewController.eventStore = self.eventStore
        presenter.present(eventViewController, animated: true, completion: nil)
    }
    
    func edit(presenter: UITableViewController, event: EKEvent) {
        let eventViewController = EKEventEditViewController()
        eventViewController.editViewDelegate = self
        eventViewController.eventStore = self.eventStore
        eventViewController.event = event
        presenter.present(eventViewController, animated: true, completion: nil)
    }
    
    func show(presenter: UITableViewController, event: EKEvent) {
        let eventViewController = EKEventViewController()
        eventViewController.event = event
        presenter.present(eventViewController, animated: true, completion: nil)
    }
    
    func delete(event: EKEvent) {
        do {
            try self.eventStore.remove(event, span: .futureEvents)
            self.events.removeAll { (obj: MeetingEvent) -> Bool in
                return obj.event == event
            }
        } catch let error {
            debugPrint(#file, #function, error)
        }
    }
    
    private func getAllEvents() -> [MeetingEvent] {
        let startDate = Date().addingTimeInterval(-(Constants.oneMonth*12))
        let endDate = Date().addingTimeInterval(Constants.oneMonth*12)
        
        let predicate: NSPredicate = self.eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: [self.calendar])
        let events: [EKEvent] = self.eventStore.events(matching: predicate)
        
        let mappedEvents: [MeetingEvent] = events.map { (obj: EKEvent) -> MeetingEvent in
            return MeetingEvent(event: obj)
        }
        
        return mappedEvents
    }
    
    func fetchEvents() {
        self.events = self.getAllEvents()
    }
    
}

// MARK: - EKEventEditViewDelegate

extension MeetingsViewModel: EKEventEditViewDelegate {
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
        
        if controller.view.tag == 1234321 {
            // add action
            debugPrint("add action")
        }
        
        self.eventsObserver()
    }
    
    func eventEditViewControllerDefaultCalendar(forNewEvents controller: EKEventEditViewController) -> EKCalendar {
        return self.calendar
    }
    
}
