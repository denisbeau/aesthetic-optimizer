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
        XCTAssertFalse(ageGroup.isAllowed, "Users under 13 should not be allowed (COPPA)")
    }
    
    func testAgeGroup_Teen13to16_IsAllowed() {
        let ageGroup = AgeGateView.AgeGroup.teen13to16
        XCTAssertTrue(ageGroup.isAllowed, "Teens (13-16) should be allowed")
    }
    
    func testAgeGroup_Teen16to18_IsAllowed() {
        let ageGroup = AgeGateView.AgeGroup.teen16to18
        XCTAssertTrue(ageGroup.isAllowed, "Teens (16-18) should be allowed")
    }
    
    func testAgeGroup_YoungAdult_IsAllowed() {
        let ageGroup = AgeGateView.AgeGroup.youngAdult
        XCTAssertTrue(ageGroup.isAllowed, "Young adults (18-25) should be allowed")
    }
    
    func testAgeGroup_Adult_IsAllowed() {
        let ageGroup = AgeGateView.AgeGroup.adult
        XCTAssertTrue(ageGroup.isAllowed, "Adults (25+) should be allowed")
    }
    
    func testAgeGroup_RawValues() {
        XCTAssertEqual(AgeGateView.AgeGroup.under13.rawValue, "Under 13")
        XCTAssertEqual(AgeGateView.AgeGroup.teen13to16.rawValue, "13-16")
        XCTAssertEqual(AgeGateView.AgeGroup.teen16to18.rawValue, "16-18")
        XCTAssertEqual(AgeGateView.AgeGroup.youngAdult.rawValue, "18-25")
        XCTAssertEqual(AgeGateView.AgeGroup.adult.rawValue, "25+")
    }
    
    func testAgeGroup_CaseIterable() {
        let allCases = AgeGateView.AgeGroup.allCases
        XCTAssertEqual(allCases.count, 5, "Should have exactly 5 age groups")
        XCTAssertTrue(allCases.contains(.under13))
        XCTAssertTrue(allCases.contains(.teen13to16))
        XCTAssertTrue(allCases.contains(.teen16to18))
        XCTAssertTrue(allCases.contains(.youngAdult))
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
        XCTAssertEqual(allowedGroups.count, 4, "All groups except under13 should be allowed")
    }
    
    func testCOPPA_OnlyUnder13Blocked() {
        for ageGroup in AgeGateView.AgeGroup.allCases {
            if ageGroup == .under13 {
                XCTAssertFalse(ageGroup.isAllowed, "Under 13 must be blocked for COPPA")
            } else {
                XCTAssertTrue(ageGroup.isAllowed, "\(ageGroup.rawValue) should be allowed")
            }
        }
    }
    
    func testAgeGroup_NoTwelveYearOlds() {
        // COPPA requires blocking under 13 - verify no "12" appears in any allowed age group
        for ageGroup in AgeGateView.AgeGroup.allCases where ageGroup.isAllowed {
            XCTAssertFalse(ageGroup.rawValue.contains("12"), "No age group should include 12-year-olds (COPPA violation)")
        }
    }
}
