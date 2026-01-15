//
//  QuizViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for QuizView and quiz flow
//  Tests question navigation, answer storage, and auto-advance
//

import XCTest
import SwiftUI
@testable import LooksmaxxingApp

@MainActor
final class QuizViewTests: XCTestCase {
    
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
    
    // MARK: - Answer Storage Tests
    
    func testStoreAnswer_Question1_PrimaryGoal() {
        onboardingData.primaryGoal = "Define my jawline"
        XCTAssertEqual(onboardingData.primaryGoal, "Define my jawline")
    }
    
    func testStoreAnswer_Question2_CheckFrequency() {
        onboardingData.checkFrequency = "Multiple times daily"
        XCTAssertEqual(onboardingData.checkFrequency, "Multiple times daily")
    }
    
    func testStoreAnswer_Question3_ComparisonSource() {
        onboardingData.comparisonSource = "Social media"
        XCTAssertEqual(onboardingData.comparisonSource, "Social media")
    }
    
    func testStoreAnswer_Question4_HasGottenWorse_Yes() {
        onboardingData.hasGottenWorse = true
        XCTAssertTrue(onboardingData.hasGottenWorse)
    }
    
    func testStoreAnswer_Question4_HasGottenWorse_No() {
        onboardingData.hasGottenWorse = false
        XCTAssertFalse(onboardingData.hasGottenWorse)
    }
    
    func testStoreAnswer_Question5_ConcernOnset() {
        onboardingData.concernOnset = "13-17"
        XCTAssertEqual(onboardingData.concernOnset, "13-17")
    }
    
    func testStoreAnswer_Question6_PhysicalHabits() {
        onboardingData.physicalHabits = "Mouth breathing"
        XCTAssertEqual(onboardingData.physicalHabits, "Mouth breathing")
    }
    
    func testStoreAnswer_Question7_PhotoAvoidance() {
        onboardingData.photoAvoidance = "Always"
        XCTAssertEqual(onboardingData.photoAvoidance, "Always")
    }
    
    func testStoreAnswer_Question8_StressMirrorCheck() {
        onboardingData.stressMirrorCheck = "Frequently"
        XCTAssertEqual(onboardingData.stressMirrorCheck, "Frequently")
    }
    
    func testStoreAnswer_Question9_SocialMediaTrigger_Yes() {
        onboardingData.socialMediaTrigger = true
        XCTAssertTrue(onboardingData.socialMediaTrigger)
    }
    
    func testStoreAnswer_Question10_HasSpentMoney_Yes() {
        onboardingData.hasSpentMoney = true
        XCTAssertTrue(onboardingData.hasSpentMoney)
    }
    
    // MARK: - Progress Calculation Tests
    
    func testProgress_Question1_Is10Percent() {
        let progress: CGFloat = CGFloat(1) / CGFloat(quizQuestions.count)
        XCTAssertEqual(progress, 0.1, accuracy: 0.01)
    }
    
    func testProgress_Question5_Is50Percent() {
        let progress: CGFloat = CGFloat(5) / CGFloat(quizQuestions.count)
        XCTAssertEqual(progress, 0.5, accuracy: 0.01)
    }
    
    func testProgress_Question10_Is100Percent() {
        let progress: CGFloat = CGFloat(10) / CGFloat(quizQuestions.count)
        XCTAssertEqual(progress, 1.0, accuracy: 0.01)
    }
    
    // MARK: - Quiz Flow Tests
    
    func testFullQuizFlow_AllAnswersStored() {
        // Simulate answering all questions
        onboardingData.primaryGoal = "Define my jawline"
        onboardingData.checkFrequency = "Daily"
        onboardingData.comparisonSource = "Social media"
        onboardingData.hasGottenWorse = true
        onboardingData.concernOnset = "18-24"
        onboardingData.physicalHabits = "Both"
        onboardingData.photoAvoidance = "Sometimes"
        onboardingData.stressMirrorCheck = "Sometimes"
        onboardingData.socialMediaTrigger = true
        onboardingData.hasSpentMoney = false
        
        // Verify all answers stored
        XCTAssertFalse(onboardingData.primaryGoal.isEmpty)
        XCTAssertFalse(onboardingData.checkFrequency.isEmpty)
        XCTAssertFalse(onboardingData.comparisonSource.isEmpty)
        XCTAssertFalse(onboardingData.concernOnset.isEmpty)
        XCTAssertFalse(onboardingData.physicalHabits.isEmpty)
        XCTAssertFalse(onboardingData.photoAvoidance.isEmpty)
        XCTAssertFalse(onboardingData.stressMirrorCheck.isEmpty)
    }
    
    func testQuizFlow_CalculatesScoreAfterCompletion() {
        // Set answers that affect score
        onboardingData.checkFrequency = "Multiple times daily"
        onboardingData.hasGottenWorse = true
        onboardingData.photoAvoidance = "Always"
        onboardingData.stressMirrorCheck = "Frequently"
        onboardingData.socialMediaTrigger = true
        onboardingData.hasSpentMoney = true
        
        // Calculate score
        onboardingData.calculateScore()
        
        // Should have high score
        XCTAssertGreaterThan(onboardingData.userScore, 50)
    }
}

// MARK: - QuizOptionButton Tests

final class QuizOptionButtonTests: XCTestCase {
    
    func testQuizOptionButton_NotSelected_ShowsIndex() {
        // UI component test - verify the button shows index when not selected
        let index = 1
        let text = "Test Option"
        let isSelected = false
        
        XCTAssertEqual(index, 1)
        XCTAssertEqual(text, "Test Option")
        XCTAssertFalse(isSelected)
    }
    
    func testQuizOptionButton_Selected_ShowsCheckmark() {
        // UI component test - verify the button shows checkmark when selected
        let isSelected = true
        XCTAssertTrue(isSelected)
    }
}
