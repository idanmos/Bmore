//
//  AppDelegate.swift
//  Vision
//
//  Created by Idan Moshe on 05/12/2020.
//

import UIKit
import FBSDKCoreKit

class CityDetails: Codable {
    var code: Int = 0
    var name: String = ""
}

class StreetDetails: Codable {
    var code: Int = 0
    var cityCode: Int = 0
    var name: String = ""
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {    
    
    var window: UIWindow?
    
    var cities: [CityDetails] = []
    
    class func sharedDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    private func getTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        
        let propertiesViewController = UIStoryboard(name: "Properties", bundle: nil).instantiateInitialViewController()!
        propertiesViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("properties", comment: ""), image: UIImage(systemName: "building.2"), tag: 0)
        
        let contactsViewController = UIStoryboard(name: "Contacts", bundle: nil).instantiateInitialViewController()!
        contactsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("leads", comment: ""), image: UIImage(systemName: "person.2"), tag: 0)
        
        let advancedViewController = UIStoryboard(name: "Advanced", bundle: nil).instantiateInitialViewController()!
        advancedViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("advanced", comment: ""), image: UIImage(systemName: "chart.bar"), tag: 0)
        
        let timeTrackingViewController = UIStoryboard(name: "TimeTracking", bundle: nil).instantiateInitialViewController()!
        timeTrackingViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("time_tracking", comment: ""), image: UIImage(systemName: "clock"), tag: 0)
        
        let targetViewController = UIStoryboard(name: "Targets", bundle: nil).instantiateInitialViewController()!
        targetViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("targets", comment: ""), image: UIImage(systemName: "target"), tag: 0)
        
        let viewControllers: [UIViewController] = [propertiesViewController,
                                                   contactsViewController,
                                                   timeTrackingViewController,
                                                   advancedViewController,
                                                   targetViewController]
        
        tabBarController.setViewControllers(viewControllers, animated: true)
                
        return tabBarController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Application.shared.applicationIconBadgeNumber = 0
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
                
        // self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        self.window?.rootViewController = self.getTabBarController()
        self.window?.makeKeyAndVisible()
        
//        self.fetchCities(url: Application.AppUrl.Government.israelCityList) {
//            debugPrint("Finished")
//        }
        
//        self.fetchCities(url: Application.AppUrl.Government.israeliStreetList) {
//            debugPrint("Finished")
//        }
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func fetchCities(url: URL, completionHandler: (() -> Void)? = nil) {
        debugPrint(#function, url)
        
        self.fetchData(url: url) { (data: [String : Any]?, error: Error?) in
            guard let innerJson = data else { return }
            
            innerJson.forEach { (obj1: (key: String, value: Any)) in
                if obj1.key == "success", let success = obj1.value as? Bool {
                    debugPrint("Success: \(success)")
                }

                if obj1.key == "result" {
                    if let result = obj1.value as? [String: Any] {
                        result.forEach { (obj2: (key: String, value: Any)) in
                            
                            guard result.keys.contains("records") else { return }
                            guard let res = result["records"] as? [[String: Any]] else { return }
                            guard res.count > 0 else {
                                debugPrint("End")
                                return
                            }
                            
                            if obj2.key == "_links" {
                                if let links = obj2.value as? [String: Any] {
                                    if let next = links["next"] {
                                        if let completeURL = URL(string: "https://data.gov.il\(next)") {
                                            self.fetchCities(url: completeURL)
                                        }
                                    }
                                }
                            }

                            if obj2.key == "records" {
                                /* if let records = obj2.value as? [[String: Any]] {
                                    records.forEach { (record: [String : Any]) in
                                        let city = CityDetails()
                                        
                                        if var cityName = record["שם_ישוב"] as? String {
                                            cityName = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
                                            debugPrint(cityName)
                                            city.name = cityName
                                        }
                                        if let cityCode = record["סמל_ישוב"] as? Int {
                                            debugPrint(cityCode)
                                            city.code = cityCode
                                        }
                                        
                                        self.cities.append(city)
                                    }
                                } */
                                
                                if let records = obj2.value as? [[String: Any]] {
                                    records.forEach { (record: [String : Any]) in
                                        if var cityName = record["שם_ישוב"] as? String {
                                            cityName = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
                                            debugPrint(cityName)
                                        }
                                        if var streetName = record["שם_רחוב"] as? String {
                                            streetName = streetName.trimmingCharacters(in: .whitespacesAndNewlines)
                                            debugPrint(streetName)
                                        }
                                        if let cityCode = record["סמל_ישוב"] as? Int {
                                            debugPrint(cityCode)
                                        }
                                        if let streetCode = record["סמל_רחוב"] as? Int {
                                            debugPrint(streetCode)
                                        }
                                        
                                        debugPrint("**********")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchData(url: URL, completion: @escaping ([String:Any]?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
                    completion(array, nil)
                }
            } catch {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
}

