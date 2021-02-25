//
//  AppDelegate.swift
//  Vision
//
//  Created by Idan Moshe on 05/12/2020.
//

import UIKit

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
    
    lazy var coreDataStack: CoreDataStack = { return CoreDataStack() }()
    
//    var cities: [CityDetails] = []
    
    var cloudData: iCloudData?
    
    class func sharedDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {        
        Application.shared.applicationIconBadgeNumber = 0
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        Application.shared.configureMainInterface(in: window)
        self.window = window
        
        iCloudService.fetchData { (data: iCloudData?, error: Error?) in
            if let error = error {
                debugPrint("iCloudService.fetchData", error)
            }
            if let data = data {
                self.cloudData = data
                debugPrint("iCloudService.fetchData", data)
            }
        }
        
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
                                completionHandler?()
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
                                if let records = obj2.value as? [[String: Any]] {
                                    // Cities
                                    /* records.forEach { (record: [String : Any]) in
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
                                    } */
                                    
                                    // Streets
                                    /* records.forEach { (record: [String : Any]) in
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
                                    } */
                                                                        
                                    records.forEach { (record: [String : Any]) in
                                        if var city = record["עיר מגורים"] as? String {
                                            city = city.trimmingCharacters(in: .whitespacesAndNewlines)
                                            debugPrint(city)
                                        }
                                        if var name = record["שם המתווך"] as? String {
                                            name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                                            debugPrint(name)
                                        }
                                        if let license = record["מס רשיון"] as? Int {
                                            debugPrint(license)
                                        }
                                        if let _id = record["_id"] as? Int {
                                            debugPrint(_id)
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
    
    func realEstateAgentsInIsrael(searchName: String) -> URL? {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "resource_id", value: "a0f56034-88db-4132-8803-854bcdb01ca1"))
        // queryItems.append(URLQueryItem(name: "q", value: searchName))
        
        let components = URLComponents(
            scheme: "https",
            host: "data.gov.il",
            path: "api/3/action/datastore_search",
            queryItems: queryItems
        )
        
        return components.url
    }
    
    func fetchRealEstateAgentsInIsrael() {
        // let url = URL(string: "https://data.gov.il/dataset/d361f6a6-898c-4e4d-8a80-abc4e8643bf6/resource/a0f56034-88db-4132-8803-854bcdb01ca1/download/metavchim_list_-metavchim.csv")!
        
        let aaa = URL(string: "https://data.gov.il/api/3/action/datastore_search?resource_id=a0f56034-88db-4132-8803-854bcdb01ca1") // self.realEstateAgentsInIsrael(searchName: "idan")
        guard let url = aaa else { return }
        debugPrint(url)
//        let downloadTask = URLSession.shared.downloadTask(with: url) { (downloadedURL: URL?, response: URLResponse?, error: Error?) in
//            guard error == nil else {
//                debugPrint(#file, #function, error)
//                return
//            }
//            guard let fileURL: URL = downloadedURL else { return }
//            debugPrint("downloadedURL", downloadedURL)
//
//            do {
//                    let documentsURL = try
//                        FileManager.default.url(for: .documentDirectory,
//                                                in: .userDomainMask,
//                                                appropriateFor: nil,
//                                                create: false)
//                    let savedURL = documentsURL.appendingPathComponent(fileURL.lastPathComponent)
//                    try FileManager.default.moveItem(at: fileURL, to: savedURL)
//                } catch {
//                    print ("file error: \(error)")
//                }
//        }
//        downloadTask.resume()
        
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                debugPrint(#file, #function, error)
                return
            }
            guard let data: Data = data else { return }
            guard let content = String(data: data, encoding: .utf8) else { return }

            var rows: [String] = content.components(separatedBy: "\n")
            rows.removeFirst()

            for row: String in rows {
                let columns: [String] = row.components(separatedBy: ",")
                if columns.count == 3 {

                }
            }
        }
        task.resume()
    }
    
}

struct RealEstateAgentData {
    var licenseNumber: String
    var name: String
    var city: String
}

extension URLComponents {
    
    init(scheme: String?, host: String?, path: String, queryItems: [URLQueryItem]?) {
        self.init()
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queryItems = queryItems
    }
    
}
