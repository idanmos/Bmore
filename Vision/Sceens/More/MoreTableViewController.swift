//
//  MoreTableViewController.swift
//  Bmore
//
//  Created by Idan Moshe on 02/02/2021.
//

import UIKit

private enum SectionType: Int, CaseIterable {
    case profile, settings, meetings, transactions, timeTracking
    
    var title: String {
        switch self {
        case .profile: return "profile".localized
        case .settings: return "settings".localized
        case .meetings: return "meetings".localized
        case .transactions: return "transactions".localized
        case .timeTracking: return "time_tracking".localized
        }
    }
    
    var image: UIImage? {
        switch self {
        case .profile: return UIImage(systemName: "person.crop.circle")
        case .settings: return UIImage(systemName: "gear")
        case .meetings: return UIImage(systemName: "person.3")
        case .transactions: return UIImage(systemName: "dollarsign.circle")
        case .timeTracking: return UIImage(systemName: "clock")
        }
    }
    
    
    var imageBackgroundColor: UIColor {
        switch self {
        case .profile: return .turqoise
        case .settings: return .peterRiver
        case .meetings: return .alizarin
        case .transactions: return .wisteria
        case .timeTracking: return .carrot
//        case .balance: return .wisteria
//        case .meetings: return .emerald
//        case .transactions: return .pumpkin
//        case .tasks: return .sunFlower
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "more".localized
        
        self.tableView.register(ProfileTableViewCell.self)
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
        let type = SectionType(rawValue: indexPath.row)!
        if type == .profile {
            let cell = tableView.dequeue(ProfileTableViewCell.self, indexPath: indexPath)
            cell.profileImageView.image = type.image
            
            if let cloudData: iCloudData = AppDelegate.sharedDelegate().cloudData {
                if cloudData.hasiCloudAccount {
                    cell.profileAccountLabel.text = "icloud_account".localized
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
        
        guard let type = SectionType(rawValue: indexPath.row) else { return }
        
        switch type {
        case .profile:
            self.navigationController?.pushViewController(UIViewController(), animated: true)
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
        }
    }

}
