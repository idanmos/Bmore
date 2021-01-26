//
//  LeadAddEditViewModel.swift
//  Bmore
//
//  Created by Idan Moshe on 25/01/2021.
//

import Foundation

class LeadAddEditViewModel {
    
    private lazy var properties: [Property] = PersistentStorage.shared.fetchProperties()
    private lazy var transactions: [Transaction] = PersistentStorage.shared.fetchTransactions()
    private lazy var tasks: [Task] = PersistentStorage.shared.fetchTasks()
    private lazy var meetings: [MeetingEvent] = MeetingService.shared.fetchEvents()
    
    var selectedProperties: [Property] = []
    var selectedTransactions: [Transaction] = []
    var selectedTasks: [Task] = []
    var selectedMeetings: [MeetingEvent] = []
    
    deinit {
        debugPrint("Deallocating \(self)")
        self.properties.removeAll()
        self.transactions.removeAll()
        self.tasks.removeAll()
        self.meetings.removeAll()
        
        self.selectedProperties.removeAll()
        self.selectedTransactions.removeAll()
        self.selectedTasks.removeAll()
        self.selectedMeetings.removeAll()
    }
    
    func getProperties() -> [Property] {
        return self.properties
    }
    
    func getTransactions() -> [Transaction] {
        return self.transactions
    }
    
    func getTasks() -> [Task] {
        return self.tasks
    }
    
    func getMeetings() -> [MeetingEvent] {
        return self.meetings
    }
    
}
