//
//  FactoryController.swift
//  B-more
//
//  Created by Idan Moshe on 13/01/2021.
//

import UIKit

class FactoryController {
    
    enum Screen {
        case properties
        case contacts
        case timeTracking
        case advanced
        
        enum AdvancedScreen {
            case balance
            case meetings
            case transactions
            case leads
            case tasks
            
            var viewController: UIViewController {
                switch self {
                case .balance: return BalancePageViewController.build()
                case .meetings: return MeetingsTableViewController(nibName: MeetingsTableViewController.className(), bundle: nil)
                case .transactions: return TransactionsTableViewController(nibName: TransactionsTableViewController.className(), bundle: nil)
                case .leads: return Screen.advanced.storyboard.instantiateInitialViewController()!
                case .tasks: return TasksViewController(nibName: TasksViewController.className(), bundle: nil)
                }
            }
        }
        
        case targets
        
        var storyboard: UIStoryboard {
            switch self {
            case .properties: return UIStoryboard(name: "Properties", bundle: nil)
            case .contacts: return UIStoryboard(name: "Contacts", bundle: nil)
            case .timeTracking: return UIStoryboard(name: "TimeTracking", bundle: nil)
            case .advanced: return UIStoryboard(name: "Advanced", bundle: nil)
            case .targets: return UIStoryboard(name: "Targets", bundle: nil)
            }
        }
        
    }
            
}
