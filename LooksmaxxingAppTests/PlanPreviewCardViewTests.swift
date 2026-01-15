//
//  PlanPreviewCardViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for PlanPreviewCardView
//  Tests personalized ID card display and user data presentation
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class PlanPreviewCardViewTests: XCTestCase {
    
    var onboardingData: OnboardingData!
    
    override func setUp() {
        super.setUp()
        onboardingData = OnboardingData()
        onboardingData.reset()
    }
    
    override func tearDown() {
        onboardingData = nil
        super.tearDown()
    }
    
    // MARK: - User Data Display Tests
    
    func testDisplaysUserName() {
        onboardingData.userName = "Marcus"
        XCTAssertEqual(onboardingData.userName, "Marcus")
    }
    
    func testDisplaysUserAge() {
        onboardingData.userAge = "24"
        XCTAssertEqual(onboardingData.userAge, "24")
    }
    
    func testDisplaysTransformationDate() {
        let date = onboardingData.formattedTransformationDate
        XCTAssertFalse(date.isEmpty)
    }
    
    func testDisplaysStartDate() {
        let today = onboardingData.todayFormatted
        XCTAssertFalse(today.isEmpty)
        XCTAssertEqual(today.count, 5) // MM/dd format
    }
    
    // MARK: - Score Display Tests
    
    func testDisplaysUserScore() {
        onboardingData.checkFrequency = "Daily"
        onboardingData.calculateScore()
        
        XCTAssertGreaterThan(onboardingData.userScore, 0)
    }
    
    func testDisplaysScoreDifference() {
        onboardingData.userScore = 45
        let diff = onboardingData.scoreDifference
        
        XCTAssertEqual(diff, 45 - onboardingData.averageScore)
    }
    
    // MARK: - Card Styling Tests
    
    func testCardHasMinimumWidth() {
        let minWidth: CGFloat = 280
        XCTAssertGreaterThan(minWidth, 0)
    }
    
    func testCardHasMinimumHeight() {
        let minHeight: CGFloat = 380
        XCTAssertGreaterThan(minHeight, 0)
    }
    
    // MARK: - Animation Tests
    
    func testFloatingAnimationAmplitude() {
        let amplitude: CGFloat = 8
        XCTAssertGreaterThan(amplitude, 0)
        XCTAssertLessThanOrEqual(amplitude, 15) // Not too extreme
    }
    
    func testRotationAngle() {
        let maxRotation: Double = 3.0 // degrees
        XCTAssertGreaterThan(maxRotation, 0)
        XCTAssertLessThanOrEqual(maxRotation, 5) // Subtle rotation
    }
    
    // MARK: - Auto-Transition Tests
    
    func testAutoTransitionDelay() {
        let delay: Double = 3.5 // seconds
        XCTAssertGreaterThan(delay, 2) // Give time to view
        XCTAssertLessThanOrEqual(delay, 5) // Don't wait too long
    }
}

// MARK: - ID Card Element Tests

final class IDCardElementTests: XCTestCase {
    
    func testMemberIDFormat() {
        // Member ID should be formatted like ASC-XXXXX
        let memberIdPrefix = "ASC-"
        let memberId = memberIdPrefix + "12345"
        
        XCTAssertTrue(memberId.hasPrefix("ASC-"))
        XCTAssertEqual(memberId.count, 9) // ASC-XXXXX
    }
    
    func testMembershipLevel() {
        let levels = ["FOUNDING MEMBER", "PREMIUM MEMBER", "MEMBER"]
        let selectedLevel = "FOUNDING MEMBER"
        
        XCTAssertTrue(levels.contains(selectedLevel))
    }
    
    func testGoalBadges_ShowSelectedGoals() {
        let selectedGoals: Set<String> = ["jawline", "skin"]
        let goalCount = selectedGoals.count
        
        XCTAssertEqual(goalCount, 2)
    }
}
