//
//  ApplicationFeature.swift
//  Bmore
//
//  Created by Idan Moshe on 19/01/2021.
//

import UIKit

enum ApplicationFeature {
    case properties
    case leads
    case timeTracking
    case advanced(AdvancedFeature)
    
    enum AdvancedFeature {
        case balance
        case meetings
        case transactions
        case tasks
    }
    
    case targets
    
    func isEnabled() -> Bool {
        switch self {
        case .properties: return true
        case .leads: return true
        case .timeTracking: return true
        case .advanced(_): return true
        case .targets: return true
        }
    }
    
    func disableFeature() {
        //
    }
}
