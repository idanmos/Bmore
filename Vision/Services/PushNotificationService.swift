//
//  PushNotificationService.swift
//  B-more
//
//  Created by Idan Moshe on 15/01/2021.
//

import UIKit
import UserNotifications

class PushNotificationService {
    
    static let shared = PushNotificationService()
    
    init() {
        self.requestPermissions()
    }
    
    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: .alert) { (accessGranted: Bool, error: Error?) in
            if let error: Error = error {
                let alert = AlertViewModel.generalError(error)
                AlertViewModel.showAlert(alert)
            }
        }
    }
    
    /* func presentNotification(after delay: TimeInterval,
                                    identifier: String = NSUUID().uuidString,
                                    title: String?,
                                    body: String?,
                                    sound: UNNotificationSound?,
                                    badge: NSNumber?,
                                    completionHandler: @escaping (Error?) -> Void) {
        let content = UNMutableNotificationContent()
        content.sound = sound
        content.badge = badge
        
        if let _ = title {
            content.title = title!
        }
        if let _ = body {
            content.body = body!
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completionHandler)
    } */
    
    func schedule(_ taskConfiguration: TaskConfiguration) {
        guard taskConfiguration.isPushEnabled else { return }
        guard let date: Date = taskConfiguration.date else { return }
        
        let content = UNMutableNotificationContent()

        content.sound = .default
        content.badge = NSNumber(integerLiteral: UIApplication.shared.applicationIconBadgeNumber + 1)
        content.title = taskConfiguration.title ?? ""
        content.body = taskConfiguration.comments ?? ""
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: taskConfiguration.taskId, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func remove(_ taskId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [taskId])
    }
    
}
