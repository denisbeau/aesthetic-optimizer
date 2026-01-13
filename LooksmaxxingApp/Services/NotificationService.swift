//
//  NotificationService.swift
//  LooksmaxxingApp
//
//  Handles local push notifications for re-engagement
//  - Daily routine reminders
//  - Streak at risk warnings
//

import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    
    private let center = UNUserNotificationCenter.current()
    
    // MARK: - Notification Identifiers
    
    private enum NotificationID {
        static let dailyReminder = "daily_reminder"
        static let streakAtRisk = "streak_at_risk"
        static let streakLost = "streak_lost"
    }
    
    private init() {}
    
    // MARK: - Request Permission
    
    func requestPermission(completion: @escaping (Bool) -> Void = { _ in }) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                UserDefaults.standard.hasRequestedNotifications = true
                completion(granted)
            }
        }
    }
    
    // MARK: - Schedule Daily Reminder
    
    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Routine Reminder"
        
        let streak = CoreDataManager.shared.getCurrentStreak()
        if streak > 0 {
            content.body = "Time for your daily routine! Maintain your \(streak) day streak 🔥"
        } else {
            content.body = "Start your self-improvement journey! Complete your daily routine."
        }
        
        content.sound = .default
        content.categoryIdentifier = "DAILY_ROUTINE"
        
        // Schedule for user's preferred time
        let notificationTime = UserDefaults.standard.notificationTime
        let calendar = Calendar.current
        var components = calendar.dateComponents([.hour, .minute], from: notificationTime)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(
            identifier: NotificationID.dailyReminder,
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("Daily reminder scheduling error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Schedule Streak At Risk Warning
    
    func scheduleStreakAtRisk() {
        // Cancel existing streak at risk notification
        center.removePendingNotificationRequests(withIdentifiers: [NotificationID.streakAtRisk])
        
        let streak = CoreDataManager.shared.getCurrentStreak()
        guard streak > 0 else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Streak at Risk! 🔥"
        content.body = "Your \(streak) day streak is at risk! Complete today's routine in the next 4 hours."
        content.sound = .default
        content.categoryIdentifier = "STREAK_RISK"
        
        // Schedule for 8 PM
        var components = DateComponents()
        components.hour = 20
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(
            identifier: NotificationID.streakAtRisk,
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("Streak at risk scheduling error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Cancel Streak At Risk (when user completes routine)
    
    func cancelStreakAtRisk() {
        center.removePendingNotificationRequests(withIdentifiers: [NotificationID.streakAtRisk])
    }
    
    // MARK: - Schedule Streak Lost Notification
    
    func scheduleStreakLost(previousStreak: Int) {
        guard previousStreak > 0 else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Streak Lost 😢"
        content.body = "You lost your \(previousStreak) day streak. Start fresh and build it back up!"
        content.sound = .default
        
        // Immediate notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: NotificationID.streakLost,
            content: content,
            trigger: trigger
        )
        
        center.add(request)
    }
    
    // MARK: - Update Notification Time
    
    func updateNotificationTime(_ time: Date) {
        UserDefaults.standard.notificationTime = time
        
        // Reschedule with new time
        cancelAllNotifications()
        scheduleDailyReminder()
        scheduleStreakAtRisk()
    }
    
    // MARK: - Cancel All Notifications
    
    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
    }
    
    // MARK: - Check Notification Status
    
    func checkNotificationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
}

// MARK: - Notification Category Actions (for future expansion)

extension NotificationService {
    func setupNotificationCategories() {
        // Open app action
        let openAction = UNNotificationAction(
            identifier: "OPEN_APP",
            title: "Open App",
            options: .foreground
        )
        
        // Daily routine category
        let dailyCategory = UNNotificationCategory(
            identifier: "DAILY_ROUTINE",
            actions: [openAction],
            intentIdentifiers: [],
            options: []
        )
        
        // Streak risk category
        let riskCategory = UNNotificationCategory(
            identifier: "STREAK_RISK",
            actions: [openAction],
            intentIdentifiers: [],
            options: []
        )
        
        center.setNotificationCategories([dailyCategory, riskCategory])
    }
}
