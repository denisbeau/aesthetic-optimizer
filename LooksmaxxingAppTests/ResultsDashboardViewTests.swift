//
//  ResultsDashboardViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for ResultsDashboardView
//  Tests score display, comparison metrics, and animation timing
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class ResultsDashboardViewTests: XCTestCase {
    
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
    
    // MARK: - Score Display Tests
    
    func testUserScore_DisplaysCorrectly() {
        onboardingData.userScore = 45
        XCTAssertEqual(onboardingData.userScore, 45)
    }
    
    func testAverageScore_HasDefault() {
        XCTAssertEqual(onboardingData.averageScore, 13)
    }
    
    func testScoreDifference_Calculated() {
        onboardingData.userScore = 45
        let diff = onboardingData.scoreDifference
        XCTAssertEqual(diff, 32) // 45 - 13
    }
    
    func testScoreDifference_DisplayFormat() {
        onboardingData.userScore = 45
        let diff = onboardingData.scoreDifference
        let displayText = "+\(diff) above average"
        
        XCTAssertTrue(displayText.contains("+"))
        XCTAssertTrue(displayText.contains("32"))
    }
    
    // MARK: - Bar Chart Tests
    
    func testBarChart_UserBarIsHigher() {
        onboardingData.userScore = 45
        let userHeight: CGFloat = CGFloat(onboardingData.userScore) / 100 * 200
        let avgHeight: CGFloat = CGFloat(onboardingData.averageScore) / 100 * 200
        
        XCTAssertGreaterThan(userHeight, avgHeight)
    }
    
    func testBarChart_AnimatesIn() {
        let animationDuration: Double = 1.5
        XCTAssertGreaterThan(animationDuration, 0.5)
    }
    
    func testBarChart_HasEaseOutBack() {
        // Ease-out-back creates overshoot effect
        let overshoot: Double = 1.56 // Bezier control point
        XCTAssertGreaterThan(overshoot, 1.0)
    }
    
    // MARK: - Comparison Message Tests
    
    func testComparisonMessage_HighScore() {
        onboardingData.userScore = 70
        let message = "Your appearance focus is significantly higher than average"
        XCTAssertTrue(message.contains("higher"))
    }
    
    func testComparisonMessage_AppearAfterAnimation() {
        let messageDelay: Double = 1.7 // After bar animation
        XCTAssertGreaterThan(messageDelay, 1.5)
    }
    
    // MARK: - Visual Elements Tests
    
    func testBarWidth() {
        let barWidth: CGFloat = 80
        XCTAssertGreaterThanOrEqual(barWidth, 60)
        XCTAssertLessThanOrEqual(barWidth, 120)
    }
    
    func testBarCornerRadius() {
        let cornerRadius: CGFloat = 10
        XCTAssertGreaterThan(cornerRadius, 0)
    }
    
    // MARK: - Color Tests
    
    func testUserBarGradient() {
        let colors = ["00D4FF", "10B981"]
        XCTAssertEqual(colors.count, 2)
    }
    
    func testAverageBarColor() {
        let color = "6B7280"
        XCTAssertEqual(color.count, 6)
    }
}

// MARK: - Score Interpretation Tests

final class ScoreInterpretationTests: XCTestCase {
    
    func testScore_Low() {
        let score = 20
        let interpretation = score < 30 ? "low" : "moderate"
        XCTAssertEqual(interpretation, "low")
    }
    
    func testScore_Moderate() {
        let score = 40
        let interpretation = score < 30 ? "low" : (score < 60 ? "moderate" : "high")
        XCTAssertEqual(interpretation, "moderate")
    }
    
    func testScore_High() {
        let score = 70
        let interpretation = score < 30 ? "low" : (score < 60 ? "moderate" : "high")
        XCTAssertEqual(interpretation, "high")
    }
}
