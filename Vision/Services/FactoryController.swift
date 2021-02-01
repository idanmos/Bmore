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
        case balance
        case meetings
        case transactions
        case leads
        case tasks
        case targets
        case propertyDetails(property: Property)
        
        var viewController: UIViewController {
            switch self {
            case .properties: return PropertiesViewController(style: .plain)
            case .balance: return BalancePageViewController.build()
            case .meetings: return MeetingsTableViewController(nibName: MeetingsTableViewController.className(), bundle: nil)
            case .transactions: return TransactionsTableViewController(nibName: TransactionsTableViewController.className(), bundle: nil)
            case .leads: return UIStoryboard(name: "Leads", bundle: nil).instantiateInitialViewController()!
            case .tasks: return TasksViewController(nibName: TasksViewController.className(), bundle: nil)
            case .contacts: return UIStoryboard(name: "Leads", bundle: nil).instantiateInitialViewController()!
            case .timeTracking: return UIStoryboard(name: "TimeTracking", bundle: nil).instantiateInitialViewController()!
            case .advanced: return UIStoryboard(name: "More", bundle: nil).instantiateInitialViewController()!
            case .targets: return UIStoryboard(name: "Targets", bundle: nil).instantiateInitialViewController()!
                
            case .propertyDetails(property: let property):
                return PropertyDetailsViewController(property: property)
            }
        }
    }
}
