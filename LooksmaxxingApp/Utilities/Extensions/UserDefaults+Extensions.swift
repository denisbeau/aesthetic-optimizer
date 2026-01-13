//
//  UserDefaults+Extensions.swift
//  LooksmaxxingApp
//
//  User defaults for device ID, onboarding state, and preferences
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let deviceID = "deviceID"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let lastScanDate = "lastScanDate"
        static let notificationTime = "notificationTime"
        static let isProUser = "isProUser"
        static let hasRequestedNotifications = "hasRequestedNotifications"
        static let streakFreezeCount = "streakFreezeCount"
    }
    
    // MARK: - Device ID (generated on first access)
    var deviceID: String {
        get {
            if let id = string(forKey: Keys.deviceID) {
                return id
            }
            let newID = UUID().uuidString
            set(newID, forKey: Keys.deviceID)
            return newID
        }
    }
    
    // MARK: - Onboarding State
    var hasCompletedOnboarding: Bool {
        get { bool(forKey: Keys.hasCompletedOnboarding) }
        set { set(newValue, forKey: Keys.hasCompletedOnboarding) }
    }
    
    // MARK: - Last Scan Date (for free tier 1/week limit)
    var lastScanDate: Date? {
        get { object(forKey: Keys.lastScanDate) as? Date }
        set { set(newValue, forKey: Keys.lastScanDate) }
    }
    
    // MARK: - Notification Time Preference
    var notificationTime: Date {
        get {
            if let time = object(forKey: Keys.notificationTime) as? Date {
                return time
            }
            // Default: 8 AM
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: Date())
            components.hour = 8
            components.minute = 0
            return calendar.date(from: components) ?? Date()
        }
        set { set(newValue, forKey: Keys.notificationTime) }
    }
    
    // MARK: - Pro User Status (cached locally)
    var isProUser: Bool {
        get { bool(forKey: Keys.isProUser) }
        set { set(newValue, forKey: Keys.isProUser) }
    }
    
    // MARK: - Notification Permission Requested
    var hasRequestedNotifications: Bool {
        get { bool(forKey: Keys.hasRequestedNotifications) }
        set { set(newValue, forKey: Keys.hasRequestedNotifications) }
    }
    
    // MARK: - Streak Freeze Count
    var streakFreezeCount: Int {
        get { integer(forKey: Keys.streakFreezeCount) }
        set { set(newValue, forKey: Keys.streakFreezeCount) }
    }
    
    // MARK: - Scan Limit Check
    /// Returns true if user can scan (free users: 1 scan per week)
    func canScanToday(isProUser: Bool) -> Bool {
        if isProUser { return true }
        
        guard let lastScan = lastScanDate else { return true }
        let daysSinceLastScan = Calendar.current.dateComponents([.day], from: lastScan, to: Date()).day ?? 0
        return daysSinceLastScan >= 7
    }
    
    /// Returns days until next free scan
    func daysUntilNextFreeScan() -> Int {
        guard let lastScan = lastScanDate else { return 0 }
        let daysSinceLastScan = Calendar.current.dateComponents([.day], from: lastScan, to: Date()).day ?? 0
        return max(0, 7 - daysSinceLastScan)
    }
}
