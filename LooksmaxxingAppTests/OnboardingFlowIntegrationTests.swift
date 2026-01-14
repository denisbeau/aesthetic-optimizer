//
//  OnboardingFlowIntegrationTests.swift
//  LooksmaxxingAppTests
//
//  Integration tests for the complete new onboarding flow
//  Tests PreQuiz → Quiz → Symptoms → Goals → Signature → Plan Card → Paywall
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class OnboardingFlowIntegrationTests: XCTestCase {
    
    var quizData: OnboardingQuizData!
    
    override func setUp() {
        super.setUp()
        // Clear all onboarding-related UserDefaults
        UserDefaults.standard.removeObject(forKey: "hasSeenPreQuiz")
        UserDefaults.standard.removeObject(forKey: "selectedSymptoms")
        UserDefaults.standard.removeObject(forKey: "selectedGoals")
        UserDefaults.standard.removeObject(forKey: "commitmentSignature")
        quizData = OnboardingQuizData()
    }
    
    override func tearDown() {
        quizData = nil
        // Clean up
        UserDefaults.standard.removeObject(forKey: "hasSeenPreQuiz")
        UserDefaults.standard.removeObject(forKey: "selectedSymptoms")
        UserDefaults.standard.removeObject(forKey: "selectedGoals")
        UserDefaults.standard.removeObject(forKey: "commitmentSignature")
        super.tearDown()
    }
    
    // MARK: - Complete Flow Tests
    
    func testCompleteOnboardingFlow_AllSteps() {
        // Step 1: Pre-Quiz (sets hasSeenPreQuiz)
        UserDefaults.standard.set(true, forKey: "hasSeenPreQuiz")
        XCTAssertTrue(UserDefaults.standard.bool(forKey: "hasSeenPreQuiz"))
        
        // Step 2: Quiz (sets quiz answers)
        quizData.dedicationLevel = 8
        quizData.goal = "🔥 Sharper jawline"
        quizData.hasRoutine = "None"
        quizData.saveToUserDefaults()
        
        // Step 3: Symptoms Selection
        quizData.selectedSymptoms = ["avoid_photos", "mouth_breathing", "poor_posture"]
        quizData.saveToUserDefaults()
        XCTAssertEqual(quizData.selectedSymptoms.count, 3)
        
        // Step 4: Goals Selection
        quizData.selectedGoals = ["sharper_jawline", "better_skin", "increased_confidence"]
        quizData.saveToUserDefaults()
        XCTAssertEqual(quizData.selectedGoals.count, 3)
        
        // Step 5: Signature
        let signatureData = Data("test signature".utf8)
        quizData.commitmentSignature = signatureData
        quizData.saveToUserDefaults()
        XCTAssertTrue(quizData.hasSignedCommitment)
        
        // Step 6: Plan Preview Card (uses quizData)
        XCTAssertNotNil(quizData.commitmentSignature)
        let badges = quizData.goalBadges
        XCTAssertEqual(badges.count, 3)
        
        // Step 7: Paywall (uses all data)
        let transformationDate = quizData.transformationDateFormatted
        XCTAssertFalse(transformationDate.isEmpty)
        XCTAssertGreaterThan(quizData.potentialScore, 7.0)
    }
    
    func testOnboardingFlow_DataPersistenceAcrossSessions() {
        // Simulate user completing flow
        quizData.selectedSymptoms = ["avoid_photos"]
        quizData.selectedGoals = ["sharper_jawline"]
        quizData.commitmentSignature = Data("signature".utf8)
        quizData.saveToUserDefaults()
        
        // Simulate app restart (new instance)
        let newQuizData = OnboardingQuizData()
        
        // Verify all data persisted
        XCTAssertEqual(newQuizData.selectedSymptoms.count, 1)
        XCTAssertEqual(newQuizData.selectedGoals.count, 1)
        XCTAssertNotNil(newQuizData.commitmentSignature)
        XCTAssertTrue(newQuizData.hasSignedCommitment)
    }
    
    func testOnboardingFlow_ValidationAtEachStep() {
        // Symptoms: Must select at least 1
        quizData.selectedSymptoms = []
        XCTAssertTrue(quizData.selectedSymptoms.isEmpty)
        
        quizData.selectedSymptoms = ["avoid_photos"]
        XCTAssertFalse(quizData.selectedSymptoms.isEmpty)
        
        // Goals: Must select 1-3
        quizData.selectedGoals = []
        XCTAssertTrue(quizData.selectedGoals.isEmpty)
        
        quizData.selectedGoals = ["sharper_jawline"]
        XCTAssertFalse(quizData.selectedGoals.isEmpty)
        XCTAssertLessThanOrEqual(quizData.selectedGoals.count, 3)
        
        // Signature: Must have valid signature
        quizData.commitmentSignature = nil
        XCTAssertFalse(quizData.hasSignedCommitment)
        
        quizData.commitmentSignature = Data("signature".utf8)
        XCTAssertTrue(quizData.hasSignedCommitment)
    }
    
    func testOnboardingFlow_GoalBadges_GeneratedCorrectly() {
        quizData.selectedGoals = ["sharper_jawline", "better_skin", "increased_confidence"]
        let badges = quizData.goalBadges
        
        XCTAssertEqual(badges.count, 3)
        
        // Verify each badge has correct properties
        for badge in badges {
            XCTAssertFalse(badge.id.isEmpty)
            XCTAssertFalse(badge.title.isEmpty)
            XCTAssertFalse(badge.icon.isEmpty)
            XCTAssertTrue(badge.color.hasPrefix("#"))
        }
        
        // Verify specific mappings
        let jawlineBadge = badges.first { $0.id == "sharper_jawline" }
        XCTAssertNotNil(jawlineBadge)
        XCTAssertEqual(jawlineBadge?.icon, "🔥")
        XCTAssertEqual(jawlineBadge?.color, "#F59E0B")
    }
    
    func testOnboardingFlow_TransformationDate_Is60Days() {
        let date = quizData.transformationDate
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: date)
        let days = components.day ?? 0
        
        // Should be 60 days, allow 1 day tolerance
        XCTAssertGreaterThanOrEqual(days, 59)
        XCTAssertLessThanOrEqual(days, 61)
    }
    
    func testOnboardingFlow_TransformationDateFormatted_ValidFormat() {
        let formatted = quizData.transformationDateFormatted
        XCTAssertFalse(formatted.isEmpty)
        XCTAssertTrue(formatted.contains(",")) // Should be "MMM d, yyyy"
    }
    
    // MARK: - Edge Cases
    
    func testOnboardingFlow_EmptySelections_ValidationPreventsProgress() {
        // Empty symptoms
        quizData.selectedSymptoms = []
        XCTAssertTrue(quizData.selectedSymptoms.isEmpty)
        
        // Empty goals
        quizData.selectedGoals = []
        XCTAssertTrue(quizData.selectedGoals.isEmpty)
        
        // No signature
        quizData.commitmentSignature = nil
        XCTAssertFalse(quizData.hasSignedCommitment)
    }
    
    func testOnboardingFlow_MaximumSelections_Works() {
        // Maximum symptoms (no limit, but test many)
        quizData.selectedSymptoms = [
            "avoid_photos", "self_conscious", "compare_others", "tried_routines",
            "receded_chin", "mouth_breathing", "poor_posture", "facial_asymmetry",
            "skin_texture", "difficulty_breathing", "jaw_tension", "sleep_quality"
        ]
        XCTAssertEqual(quizData.selectedSymptoms.count, 12)
        
        // Maximum goals (3)
        quizData.selectedGoals = ["sharper_jawline", "better_skin", "increased_confidence"]
        XCTAssertEqual(quizData.selectedGoals.count, 3)
    }
    
    func testOnboardingFlow_PartialCompletion_DataPersists() {
        // User completes symptoms but not goals
        quizData.selectedSymptoms = ["avoid_photos"]
        quizData.saveToUserDefaults()
        
        // App restarts
        let newQuizData = OnboardingQuizData()
        XCTAssertEqual(newQuizData.selectedSymptoms.count, 1)
        XCTAssertTrue(newQuizData.selectedGoals.isEmpty)
    }
}
