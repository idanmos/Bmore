//
//  AlertViewModel.swift
//  B-more
//
//  Created by Idan Moshe on 15/01/2021.
//

import UIKit

struct AlertViewModel {
    
    var title: String
    var description: String
    var button: String
    
    static var rootViewController: UIViewController {
        return (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!
    }
    
    static func showAlert(_ alert: AlertViewModel, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: alert.title, message: alert.description, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: alert.button, style: .default, handler: handler))
        
        DispatchQueue.main.async {
            AlertViewModel.rootViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func generalError(_ error: Error) -> AlertViewModel {
        return AlertViewModel(title: "error".localized, description: error.localizedDescription, button: "ok".localized)
    }
    
    static func customError(_ description: String) -> AlertViewModel {
        return AlertViewModel(title: "error".localized, description: description, button: "ok".localized)
    }
    
    static var pushPermissionsNotGranted: AlertViewModel {
        return AlertViewModel(title: "error".localized, description: "no_push_permissions".localized, button: "ok".localized)
    }
    
    static var needPushAndDate: AlertViewModel {
        return AlertViewModel(title: "error".localized, description: "need_push_and_date".localized, button: "ok".localized)
    }
    
}
