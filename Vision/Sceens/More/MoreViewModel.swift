//
//  MoreViewModel.swift
//  B-more
//
//  Created by Idan Moshe on 11/01/2021.
//

import UIKit

enum MoreCategory: Int, CaseIterable {
    case balance, meetings, transactions, tasks
    
    func image() -> UIImage? {
        switch self {
        case .balance: return UIImage(named: "goal_financial")
        case .meetings: return UIImage(named: "goal_meetings")
        case .transactions: return UIImage(named: "goal_transactions")
        case .tasks: return UIImage(named: "goal_score")
        }
    }
    
    func title() -> String {
        switch self {
        case .balance: return NSLocalizedString("reports", comment: "")
        case .meetings: return NSLocalizedString("meetings", comment: "")
        case .transactions: return NSLocalizedString("transactions", comment: "")
        case .tasks: return NSLocalizedString("tasks", comment: "")
        }
    }
    
}

class MoreViewModel {
    
    var presenter: UIViewController?
    let dataSource: [MoreCategory] = MoreCategory.allCases
    
}
