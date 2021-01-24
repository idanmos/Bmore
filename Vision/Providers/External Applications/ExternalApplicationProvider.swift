//
//  ExternalApplicationProvider.swift
//  Bmore
//
//  Created by Idan Moshe on 23/01/2021.
//

import UIKit

protocol ExternalApplicationProviderDelegate: class {
    var components: URLComponents { get }
    func canOpen() -> Bool
    func open()
}

class ExternalApplicationProvider: ExternalApplicationProviderDelegate {
    
    var components: URLComponents {
        return URLComponents()
    }
    
    func canOpen() -> Bool {
        if let url: URL = self.components.url {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    func open() {
        if self.canOpen() {
            if let url: URL = self.components.url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}

class WhatsappApplicationProvider: ExternalApplicationProvider {
    
    var phoneNumber: String = ""
    
    override var components: URLComponents {
        return URLComponents(scheme: "whatsapp", host: nil, path: self.phoneNumber, queryItems: [])
    }
    
}
