//
//  LeadAddEditViewModel.swift
//  Bmore
//
//  Created by Idan Moshe on 25/01/2021.
//

import Foundation

class LeadAddEditViewModel {
    
    private lazy var properties: [Property] = PropertiesViewModel.fetchProperties()
    private lazy var transactions: [Transaction] = TransactionsViewModel.fetchTransactions()
    private lazy var tasks: [Task] = TasksViewModel.fetchTasks()
    private lazy var meetings: [MeetingEvent] = MeetingService.shared.fetchEvents()
    
    var selectedProperties: [Property] = []
    var selectedTransactions: [Transaction] = []
    var selectedTasks: [Task] = []
    var selectedMeetings: [MeetingEvent] = []
    var selectedRating: Double = 0
    
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
