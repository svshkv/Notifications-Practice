//
//  Notifications.swift
//  Notification
//
//  Created by Саша Руцман on 23/09/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {

    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAuth() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: ", granted)
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Settings: ", settings)
        }
    }
    
    func scheduleNotification(notificationType: String) {
        let content = UNMutableNotificationContent()
        let userAction = "User Action"
        content.title = notificationType
        content.body = "This is example how to create : \(notificationType)"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userAction
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let identifier = "local notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error: ", error.localizedDescription)
            }
        }
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: userAction, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        notificationCenter.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    } // получение уведомлений даже тогда, когда приложение находится на 1 плане
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "local notification" {
            print("response.notification.request.identifier == local notification ")
        } //  обработка полученного уведомления
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("dismiss action")
        case UNNotificationDefaultActionIdentifier:
            print("default action")
        case "Snooze":
            print("Snooze action")
            scheduleNotification(notificationType: "Reminder")
        case "Delete":
            print("Delete")
            
        default:
            print("unknown action")
        }
        completionHandler()
    }
    
}
