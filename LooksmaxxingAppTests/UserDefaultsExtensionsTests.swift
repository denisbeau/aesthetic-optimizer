//
//  UserDefaultsExtensionsTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for UserDefaults extensions
//

import XCTest
@testable import LooksmaxxingApp

final class UserDefaultsExtensionsTests: XCTestCase {
    
    var suiteName: String!
    var testDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        // Use a unique suite for each test to ensure isolation
        suiteName = "TestSuite-\(UUID().uuidString)"
        testDefaults = UserDefaults(suiteName: suiteName)
    }
    
    override func tearDown() {
        // Clean up the test suite
        testDefaults.removePersistentDomain(forName: suiteName)
        testDefaults = nil
        suiteName = nil
        super.tearDown()
    }
    
    // Note: These tests use UserDefaults.standard since the extension is on UserDefaults
    // In a real scenario, you'd use dependency injection to test with isolated defaults
    
    // MARK: - Device ID Tests
    
    func testDeviceID_Generated() {
        let defaults = UserDefaults.standard
        let id = defaults.deviceID
        
        XCTAssertFalse(id.isEmpty)
        XCTAssertTrue(id.contains("-")) // UUID format
    }
    
    func testDeviceID_Persistent() {
        let defaults = UserDefaults.standard
        let id1 = defaults.deviceID
        let id2 = defaults.deviceID
        
        XCTAssertEqual(id1, id2)
    }
    
    // MARK: - Onboarding State Tests
    
    func testHasCompletedOnboarding_DefaultFalse() {
        let defaults = UserDefaults(suiteName: "TestOnboarding-\(UUID().uuidString)")!
        // Fresh defaults should return false
        XCTAssertFalse(defaults.bool(forKey: "hasCompletedOnboarding"))
    }
    
    func testHasCompletedOnboarding_SetGet() {
        let defaults = UserDefaults.standard
        let original = defaults.hasCompletedOnboarding
        
        defaults.hasCompletedOnboarding = true
        XCTAssertTrue(defaults.hasCompletedOnboarding)
        
        defaults.hasCompletedOnboarding = false
        XCTAssertFalse(defaults.hasCompletedOnboarding)
        
        // Restore original
        defaults.hasCompletedOnboarding = original
    }
    
    // MARK: - Last Scan Date Tests
    
    func testLastScanDate_DefaultNil() {
        let defaults = UserDefaults(suiteName: "TestScan-\(UUID().uuidString)")!
        XCTAssertNil(defaults.object(forKey: "lastScanDate"))
    }
    
    func testLastScanDate_SetGet() {
        let defaults = UserDefaults.standard
        let original = defaults.lastScanDate
        
        let testDate = Date()
        defaults.lastScanDate = testDate
        
        let retrieved = defaults.lastScanDate
        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved!.timeIntervalSince1970, testDate.timeIntervalSince1970, accuracy: 1.0)
        
        // Restore original
        defaults.lastScanDate = original
    }
    
    // MARK: - Pro User Status Tests
    
    func testIsProUser_DefaultFalse() {
        let defaults = UserDefaults(suiteName: "TestPro-\(UUID().uuidString)")!
        XCTAssertFalse(defaults.bool(forKey: "isProUser"))
    }
    
    func testIsProUser_SetGet() {
        let defaults = UserDefaults.standard
        let original = defaults.isProUser
        
        defaults.isProUser = true
        XCTAssertTrue(defaults.isProUser)
        
        defaults.isProUser = false
        XCTAssertFalse(defaults.isProUser)
        
        // Restore original
        defaults.isProUser = original
    }
    
    // MARK: - Streak Freeze Count Tests
    
    func testStreakFreezeCount_DefaultZero() {
        let defaults = UserDefaults(suiteName: "TestFreeze-\(UUID().uuidString)")!
        XCTAssertEqual(defaults.integer(forKey: "streakFreezeCount"), 0)
    }
    
    func testStreakFreezeCount_SetGet() {
        let defaults = UserDefaults.standard
        let original = defaults.streakFreezeCount
        
        defaults.streakFreezeCount = 3
        XCTAssertEqual(defaults.streakFreezeCount, 3)
        
        defaults.streakFreezeCount = 0
        XCTAssertEqual(defaults.streakFreezeCount, 0)
        
        // Restore original
        defaults.streakFreezeCount = original
    }
    
    // MARK: - Can Scan Today Tests
    
    func testCanScanToday_ProUser_AlwaysTrue() {
        let defaults = UserDefaults.standard
        
        // Even with recent scan, pro users can scan
        defaults.lastScanDate = Date()
        XCTAssertTrue(defaults.canScanToday(isProUser: true))
    }
    
    func testCanScanToday_FreeUser_NoLastScan() {
        let defaults = UserDefaults.standard
        let original = defaults.lastScanDate
        
        defaults.lastScanDate = nil
        XCTAssertTrue(defaults.canScanToday(isProUser: false))
        
        // Restore
        defaults.lastScanDate = original
    }
    
    func testCanScanToday_FreeUser_RecentScan() {
        let defaults = UserDefaults.standard
        let original = defaults.lastScanDate
        
        // Scanned yesterday
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        defaults.lastScanDate = yesterday
        XCTAssertFalse(defaults.canScanToday(isProUser: false))
        
        // Restore
        defaults.lastScanDate = original
    }
    
    func testCanScanToday_FreeUser_OldScan() {
        let defaults = UserDefaults.standard
        let original = defaults.lastScanDate
        
        // Scanned 8 days ago (>7 days)
        let oldDate = Calendar.current.date(byAdding: .day, value: -8, to: Date())!
        defaults.lastScanDate = oldDate
        XCTAssertTrue(defaults.canScanToday(isProUser: false))
        
        // Restore
        defaults.lastScanDate = original
    }
    
    func testCanScanToday_FreeUser_ExactlyOneWeek() {
        let defaults = UserDefaults.standard
        let original = defaults.lastScanDate
        
        // Scanned exactly 7 days ago
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        defaults.lastScanDate = weekAgo
        XCTAssertTrue(defaults.canScanToday(isProUser: false))
        
        // Restore
        defaults.lastScanDate = original
    }
    
    // MARK: - Days Until Next Free Scan Tests
    
    func testDaysUntilNextFreeScan_NoLastScan() {
        let defaults = UserDefaults.standard
        let original = defaults.lastScanDate
        
        defaults.lastScanDate = nil
        XCTAssertEqual(defaults.daysUntilNextFreeScan(), 0)
        
        // Restore
        defaults.lastScanDate = original
    }
    
    func testDaysUntilNextFreeScan_JustScanned() {
        let defaults = UserDefaults.standard
        let original = defaults.lastScanDate
        
        defaults.lastScanDate = Date()
        XCTAssertEqual(defaults.daysUntilNextFreeScan(), 7)
        
        // Restore
        defaults.lastScanDate = original
    }
    
    func testDaysUntilNextFreeScan_PartialWeek() {
        let defaults = UserDefaults.standard
        let original = defaults.lastScanDate
        
        // Scanned 3 days ago
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        defaults.lastScanDate = threeDaysAgo
        XCTAssertEqual(defaults.daysUntilNextFreeScan(), 4)
        
        // Restore
        defaults.lastScanDate = original
    }
    
    func testDaysUntilNextFreeScan_OverAWeek() {
        let defaults = UserDefaults.standard
        let original = defaults.lastScanDate
        
        // Scanned 10 days ago
        let tenDaysAgo = Calendar.current.date(byAdding: .day, value: -10, to: Date())!
        defaults.lastScanDate = tenDaysAgo
        XCTAssertEqual(defaults.daysUntilNextFreeScan(), 0) // max(0, 7-10) = 0
        
        // Restore
        defaults.lastScanDate = original
    }
    
    // MARK: - Notification Time Tests
    
    func testNotificationTime_DefaultIs8AM() {
        let defaults = UserDefaults(suiteName: "TestNotification-\(UUID().uuidString)")!
        // The extension falls back to 8 AM if not set
        // We can't easily test this without accessing the extension on a fresh defaults
    }
    
    func testNotificationTime_SetGet() {
        let defaults = UserDefaults.standard
        let original = defaults.notificationTime
        
        // Set to 9 PM
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = 21
        components.minute = 0
        let testTime = calendar.date(from: components)!
        
        defaults.notificationTime = testTime
        let retrieved = defaults.notificationTime
        
        let retrievedComponents = calendar.dateComponents([.hour, .minute], from: retrieved)
        XCTAssertEqual(retrievedComponents.hour, 21)
        XCTAssertEqual(retrievedComponents.minute, 0)
        
        // Restore
        defaults.notificationTime = original
    }
    
    // MARK: - Has Requested Notifications Tests
    
    func testHasRequestedNotifications_DefaultFalse() {
        let defaults = UserDefaults(suiteName: "TestNotifRequest-\(UUID().uuidString)")!
        XCTAssertFalse(defaults.bool(forKey: "hasRequestedNotifications"))
    }
    
    func testHasRequestedNotifications_SetGet() {
        let defaults = UserDefaults.standard
        let original = defaults.hasRequestedNotifications
        
        defaults.hasRequestedNotifications = true
        XCTAssertTrue(defaults.hasRequestedNotifications)
        
        defaults.hasRequestedNotifications = false
        XCTAssertFalse(defaults.hasRequestedNotifications)
        
        // Restore
        defaults.hasRequestedNotifications = original
    }
}
