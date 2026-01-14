//
//  OnboardingQuizDataTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for OnboardingQuizData model
//  Tests new Quittr-inspired properties and computed properties
//

import XCTest
@testable import LooksmaxxingApp

final class OnboardingQuizDataTests: XCTestCase {
    
    var quizData: OnboardingQuizData!
    let testDefaults = UserDefaults(suiteName: "test.quiz.data")!
    
    override func setUp() {
        super.setUp()
        // Clear test UserDefaults
        testDefaults.removePersistentDomain(forName: "test.quiz.data")
        quizData = OnboardingQuizData()
    }
    
    override func tearDown() {
        quizData = nil
        testDefaults.removePersistentDomain(forName: "test.quiz.data")
        super.tearDown()
    }
    
    // MARK: - New Properties Tests
    
    func testSelectedSymptoms_InitialState_Empty() {
        XCTAssertTrue(quizData.selectedSymptoms.isEmpty)
    }
    
    func testSelectedSymptoms_SetGet() {
        quizData.selectedSymptoms = ["avoid_photos", "mouth_breathing"]
        XCTAssertEqual(quizData.selectedSymptoms.count, 2)
        XCTAssertTrue(quizData.selectedSymptoms.contains("avoid_photos"))
        XCTAssertTrue(quizData.selectedSymptoms.contains("mouth_breathing"))
    }
    
    func testSelectedGoals_InitialState_Empty() {
        XCTAssertTrue(quizData.selectedGoals.isEmpty)
    }
    
    func testSelectedGoals_SetGet() {
        quizData.selectedGoals = ["sharper_jawline", "better_skin"]
        XCTAssertEqual(quizData.selectedGoals.count, 2)
        XCTAssertTrue(quizData.selectedGoals.contains("sharper_jawline"))
        XCTAssertTrue(quizData.selectedGoals.contains("better_skin"))
    }
    
    func testCommitmentSignature_InitialState_Nil() {
        XCTAssertNil(quizData.commitmentSignature)
    }
    
    func testCommitmentSignature_SetGet() {
        let testData = Data("test signature".utf8)
        quizData.commitmentSignature = testData
        XCTAssertNotNil(quizData.commitmentSignature)
        XCTAssertEqual(quizData.commitmentSignature, testData)
    }
    
    // MARK: - Transformation Date Tests
    
    func testTransformationDate_Is60DaysFromNow() {
        let actualDate = quizData.transformationDate
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: actualDate)
        let days = components.day ?? 0
        
