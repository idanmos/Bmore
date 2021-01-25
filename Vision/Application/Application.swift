//
//  Application.swift
//  Vision
//
//  Created by Idan Moshe on 08/12/2020.
//

import UIKit

class Application {
    
    static let shared = Application()
    
    private let persistentStorage: PersistentStorage
    
    init() {
        self.persistentStorage = PersistentStorage.shared
    }
    
    func configureMainInterface(in window: UIWindow) {
        window.backgroundColor = .white
        
        let tabBarController = UITabBarController()
        
        let propertiesViewController = UIStoryboard(name: "Properties", bundle: nil).instantiateInitialViewController()!
        propertiesViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("properties", comment: ""), image: UIImage(systemName: "building.2"), tag: 0)
        
        let contactsViewController = UIStoryboard(name: "Leads", bundle: nil).instantiateInitialViewController()!
        contactsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("leads", comment: ""), image: UIImage(systemName: "person.2"), tag: 0)
                
        let timeTrackingViewController = UIStoryboard(name: "TimeTracking", bundle: nil).instantiateInitialViewController()!
        timeTrackingViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("time_tracking", comment: ""), image: UIImage(systemName: "clock"), tag: 0)
        
        let targetViewController = UIStoryboard(name: "Targets", bundle: nil).instantiateInitialViewController()!
        targetViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("targets", comment: ""), image: UIImage(systemName: "target"), tag: 0)
        
        let moreViewController = UIStoryboard(name: "More", bundle: nil).instantiateInitialViewController()!
        moreViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("more", comment: ""), image: UIImage(systemName: "ellipsis"), tag: 0)
        
        let viewControllers: [UIViewController] = [propertiesViewController,
                                                   contactsViewController,
                                                   timeTrackingViewController,
                                                   targetViewController,
                                                   moreViewController]
        
        tabBarController.setViewControllers(viewControllers, animated: true)
                
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    enum AppUrl {
        enum Government {
            static let israelCityList = URL(string: "https://data.gov.il/api/3/action/datastore_search?resource_id=5c78e9fa-c2e2-4771-93ff-7f400a12f7ba")!
            static let israeliStreetList = URL(string: "https://data.gov.il/api/3/action/datastore_search?resource_id=9ad3862c-8391-4b2f-84a4-2d4c68625f4b")!
            static let israeliRealEstateAgentsList = URL(string: "https://data.gov.il/api/3/action/datastore_search?resource_id=a0f56034-88db-4132-8803-854bcdb01ca1")!
        }
    }
    
    enum SpecialCharacters {
        static let israeliShekelSign: String = "₪"
        static let checkmark: String = "✔︎"
        
        static var localizedCurrencySign: String {
            return Locale.current.currencySymbol ?? ""
        }
        
        static let largeMiddlePoint: String = "•"
    }
    
    enum AssetType: Int, CaseIterable {
        case apartment
        case apartmentWithGarden
        case privateOrCottage
        case roofOrPenthouse
        case court
        case duplex
        case unit
        
        func localized() -> String {
            if Application.isHebrew() {
                return self.hebrewLocalized()
            } else {
                return self.englishLocalized()
            }
        }
        
        private func hebrewLocalized() -> String {
            switch self {
            case .apartment: return "בית"
            case .apartmentWithGarden: return "גינה"
            case .privateOrCottage: return "פרטי/קוטג׳"
            case .roofOrPenthouse: return "גג/פנטהאוז"
            case .court: return "מגרש"
            case .duplex: return "דופלקס"
            case .unit: return "יחידה"
            }
        }
        
        private func englishLocalized() -> String {
            switch self {
            case .apartment: return "Apartment"
            case .apartmentWithGarden: return "Apartment with garden"
            case .privateOrCottage: return "Private/Cottage"
            case .roofOrPenthouse: return "Roof/Penthouse"
            case .court: return "Land"
            case .duplex: return "Duplex"
            case .unit: return "Unit"
            }
        }
        
        static func valuesLocalized() -> [String] {
            var obj: [String] = []
            for value: Application.AssetType in Application.AssetType.allCases {
                if Application.isHebrew() {
                    obj.append(value.hebrewLocalized())
                } else {
                    obj.append(value.englishLocalized())
                }
            }
            return obj
        }
    }
    
    enum PropertySaveKeys: String, CaseIterable {
        case uuid
        case type
        case enterDate
        case dateIsNow
        case address
        case size
        case rooms
        case balcony
        case parking
        case floorNumber
        case totalFloorsNumber
        case extraInfo
        case price
        case latitude
        case longitude
        case sellOrRent
        case contactIdentifier
        case isExclusivity
        case exclusivityEndDate
    }
    
    enum PropertyExclusivity: Int {
        case oneMonth = 30
        case threeMonths = 90
        case sixMonths = 180
        
        func color() -> UIColor {
            switch self {
            case .oneMonth: return .systemRed
            case .threeMonths: return .systemOrange
            case .sixMonths: return .systemGreen
            }
        }
    }
    
    enum TransactionStatus: Int16 {
        case pending = 0
        case closed = 1
        case canceled = 2
    }

    enum TransactionType: Int16 {
        case none = 0
        case expense = 1
        case revenue = 2
    }
    
    enum TransactionCommisionType: Int16 {
        case percent = 0
        case amount = 1
    }
    
    enum TransactionLocationType: Int16 {
        case property = 0
        case address = 1
    }

    enum TaskStatus: Int16 {
        case pending, inProgress, closed, canceled
        
        var localized: String {
            switch self {
            case .pending: return "pending".localized
            case .inProgress: return "in_progress".localized
            case .closed: return "closed".localized
            case .canceled: return "canceled".localized
            }
        }
    }

    enum TaskType: Int16 {
        case call, email, meeting, other
        
        var localized: String {
            switch self {
            case .call: return "call".localized
            case .email: return "email".localized
            case .meeting: return "meeting".localized
            case .other: return "other".localized
            }
        }
    }
    
    static var priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "he-IL")
        return formatter
    }()
    
    class func isHebrew() -> Bool {
        return NSLocalizedString("language", comment: "") == "hebrew"
    }
    
    enum Images {
        static let calendar = UIImage(systemName: "calendar")!
    }
        
}

extension NSNotification.Name {
    
    static let balanceDateChange = Notification.Name(rawValue: "balanceDateChange")
    
}

extension Application {
    
    var applicationIconBadgeNumber: Int {
        get {
            return UIApplication.shared.applicationIconBadgeNumber
        }
        set {
            UIApplication.shared.applicationIconBadgeNumber = newValue
        }
    }
    
}

//extension Application {
//    
//    lazy var <#property name#>: <#type name#> = {
//        var queryItems: [URLQueryItem] = []
//        queryItems.append(URLQueryItem(name: "resource_id", value: "a0f56034-88db-4132-8803-854bcdb01ca1"))
//        // queryItems.append(URLQueryItem(name: "q", value: searchName))
//        
//        let components = URLComponents(
//            scheme: "https",
//            host: "data.gov.il",
//            path: "api/3/action/datastore_search",
//            queryItems: queryItems
//        )
//        
//        return components.url
//    }()
//    
//}
