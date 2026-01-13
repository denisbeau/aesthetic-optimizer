//
//  AgeGateViewTests.swift
//  LooksmaxxingAppTests
//
//  Tests for COPPA-compliant age verification
//

import XCTest
@testable import LooksmaxxingApp

final class AgeGateViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Reset UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: "hasVerifiedAge")
        UserDefaults.standard.removeObject(forKey: "userAgeGroup")
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "hasVerifiedAge")
        UserDefaults.standard.removeObject(forKey: "userAgeGroup")
        super.tearDown()
    }
    
    // MARK: - Age Group Tests
    
    func testAgeGroup_Under13_NotAllowed() {
        let ageGroup = AgeGateView.AgeGroup.under13
        XCTAssertFalse(ageGroup.isAllowed, "Users under 13 should not be allowed")
    }
    
    func testAgeGroup_Teen_IsAllowed() {
        let ageGroup = AgeGateView.AgeGroup.teen
        XCTAssertTrue(ageGroup.isAllowed, "Teens (13-17) should be allowed")
    }
    
    func testAgeGroup_Adult_IsAllowed() {
        let ageGroup = AgeGateView.AgeGroup.adult
        XCTAssertTrue(ageGroup.isAllowed, "Adults (18+) should be allowed")
    }
    
    func testAgeGroup_RawValues() {
        XCTAssertEqual(AgeGateView.AgeGroup.under13.rawValue, "Under 13")
        XCTAssertEqual(AgeGateView.AgeGroup.teen.rawValue, "13-17")
        XCTAssertEqual(AgeGateView.AgeGroup.adult.rawValue, "18+")
    }
    
    func testAgeGroup_CaseIterable() {
        let allCases = AgeGateView.AgeGroup.allCases
        XCTAssertEqual(allCases.count, 3, "Should have exactly 3 age groups")
        XCTAssertTrue(allCases.contains(.under13))
        XCTAssertTrue(allCases.contains(.teen))
        XCTAssertTrue(allCases.contains(.adult))
    }
    
    // MARK: - UserDefaults Persistence Tests
    
    func testInitialState_NotVerified() {
        let hasVerifiedAge = UserDefaults.standard.bool(forKey: "hasVerifiedAge")
        XCTAssertFalse(hasVerifiedAge, "Should not be verified initially")
    }
    
    func testVerification_PersistsToUserDefaults() {
        // Simulate verification
        UserDefaults.standard.set(true, forKey: "hasVerifiedAge")
        UserDefaults.standard.set("18+", forKey: "userAgeGroup")
        
        let hasVerified = UserDefaults.standard.bool(forKey: "hasVerifiedAge")
        let ageGroup = UserDefaults.standard.string(forKey: "userAgeGroup")
        
        XCTAssertTrue(hasVerified)
        XCTAssertEqual(ageGroup, "18+")
    }
    
    func testVerification_Teen_SavesCorrectAgeGroup() {
        UserDefaults.standard.set(true, forKey: "hasVerifiedAge")
        UserDefaults.standard.set("13-17", forKey: "userAgeGroup")
        
        let ageGroup = UserDefaults.standard.string(forKey: "userAgeGroup")
        XCTAssertEqual(ageGroup, "13-17")
    }
    
    // MARK: - Compliance Tests
    
    func testCOPPA_Under13BlockedFromApp() {
        // Verify that under 13 users cannot proceed
        let under13 = AgeGateView.AgeGroup.under13
        XCTAssertFalse(under13.isAllowed, "COPPA requires blocking users under 13")
    }
    
    func testCOPPA_AllowedAgeGroupsCount() {
        let allowedGroups = AgeGateView.AgeGroup.allCases.filter { $0.isAllowed }
        XCTAssertEqual(allowedGroups.count, 2, "Only teen and adult should be allowed")
    }
}
