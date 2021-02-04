//
//  TargetsViewModel.swift
//  B-more
//
//  Created by Idan Moshe on 08/01/2021.
//

import UIKit

enum TargetCategory: Int, CaseIterable {
    case personal, financial, transactions, meetings, score
    
    func image() -> UIImage? {
        switch self {
        case .personal: return UIImage(named: "goal_personal")
        case .financial: return UIImage(named: "goal_financial")
        case .transactions: return UIImage(named: "goal_transactions")
        case .meetings: return UIImage(named: "goal_meetings")
        case .score: return UIImage(named: "goal_score")
        }
    }
    
    func title() -> String {
        switch self {
        case .personal: return NSLocalizedString("personal", comment: "")
        case .financial: return NSLocalizedString("financial", comment: "")
        case .transactions: return NSLocalizedString("transactions", comment: "")
        case .meetings: return NSLocalizedString("meetings", comment: "")
        case .score: return NSLocalizedString("score", comment: "")
        }
    }
}

class TargetsViewModel {
    
    let dataSource: [TargetCategory] = [.personal, .financial, .transactions, .meetings, .score]
    
}
