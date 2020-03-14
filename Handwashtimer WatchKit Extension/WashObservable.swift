//
//  WashObservable.swift
//  Handwashtimer WatchKit Extension
//
//  Created by Bror Brurberg on 10/03/2020.
//  Copyright © 2020 Bror Brurberg. All rights reserved.
//

import Foundation
import SwiftUI
import UserNotifications

let washObservableSingleton: WashObservable = WashObservable()

class WashObservable: ObservableObject {
    @Published var timeLeft: Int = 20
    @Published var startTime: Date
    @Published var endTime: Date
    @Published var interval: Int
    @Published var permissions: Bool = false
    private let center = UNUserNotificationCenter.current()
    
    init() {
        let start = UserDefaults.standard.integer(forKey: "startHour") == 0 ? 8 : UserDefaults.standard.integer(forKey: "startHour")
        let end = UserDefaults.standard.integer(forKey: "endHour") == 0 ? 21 : UserDefaults.standard.integer(forKey: "endHour")
        self.startTime = Calendar.current.date(bySetting: .hour, value: start, of: Date())!
        self.endTime = Calendar.current.date(bySetting: .hour, value: end, of: Date())!
        self.interval = UserDefaults.standard.integer(forKey: "interval") == 0 ? 2 : UserDefaults.standard.integer(forKey: "interval")
        setInterval(
            start: self.startTime,
            end: self.endTime,
            interval: self.interval
        )
    }
    
    func createWashNotification(time: Int) {
        center.requestAuthorization(options: [.alert, .sound]) { (granted, err) in
            if granted {
                self.permissions = true
            }
        }
        let content = UNMutableNotificationContent()
        content.title = "Great!"
        content.body = "You have washed your hands for a sufficient amount of time! 💦🙌"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time), repeats: false)
        
        let request = UNNotificationRequest(identifier: "washingHandsCountdown", content: content, trigger: trigger)
        center.add(request)
    }
    
    func setInterval(start: Date, end: Date, interval: Int) {
        saveSettings(start: start, end: end, interval: interval)
        center.requestAuthorization(options: [.alert, .sound]) { (granted, err) in
            if granted {
                self.permissions = true
            }
        }
        removeAllNotifications()
        guard let startHour = Calendar.current.dateComponents([.hour], from: start).hour else {return}
        guard let endHour = Calendar.current.dateComponents([.hour], from: end).hour else {return}
        for hour in startHour...endHour {
            if hour % interval == 0 {
                createNotification(hour)
            }
        }
        self.startTime = start
        self.endTime = end
        self.interval = interval
    }
    
    private func createNotification(_ hour: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Wash your hands"
        content.body = "Time to wash your filthy hands 💦🙌"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    private func removeAllNotifications() {
        center.removeAllPendingNotificationRequests()
    }
    
    private func saveSettings(start: Date, end: Date, interval: Int) {
        let startHour = Calendar.current.dateComponents([.hour], from: start).hour!
        let endHour = Calendar.current.dateComponents([.hour], from: end).hour!
        UserDefaults.standard.set(startHour, forKey: "startHour")
        UserDefaults.standard.set(endHour, forKey: "endHour")
        UserDefaults.standard.set(interval, forKey: "interval")
    }
}
