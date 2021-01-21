//
//  AdvancedViewModel.swift
//  B-more
//
//  Created by Idan Moshe on 11/01/2021.
//

import UIKit

enum AdvancedCategory: Int, CaseIterable {
    case balance, meetings, transactions, leads, tasks
    
    func image() -> UIImage? {
        switch self {
        case .balance: return UIImage(named: "goal_financial")
        case .meetings: return UIImage(named: "goal_meetings")
        case .transactions: return UIImage(named: "goal_transactions")
        case .leads: return UIImage(named: "goal_leads")
        case .tasks: return UIImage(named: "goal_tasks")
        }
    }
    
    func title() -> String {
        switch self {
        case .balance: return NSLocalizedString("financial_balance", comment: "")
        case .meetings: return NSLocalizedString("meetings", comment: "")
        case .transactions: return NSLocalizedString("transactions", comment: "")
        case .leads: return NSLocalizedString("leads", comment: "")
        case .tasks: return NSLocalizedString("tasks", comment: "")
        }
    }
    
}

class AdvancedViewModel {
    
    var presenter: UIViewController?
    let dataSource: [AdvancedCategory] = AdvancedCategory.allCases
    
}
