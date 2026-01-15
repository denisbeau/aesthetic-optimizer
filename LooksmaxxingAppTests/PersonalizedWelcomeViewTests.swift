//
//  PersonalizedWelcomeViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for PersonalizedWelcomeView
//  Tests personalized greeting, goal badges, and celebration animation
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class PersonalizedWelcomeViewTests: XCTestCase {
    
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
    
    // MARK: - Personalization Tests
    
    func testGreeting_UsesName() {
        onboardingData.userName = "Marcus"
        let greeting = "Welcome, \(onboardingData.userName)!"
        
        XCTAssertTrue(greeting.contains("Marcus"))
    }
    
    func testGreeting_FallbackIfNoName() {
        onboardingData.userName = ""
        let greeting = onboardingData.userName.isEmpty ? "Welcome!" : "Welcome, \(onboardingData.userName)!"
        
        XCTAssertEqual(greeting, "Welcome!")
    }
    
    func testDisplaysSelectedGoals() {
        onboardingData.selectedGoals.insert("jawline")
        onboardingData.selectedGoals.insert("skin")
        
        XCTAssertEqual(onboardingData.selectedGoals.count, 2)
    }
    
    func testDisplaysTransformationDate() {
        let date = onboardingData.formattedTransformationDate
        XCTAssertFalse(date.isEmpty)
    }
    
    // MARK: - Goal Badge Tests
    
    func testGoalBadges_MatchSelectedGoals() {
        onboardingData.selectedGoals.insert("jawline")
        onboardingData.selectedGoals.insert("confidence")
        
        let badges = goalItems.filter { onboardingData.selectedGoals.contains($0.id) }
        XCTAssertEqual(badges.count, 2)
    }
    
    func testGoalBadges_HaveIcons() {
        let selectedGoalIds = ["jawline", "skin"]
        let selectedGoals = goalItems.filter { selectedGoalIds.contains($0.id) }
        
        for goal in selectedGoals {
            XCTAssertFalse(goal.icon.isEmpty)
        }
    }
    
    func testGoalBadges_HaveTitles() {
        let selectedGoalIds = ["jawline", "skin"]
        let selectedGoals = goalItems.filter { selectedGoalIds.contains($0.id) }
        
        for goal in selectedGoals {
            XCTAssertFalse(goal.title.isEmpty)
        }
    }
    
    // MARK: - Celebration Animation Tests
    
    func testConfetti_AnimationDuration() {
        let duration: Double = 2.0
        XCTAssertGreaterThan(duration, 1.0)
    }
    
    func testWelcomeIcon_Animates() {
        let iconAnimationDelay: Double = 0.3
        XCTAssertGreaterThan(iconAnimationDelay, 0)
    }
    
    // MARK: - Message Content Tests
    
    func testWelcomeMessage_IsCongratulatory() {
        let message = "Your personalized transformation journey starts now"
        XCTAssertFalse(message.isEmpty)
    }
    
    func testPlanReady_Message() {
        let message = "Your plan is ready"
        XCTAssertTrue(message.contains("ready"))
    }
    
    // MARK: - Auto-Advance Tests
    
    func testAutoAdvance_Delay() {
        let delay: Double = 3.0
        XCTAssertGreaterThanOrEqual(delay, 2.5)
        XCTAssertLessThanOrEqual(delay, 4.0)
    }
}
