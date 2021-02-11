//
//  MoreTableViewController.swift
//  Bmore
//
//  Created by Idan Moshe on 02/02/2021.
//

import UIKit

private enum SectionType: Int, CaseIterable {
    case profile, settings, meetings, transactions, timeTracking, goals
    
    var title: String {
        switch self {
        case .profile: return "profile".localized
        case .settings: return "settings".localized
        case .meetings: return "meetings".localized
        case .transactions: return "transactions".localized
        case .timeTracking: return "time_tracking".localized
        case .goals: return "goals".localized
        }
    }
    
    var image: UIImage? {
        switch self {
        case .profile: return UIImage(systemName: "person.crop.circle")
        case .settings: return UIImage(systemName: "gear")
        case .meetings: return UIImage(systemName: "person.3")
        case .transactions: return UIImage(systemName: "dollarsign.circle")
        case .timeTracking: return UIImage(systemName: "clock")
            
        case .goals:
            if #available(iOS 14, *) {
                return UIImage(systemName: "target")
            } else {
                return UIImage(systemName: "arrow.up.forward")
            }
        }
    }
    
    
    var imageBackgroundColor: UIColor {
        switch self {
        case .profile: return .wetAsphalt
        case .settings: return .concrete
        case .meetings: return .alizarin
        case .transactions: return .emerald
        case .timeTracking: return .peterRiver
        case .goals: return .wisteria
        }
    }
}

class MoreTableViewController: BaseTableViewController {
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var dataSource: [SectionType] = [.settings, .meetings, .transactions, .timeTracking, .goals]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "more".localized
        
        self.tableView.register(ProfileTableViewCell.self)
        self.tableView.register(MasterTableViewCell.self)
        
        if let cloudData: iCloudData = AppDelegate.sharedDelegate().cloudData, cloudData.hasiCloudAccount {
            self.dataSource.insert(.profile, at: 0)
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = self.dataSource[indexPath.row]
        
        if type == .profile {
            let cell = tableView.dequeue(ProfileTableViewCell.self, indexPath: indexPath)
            cell.profileImageView.image = type.image
            
            if let cloudData: iCloudData = AppDelegate.sharedDelegate().cloudData {
                if cloudData.hasiCloudAccount {
                    cell.profileAccountLabel.text = "iCloud"
                }
                if let nameComponents: PersonNameComponents = cloudData.nameComponents {
                    cell.profileNameLabel.text = "\(nameComponents.givenName ?? "") \(nameComponents.familyName ?? "")"
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeue(MasterTableViewCell.self, indexPath: indexPath)
            cell.menuTitleLabel.text = type.title
            cell.menuImageView.image = type.image
            cell.menuImageView.backgroundColor = type.imageBackgroundColor
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let type = self.dataSource[indexPath.row]
        
        switch type {
        case .profile:
            break
        case .settings:
            self.navigationController?.pushViewController(UIViewController(), animated: true)
        case .meetings:
            let viewController = FactoryController.Screen.meetings.viewController
            self.navigationController?.pushViewController(viewController, animated: true)
        case .transactions:
            let viewController = FactoryController.Screen.transactions.viewController
            self.navigationController?.pushViewController(viewController, animated: true)
        case .timeTracking:
            let viewController = FactoryController.Screen.timeTracking.viewController
            self.navigationController?.pushViewController(viewController, animated: true)
        case .goals:
            break
        }
    }

}
