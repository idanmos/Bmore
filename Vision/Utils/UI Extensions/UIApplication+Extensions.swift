//
//  UIApplication+Extensions.swift
//  B-more
//
//  Created by Idan Moshe on 19/01/2021.
//

import UIKit

extension UIApplication {

    func openSystemSettings(completionHandler completion: ((Bool) -> Void)? = nil) {
        self.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: completion)
    }
    
    func topMostController() -> UIViewController? {
        let keyWindow: UIWindow? = self.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
}