        // Should be 60 days, allow 1 day tolerance
        XCTAssertGreaterThanOrEqual(days, 59)
        XCTAssertLessThanOrEqual(days, 61)
    }
    
    func testTransformationDateFormatted_ValidFormat() {
        let formatted = quizData.transformationDateFormatted
        XCTAssertFalse(formatted.isEmpty)
        // Should match "MMM d, yyyy" format (e.g., "Mar 14, 2026")
        XCTAssertTrue(formatted.contains(","))
    }
    
    // MARK: - Commitment Tests
    
    func testHasSignedCommitment_NoSignature_ReturnsFalse() {
        quizData.commitmentSignature = nil
        XCTAssertFalse(quizData.hasSignedCommitment)
    }
    
    func testHasSignedCommitment_WithSignature_ReturnsTrue() {
        quizData.commitmentSignature = Data("signature".utf8)
        XCTAssertTrue(quizData.hasSignedCommitment)
    }
    
    // MARK: - Goal Badges Tests
    
    func testGoalBadges_EmptyGoals_ReturnsEmpty() {
        quizData.selectedGoals = []
        XCTAssertTrue(quizData.goalBadges.isEmpty)
    }
    
    func testGoalBadges_SingleGoal_ReturnsOneBadge() {
        quizData.selectedGoals = ["sharper_jawline"]
        let badges = quizData.goalBadges
        XCTAssertEqual(badges.count, 1)
        XCTAssertEqual(badges.first?.id, "sharper_jawline")
        XCTAssertEqual(badges.first?.title, "Sharper jawline")
        XCTAssertEqual(badges.first?.icon, "🔥")
        XCTAssertEqual(badges.first?.color, "#F59E0B")
    }
    
    func testGoalBadges_MultipleGoals_ReturnsMultipleBadges() {
        quizData.selectedGoals = ["sharper_jawline", "better_skin", "increased_confidence"]
        let badges = quizData.goalBadges
        XCTAssertEqual(badges.count, 3)
        XCTAssertEqual(badges.map { $0.id }, ["sharper_jawline", "better_skin", "increased_confidence"])
    }
    
    func testGoalBadges_UnknownGoal_ReturnsDefaultIcon() {
        quizData.selectedGoals = ["unknown_goal"]
        let badges = quizData.goalBadges
        XCTAssertEqual(badges.count, 1)
        XCTAssertEqual(badges.first?.icon, "🎯")
        XCTAssertEqual(badges.first?.color, "#00D4FF")
    }
    
    func testGoalBadges_TitleFormatting_ReplacesUnderscores() {
        quizData.selectedGoals = ["sharper_jawline", "better_skin"]
        let badges = quizData.goalBadges
        XCTAssertEqual(badges[0].title, "Sharper jawline")
        XCTAssertEqual(badges[1].title, "Better skin")
    }
    
    // MARK: - Persistence Tests
    
    func testSaveToUserDefaults_SelectedSymptoms_Persists() {
        quizData.selectedSymptoms = ["avoid_photos", "mouth_breathing"]
        quizData.saveToUserDefaults()
        
        let loaded = UserDefaults.standard.array(forKey: "selectedSymptoms") as? [String]
        XCTAssertEqual(loaded?.count, 2)
        XCTAssertTrue(loaded?.contains("avoid_photos") ?? false)
    }
    
    func testSaveToUserDefaults_SelectedGoals_Persists() {
        quizData.selectedGoals = ["sharper_jawline", "better_skin"]
        quizData.saveToUserDefaults()
        
        let loaded = UserDefaults.standard.array(forKey: "selectedGoals") as? [String]
        XCTAssertEqual(loaded?.count, 2)
        XCTAssertTrue(loaded?.contains("sharper_jawline") ?? false)
    }
    
    func testSaveToUserDefaults_CommitmentSignature_Persists() {
        let testData = Data("test signature".utf8)
        quizData.commitmentSignature = testData
        quizData.saveToUserDefaults()
        
        let loaded = UserDefaults.standard.data(forKey: "commitmentSignature")
        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded, testData)
    }
    
    func testLoadFromUserDefaults_SelectedSymptoms_Loads() {
        UserDefaults.standard.set(["avoid_photos", "mouth_breathing"], forKey: "selectedSymptoms")
        let newQuizData = OnboardingQuizData()
        
        XCTAssertEqual(newQuizData.selectedSymptoms.count, 2)
        XCTAssertTrue(newQuizData.selectedSymptoms.contains("avoid_photos"))
    }
    
    func testLoadFromUserDefaults_SelectedGoals_Loads() {
        UserDefaults.standard.set(["sharper_jawline", "better_skin"], forKey: "selectedGoals")
        let newQuizData = OnboardingQuizData()
        
        XCTAssertEqual(newQuizData.selectedGoals.count, 2)
        XCTAssertTrue(newQuizData.selectedGoals.contains("sharper_jawline"))
    }
    
    func testLoadFromUserDefaults_CommitmentSignature_Loads() {
        let testData = Data("test signature".utf8)
        UserDefaults.standard.set(testData, forKey: "commitmentSignature")
        let newQuizData = OnboardingQuizData()
        
        XCTAssertNotNil(newQuizData.commitmentSignature)
        XCTAssertEqual(newQuizData.commitmentSignature, testData)
    }
    
    // MARK: - Existing Properties Still Work
    
    func testExistingProperties_StillWork() {
        quizData.dedicationLevel = 8
        XCTAssertTrue(quizData.isHighlyDedicated)
        XCTAssertGreaterThan(quizData.potentialScore, 7.0)
    }
    
    func testPotentialScore_WithDedication() {
        quizData.dedicationLevel = 10
        XCTAssertEqual(quizData.potentialScore, 8.5, accuracy: 0.1)
    }
    
    func testPotentialScoreFormatted_ReturnsString() {
        quizData.dedicationLevel = 8
        let formatted = quizData.potentialScoreFormatted
        XCTAssertFalse(formatted.isEmpty)
        XCTAssertTrue(formatted.contains("."))
    }
}
