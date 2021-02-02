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
        case leads
        case tasks
        case newTask
        case reports
        case timeTracking
        case advanced
        case meetings
        case transactions
        case addTransaction
        
        case targets
        case propertyDetails(property: Property)
        
        var viewController: UIViewController {
            switch self {
            case .properties: return PropertiesViewController(style: .plain)
            case .leads: return UIStoryboard(name: "Leads", bundle: nil).instantiateInitialViewController()!
            case .tasks: return TasksViewController(nibName: TasksViewController.className(), bundle: nil)
            case .newTask: return UIStoryboard(name: "Tasks", bundle: nil).instantiateViewController(withIdentifier: NewTaskTableViewController.className())
            case .reports: return ReportsPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            case .meetings: return MeetingsTableViewController(nibName: MeetingsTableViewController.className(), bundle: nil)
            case .transactions: return TransactionsTableViewController(nibName: TransactionsTableViewController.className(), bundle: nil)
            case .timeTracking: return UIStoryboard(name: "TimeTracking", bundle: nil).instantiateInitialViewController()!
            case .advanced: return UIStoryboard(name: "More", bundle: nil).instantiateInitialViewController()!
            case .targets: return UIStoryboard(name: "Targets", bundle: nil).instantiateInitialViewController()!
            case .addTransaction: return UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: AddTransactionTableViewController.className())
                
            case .propertyDetails(property: let property):
                return PropertyDetailsViewController(property: property)
            }
        }
    }
}
