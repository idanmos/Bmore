//
//  DashboardViewModel.swift
//  Bmore
//
//  Created by Idan Moshe on 06/02/2021.
//

import UIKit

enum DashboardSectionType: Int, CaseIterable {
    case performance, recentActivities, meetings, tasks, transactions
    
    var title: String {
        switch self {
        case .performance: return "performance".localized
        case .recentActivities: return "activities".localized
        case .meetings: return "meetings".localized
        case .tasks: return "tasks".localized
        case .transactions: return "transactions".localized
        }
    }
}

class DashboardViewModel: BaseViewModel {
    
    private var date = Date()
    
    var dataSource: [[Any]] = []

    
    deinit {
        debugPrint("Deallocating \(self)")
        self.dataSource.removeAll()
    }
    
    func fetchData(date: Date) {
        self.date = date
        
        self.dataSource.removeAll()
        
        let activities = ActivityManager.shared.activities.filter({ (obj: Activity) -> Bool in
            return obj.timestamp != nil && Calendar.localizedCurrent.isDate(obj.timestamp!, inSameDayAs: date)
        })
        
        let tasks = TasksViewModel.fetchTasks().filter({ (obj: Task) -> Bool in
            return obj.date != nil && Calendar.localizedCurrent.isDate(obj.date!, inSameDayAs: date)
        })
        
        let transactions = TransactionsViewModel.fetchTransactions().filter({ (obj: Transaction) -> Bool in
            return obj.date != nil && Calendar.localizedCurrent.isDate(obj.date!, inSameDayAs: date)
        })
        
        let meetings = MeetingService.shared.fetchEvents().filter({ (obj: MeetingEvent) -> Bool in
            let isStartDate = Calendar.localizedCurrent.isDate(obj.startDate(), inSameDayAs: date)
            let isEndDate = Calendar.localizedCurrent.isDate(obj.startDate(), inSameDayAs: date)
            return isStartDate || isEndDate
        })
        
        let timeTracking = TimeTrackingViewModel.fetchTimeTrack().filter({ (obj: TimeTrack) -> Bool in
            let isStartDate = obj.startDate != nil && Calendar.localizedCurrent.isDate(obj.startDate!, inSameDayAs: date)
            let isEndDate = obj.endDate != nil && Calendar.localizedCurrent.isDate(obj.endDate!, inSameDayAs: date)
            return isStartDate || isEndDate
        })
        
        self.dataSource.append(activities)
        self.dataSource.append(tasks)
        self.dataSource.append(transactions)
        self.dataSource.append(meetings)
        self.dataSource.append(timeTracking)
    }
    
}
