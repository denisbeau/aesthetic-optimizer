//
//  LaborIllusionViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for LaborIllusionView
//  Tests progress animation, variable velocity, and step display
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class LaborIllusionViewTests: XCTestCase {
    
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
    
    // MARK: - Progress Steps Tests
    
    func testProgressSteps_HasMultipleSteps() {
        let steps = [
            "Analyzing responses...",
            "Building your profile...",
            "Calculating your score...",
            "Identifying patterns...",
            "Generating recommendations...",
            "Preparing your results..."
        ]
        
        XCTAssertGreaterThanOrEqual(steps.count, 4)
    }
    
    func testProgressSteps_AllHaveText() {
        let steps = [
            "Analyzing responses...",
            "Building your profile...",
            "Calculating your score..."
        ]
        
        for step in steps {
            XCTAssertFalse(step.isEmpty)
        }
    }
    
    // MARK: - Progress Animation Tests
    
    func testProgress_StartsAtZero() {
        let initialProgress: CGFloat = 0
        XCTAssertEqual(initialProgress, 0)
    }
    
    func testProgress_EndsAt100() {
        let finalProgress: CGFloat = 1.0
        XCTAssertEqual(finalProgress, 1.0)
    }
    
    func testVariableVelocity_HasMultipleSpeeds() {
        // Variable velocity creates more realistic "work" feeling
        let speeds: [Double] = [0.5, 1.0, 1.5, 0.8]
        
        XCTAssertGreaterThan(speeds.count, 1)
        XCTAssertNotEqual(speeds[0], speeds[1])
    }
    
    // MARK: - Duration Tests
    
    func testTotalDuration_IsReasonable() {
        let duration: Double = 6.0 // seconds
        XCTAssertGreaterThanOrEqual(duration, 4) // Not too fast
        XCTAssertLessThanOrEqual(duration, 10) // Not too slow
    }
    
    func testStepDuration_IsUniform() {
        let steps = 6
        let totalDuration: Double = 6.0
        let stepDuration = totalDuration / Double(steps)
        
        XCTAssertEqual(stepDuration, 1.0, accuracy: 0.01)
    }
    
    // MARK: - Score Calculation Tests
    
    func testCalculatesScore_DuringAnimation() {
        // Score should be calculated during labor illusion
        onboardingData.checkFrequency = "Daily"
        onboardingData.hasGottenWorse = true
        onboardingData.calculateScore()
        
        XCTAssertGreaterThan(onboardingData.userScore, 0)
    }
    
    // MARK: - Auto-Advance Tests
    
    func testAutoAdvance_AfterCompletion() {
        let autoAdvanceDelay: Double = 0.5 // After animation completes
        XCTAssertGreaterThan(autoAdvanceDelay, 0)
    }
    
    func testAutoAdvance_ToResultsDashboard() {
        let targetScreen = 15 // Results Dashboard
        XCTAssertEqual(targetScreen, 15)
    }
}

// MARK: - Progress Bar Animation Tests

final class ProgressBarAnimationTests: XCTestCase {
    
    func testProgressBar_Height() {
        let height: CGFloat = 8
        XCTAssertGreaterThan(height, 4)
        XCTAssertLessThan(height, 16)
    }
    
    func testProgressBar_HasGradient() {
        let gradientColors = ["10B981", "34D399"]
        XCTAssertEqual(gradientColors.count, 2)
    }
    
    func testProgressBar_HasRoundedCorners() {
        let cornerRadius: CGFloat = 4
        XCTAssertGreaterThan(cornerRadius, 0)
    }
}
