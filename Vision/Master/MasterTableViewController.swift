//
//  MasterTableViewController.swift
//  Bmore
//
//  Created by Idan Moshe on 28/01/2021.
//

import UIKit

class MasterTableViewController: UITableViewController {
    
    private enum SectionType: Int, CaseIterable {
        case profile
        case properties
        case leads
        case timeTracking
        case targets
        case balance
        case meetings
        case transactions
        case tasks
        
        var title: String {
            switch self {
            case .profile: return "profile".localized
            case .properties: return "properties".localized
            case .leads: return "leads".localized
            case .timeTracking: return "".localized
            case .targets: return "targets".localized
            case .balance: return "reports".localized
            case .meetings: return "meetings".localized
            case .transactions: return "transactions".localized
            case .tasks: return "tasks".localized
            }
        }
        
        var image: UIImage? {
            switch self {
            case .profile: return UIImage(systemName: "person.crop.circle")
                
            case .properties:
                if #available(iOS 14, *) {
                    return UIImage(systemName: "building.2")
                } else {
                    return UIImage(systemName: "house")
                }
                
            case .leads: return UIImage(systemName: "person.2")
            case .timeTracking: return UIImage(systemName: "clock")
                
            case .targets:
                if #available(iOS 14, *) {
                    return UIImage(systemName: "target")
                } else {
                    return UIImage(systemName: "arrow.up.forward")
                }
            case .balance: return UIImage(systemName: "chart.pie")
            case .meetings: return UIImage(systemName: "person.3")
            case .transactions: return UIImage(systemName: "dollarsign.circle")
            case .tasks: return UIImage(systemName: "list.number")
            }
        }
        
        
        var imageBackgroundColor: UIColor {
            switch self {
            case .profile: return .turqoise
            case .properties: return .peterRiver
            case .leads: return .alizarin
            case .timeTracking: return .wetAsphalt
            case .targets: return .carrot
            case .balance: return .wisteria
            case .meetings: return .emerald
            case .transactions: return .pumpkin
            case .tasks: return .sunFlower
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(MasterTableViewCell.self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SectionType.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(MasterTableViewCell.self, indexPath: indexPath)
        let type = SectionType(rawValue: indexPath.row)!
        cell.menuTitleLabel.text = type.title
        cell.menuImageView.image = type.image
        cell.menuImageView.backgroundColor = type.imageBackgroundColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let type = SectionType(rawValue: indexPath.row) else { return }
        
        switch type {
        case .profile:
            self.splitViewController?.showDetailViewController(UIViewController(), sender: nil)
        case .properties:
            let viewController = FactoryController.Screen.properties.viewController
            self.splitViewController?.showDetailViewController(viewController, sender: nil)
        case .leads:
            let viewController = FactoryController.Screen.leads.viewController
            self.splitViewController?.showDetailViewController(viewController, sender: nil)
        case .timeTracking:
            let viewController = FactoryController.Screen.timeTracking.viewController
            self.splitViewController?.showDetailViewController(viewController, sender: nil)
        case .targets:
            let viewController = FactoryController.Screen.targets.viewController
            self.splitViewController?.showDetailViewController(viewController, sender: nil)
        case .balance:
            let viewController = FactoryController.Screen.reports.viewController
            self.splitViewController?.showDetailViewController(viewController, sender: nil)
        case .meetings:
            let viewController = FactoryController.Screen.meetings.viewController
            self.splitViewController?.showDetailViewController(viewController, sender: nil)
        case .transactions:
            let viewController = FactoryController.Screen.transactions.viewController
            self.splitViewController?.showDetailViewController(viewController, sender: nil)
        case .tasks:
            let viewController = FactoryController.Screen.tasks.viewController
            self.splitViewController?.showDetailViewController(viewController, sender: nil)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
