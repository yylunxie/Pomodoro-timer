//
//  pomodoroModel.swift
//  pomodoro
//
//  Created by 謝宇倫 on 2024/4/10.
//

import SwiftUI
import UserNotifications

class PomodoroModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var focusTime: Int?
    @Published var date = Date()
    @Published var goal = ""
    @Published var timeRemaining: TimeInterval = 60 * 25
//    @Published var setTime: Int = 0
    @Published var timer: Timer?
    @Published var isRunning: Bool = false
    @Published var alert = false
    
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
                self.createNotification()
            }
        }
    }
    
    func stopTimer() {
        self.isRunning = false
        self.timer?.invalidate()
        self.timeRemaining = 60 * 25
    }
    
    func pauseTimer() {
        // To do
    }
    func updateTimeRemaining(setTime: Int) {
        if !self.isRunning {
            self.timeRemaining = TimeInterval(setTime * 60)
        }
    }
    
    func createNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Message"
        content.subtitle = "Notification From Pomodoro Timer"
        content.categoryIdentifier = "ACTIONS"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "Pomodoro Timer", content: content, trigger: trigger)
        
        let close = UNNotificationAction(identifier: "CLOSE", title: "Close", options: .destructive)
        let reply = UNNotificationAction(identifier: "REPLY", title: "Reply", options: .foreground)
        let category = UNNotificationCategory(identifier: "ACTIONS", actions: [close, reply], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "REPLY" {
            print("reply the comment or do anything...")
            self.alert.toggle()
        }
            completionHandler()
    }
}
