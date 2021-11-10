//
//  LocalNotification.swift
//  HabitTrackingApp
//
//  Created by Muhammad Ali on 10/11/2021.
//

import Foundation
import UserNotifications
class LocalNotification{
    let center = UNUserNotificationCenter.current()
    private init(){
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Permission granted")
            } else {
                print("Permission denied\n")
            }
        }
    }
    static let shared = LocalNotification()
    
    func cancelNotifications(){
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    }
    
    func sendNotifications(){
        //let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "My title"
        content.body = "Lots of text"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "yourIdentifier"
        content.userInfo = ["example": "information"] // You can retrieve this when displaying notification

        // Setup trigger time
        if let scheduleDate = UserState.gettimeReminder(){
            var calendar = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: scheduleDate)
            calendar.timeZone = TimeZone.current
            let trigger = UNCalendarNotificationTrigger(dateMatching: calendar, repeats: true)

            // Create request
            let uniqueID = UUID().uuidString // Keep a record of this if necessary
            let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
            center.add(request) { (error) in
                if error != nil{
                    print(error?.localizedDescription)
                }else{
                    print("Notification Tigger")
                }
            }
        }
        else{
            return
        }
    }
}
