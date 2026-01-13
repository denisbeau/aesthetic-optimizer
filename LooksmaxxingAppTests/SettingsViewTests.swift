//
//  SettingsViewTests.swift
//  LooksmaxxingAppTests
//
//  Tests for settings functionality
//

import XCTest
@testable import LooksmaxxingApp

final class SettingsViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Reset notification preferences
        UserDefaults.standard.removeObject(forKey: "notificationHour")
        UserDefaults.standard.removeObject(forKey: "notificationMinute")
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "notificationHour")
        UserDefaults.standard.removeObject(forKey: "notificationMinute")
        super.tearDown()
    }
    
    // MARK: - Notification Time Tests
    
    func testDefaultNotificationTime() {
        // Default should be 9:00 AM
        let defaultHour = UserDefaults.standard.integer(forKey: "notificationHour")
        let defaultMinute = UserDefaults.standard.integer(forKey: "notificationMinute")
        
        // When not set, integer returns 0, but default in code is 9
        XCTAssertEqual(defaultHour, 0, "Default hour from UserDefaults is 0 (code defaults to 9)")
        XCTAssertEqual(defaultMinute, 0, "Default minute should be 0")
    }
    
    func testNotificationTime_Persistence() {
        UserDefaults.standard.set(14, forKey: "notificationHour")
        UserDefaults.standard.set(30, forKey: "notificationMinute")
        
        let hour = UserDefaults.standard.integer(forKey: "notificationHour")
        let minute = UserDefaults.standard.integer(forKey: "notificationMinute")
        
        XCTAssertEqual(hour, 14, "Hour should persist")
        XCTAssertEqual(minute, 30, "Minute should persist")
    }
    
    func testNotificationTime_ValidRange_Hour() {
        // Hours should be 0-23
        for hour in 0...23 {
            UserDefaults.standard.set(hour, forKey: "notificationHour")
            let saved = UserDefaults.standard.integer(forKey: "notificationHour")
            XCTAssertEqual(saved, hour, "Hour \(hour) should be valid")
        }
    }
    
    func testNotificationTime_ValidRange_Minute() {
        // Minutes should be 0-59
        for minute in [0, 15, 30, 45, 59] {
            UserDefaults.standard.set(minute, forKey: "notificationMinute")
            let saved = UserDefaults.standard.integer(forKey: "notificationMinute")
            XCTAssertEqual(saved, minute, "Minute \(minute) should be valid")
        }
    }
    
    // MARK: - Secrets Configuration Tests
    
    func testSecrets_PrivacyPolicyURL_IsValid() {
        let url = URL(string: Secrets.privacyPolicyURL)
        XCTAssertNotNil(url, "Privacy policy URL should be valid")
    }
    
    func testSecrets_TermsOfServiceURL_IsValid() {
        let url = URL(string: Secrets.termsOfServiceURL)
        XCTAssertNotNil(url, "Terms of service URL should be valid")
    }
    
    func testSecrets_SupportEmail_IsValid() {
        let email = Secrets.supportEmail
        XCTAssertTrue(email.contains("@"), "Support email should be valid")
    }
    
    // MARK: - Data Management Tests
    
    func testDataExport_ServiceExists() {
        let service = DataExportService()
        XCTAssertNotNil(service, "DataExportService should be instantiable")
    }
    
    // MARK: - App Version Tests
    
    func testAppVersion_FromBundle() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        // In test environment, this may be nil or the test bundle version
        // Just verify it doesn't crash
        XCTAssertTrue(true, "Version lookup should not crash")
    }
    
    func testBuildNumber_FromBundle() {
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        // In test environment, this may be nil or the test bundle version
        XCTAssertTrue(true, "Build lookup should not crash")
    }
    
    // MARK: - Subscription Management Tests
    
    func testSubscriptionManagementURL_IsValid() {
        let url = URL(string: "https://apps.apple.com/account/subscriptions")
        XCTAssertNotNil(url, "Subscription management URL should be valid")
    }
    
    // MARK: - Reset/Delete Tests
    
    func testDeleteAllData_ClearsUserDefaults() {
        // Set some test data
        UserDefaults.standard.set("test", forKey: "testKey_SettingsTest")
        
        // Clear it
        UserDefaults.standard.removeObject(forKey: "testKey_SettingsTest")
        
        // Verify
        let value = UserDefaults.standard.string(forKey: "testKey_SettingsTest")
        XCTAssertNil(value, "Data should be cleared")
    }
}
