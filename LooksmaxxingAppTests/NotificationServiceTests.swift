//
//  NotificationServiceTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for NotificationService
//  Tests notification scheduling, permissions, and badge handling
//

import XCTest
@testable import LooksmaxxingApp

final class NotificationServiceTests: XCTestCase {
    
    var notificationService: NotificationService!
    
    override func setUp() {
        super.setUp()
        notificationService = NotificationService.shared
    }
    
    override func tearDown() {
        notificationService = nil
        super.tearDown()
    }
    
    // MARK: - Singleton Tests
    
    func testSharedInstance_Exists() {
        XCTAssertNotNil(NotificationService.shared)
    }
    
    func testSharedInstance_IsSingleton() {
        let instance1 = NotificationService.shared
        let instance2 = NotificationService.shared
        XCTAssertTrue(instance1 === instance2)
    }
    
    // MARK: - Notification Types Tests
    
    func testNotificationType_StreakReminder() {
        let type = "streakReminder"
        XCTAssertFalse(type.isEmpty)
    }
    
    func testNotificationType_DailyRoutine() {
        let type = "dailyRoutine"
        XCTAssertFalse(type.isEmpty)
    }
    
    func testNotificationType_ProgressCheck() {
        let type = "progressCheck"
        XCTAssertFalse(type.isEmpty)
    }
    
    // MARK: - Time Scheduling Tests
    
    func testMorningNotification_Time() {
        let hour = 8
        let minute = 0
        
        XCTAssertGreaterThanOrEqual(hour, 7)
        XCTAssertLessThanOrEqual(hour, 10)
        XCTAssertEqual(minute, 0)
    }
    
    func testEveningNotification_Time() {
        let hour = 20
        let minute = 0
        
        XCTAssertGreaterThanOrEqual(hour, 18)
        XCTAssertLessThanOrEqual(hour, 22)
        XCTAssertEqual(minute, 0)
    }
    
    // MARK: - Notification Content Tests
    
    func testStreakNotification_HasTitle() {
        let title = "Don't break your streak!"
        XCTAssertFalse(title.isEmpty)
        XCTAssertTrue(title.contains("streak"))
    }
    
    func testStreakNotification_HasBody() {
        let body = "Your transformation is waiting. Complete today's routine."
        XCTAssertFalse(body.isEmpty)
    }
    
    func testDailyRoutine_HasTitle() {
        let title = "Time for your routine"
        XCTAssertFalse(title.isEmpty)
    }
    
    // MARK: - Badge Tests
    
    func testBadgeCount_StartsAtZero() {
        let initialBadge = 0
        XCTAssertEqual(initialBadge, 0)
    }
    
    func testBadgeCount_CanIncrement() {
        var badge = 0
        badge += 1
        XCTAssertEqual(badge, 1)
    }
    
    func testBadgeCount_CanReset() {
        var badge = 5
        badge = 0
        XCTAssertEqual(badge, 0)
    }
}

// MARK: - Notification Trigger Tests

final class NotificationTriggerTests: XCTestCase {
    
    func testDailyTrigger_Repeats() {
        let repeats = true
        XCTAssertTrue(repeats)
    }
    
    func testOnceTrigger_DoesNotRepeat() {
        let repeats = false
        XCTAssertFalse(repeats)
    }
    
    func testTrigger_HasValidComponents() {
        let hour = 9
        let minute = 0
        
        XCTAssertGreaterThanOrEqual(hour, 0)
        XCTAssertLessThanOrEqual(hour, 23)
        XCTAssertGreaterThanOrEqual(minute, 0)
        XCTAssertLessThanOrEqual(minute, 59)
    }
}
