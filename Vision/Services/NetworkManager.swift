//
//  NetworkManager.swift
//  Bmore
//
//  Created by Idan Moshe on 22/01/2021.
//

import UIKit
import Alamofire
import SafariServices

class NetworkManager: NSObject, SFSafariViewControllerDelegate {
    
    static let shared = NetworkManager()
        
    func fetchData(url: URLConvertible) {
        let destination = DownloadRequest.suggestedDownloadDestination()
                
        AF.download(url, to: destination).response { (response) in
            debugPrint(response)
            debugPrint(response.error)
            debugPrint(response.fileURL)
        }
    }
    
    func fetch() {
        let url = URL(string: "https://data.gov.il/dataset/d361f6a6-898c-4e4d-8a80-abc4e8643bf6/resource/a0f56034-88db-4132-8803-854bcdb01ca1/download/metavchim_list_-metavchim.csv")!
//        var request = URLRequest(url: url)
//        request.setValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        // request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
//        request.httpMethod = "GET"
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error ?? "Unknown error")                                 // handle network error
//                return
//            }
//
//
//            if let content = String(data: data, encoding: .utf8) {
//                debugPrint(content)
//            }
            
            // parse response; for example, if JSON, define `Decodable` struct `ResponseObject` and then do:
            //
            // do {
            //     let responseObject = try JSONDecoder().decode(ResponseObject.self, from: data)
            //     print(responseObject)
            // } catch let parseError {
            //     print(parseError)
            //     print(String(data: data, encoding: .utf8))   // often the `data` contains informative description of the nature of the error, so let's look at that, too
            // }
//        }
//        task.resume()
        
        ////
        
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            let rootVireController = UIApplication.shared.windows.first!.rootViewController!
            debugPrint("rootVireController", rootVireController)
            rootVireController.present(safariViewController, animated: true, completion: nil)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        debugPrint(#function)
    }
    
    func safariViewControllerWillOpenInBrowser(_ controller: SFSafariViewController) {
        debugPrint(#function)
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        debugPrint(#function, "didLoadSuccessfully", didLoadSuccessfully)
    }
    
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        debugPrint(#function, "initialLoadDidRedirectTo URL", URL)
    }
    
}
