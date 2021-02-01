//
//  MainAppContext.swift
//  Bmore
//
//  Created by Idan Moshe on 01/02/2021.
//

import UIKit

extension Notification.Name {
    static let reportedApplicationStateDidChange = Notification.Name("ReportedApplicationStateDidChangeNotification")
}

class MainAppContext: AppContext {
    
    var _reportedApplicationState: UIApplication.State = .inactive {
        didSet {
            NotificationCenter.default.post(
                name: .reportedApplicationStateDidChange,
                object: nil,
                userInfo: nil
            )
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.applicationWillEnterForeground(_:)),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.applicationWillEnterForeground(_:)),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.applicationWillResignActive(_:)),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.applicationDidBecomeActive(_:)),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.applicationWillTerminate(_:)),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
    }
    
    deinit {
        debugPrint("Deallocating \(self)")
        NotificationCenter.default.removeObserver(self)
    }
    
    var reportedApplicationState: UIApplication.State {
        return _reportedApplicationState
    }
    
    @objc private func applicationDidEnterBackground(_ notification: Notification) {
        _reportedApplicationState = .background
    }
    
    @objc private func applicationWillEnterForeground(_ notification: Notification) {
        _reportedApplicationState = .inactive
    }
    
    @objc private func applicationWillResignActive(_ notification: Notification) {
        _reportedApplicationState = .inactive
    }
    
    @objc private func applicationDidBecomeActive(_ notification: Notification) {
        _reportedApplicationState = .active
    }
    
    @objc private func applicationWillTerminate(_ notification: Notification) {
        debugPrint(#file, #function)
    }
    
}
