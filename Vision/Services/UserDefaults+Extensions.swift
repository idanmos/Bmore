//
//  UserDefaults+Extensions.swift
//  B-more
//
//  Created by Idan Moshe on 08/01/2021.
//

import UIKit

class Preferences {
    
    static let shared = Preferences()
    
    var firstTimeRun: Bool {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "firstTimeRun")
        }
        get {
            UserDefaults.standard.bool(forKey: "firstTimeRun")
        }
    }
    
    func willShowHelp(for className: String) -> Bool {
        return !UserDefaults.standard.bool(forKey: "\(className)_help")
    }
    
    func setShowHelp(for className: String) {
        UserDefaults.standard.setValue(true, forKey: "\(className)_help")
    }
    
}
