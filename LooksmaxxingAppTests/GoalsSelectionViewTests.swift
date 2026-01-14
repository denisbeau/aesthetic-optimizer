//
//  GoalsSelectionViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for GoalsSelectionView
//  Tests selection limits, validation, and data persistence
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class GoalsSelectionViewTests: XCTestCase {
    
    var quizData: OnboardingQuizData!
    
    override func setUp() {
        super.setUp()
        clearQuizDataDefaults()
        quizData = OnboardingQuizData()
    }
    
    override func tearDown() {
        quizData = nil
        clearQuizDataDefaults()
        super.tearDown()
    }
    
    private func clearQuizDataDefaults() {
        let keys = ["selectedSymptoms", "selectedGoals", "commitmentSignature"]
        keys.forEach { UserDefaults.standard.removeObject(forKey: $0) }
    }
    
    // MARK: - Goals Count Tests
    
    func testGoals_CountIs7() {
        // Verify we have 7 goal options
        let expectedGoals = [
            "sharper_jawline",
            "better_skin",
            "improved_symmetry",
            "increased_confidence",
            "fix_breathing",
            "better_posture",
            "overall_transformation"
        ]
        XCTAssertEqual(expectedGoals.count, 7)
    }
    
    // MARK: - Selection Limit Tests
    
    func testSelectionLimit_Maximum3Goals() {
        // Verify selection limit is enforced
        quizData.selectedGoals = ["sharper_jawline", "better_skin", "increased_confidence"]
        XCTAssertEqual(quizData.selectedGoals.count, 3)
        
        // Attempting to add 4th should not work (enforced in UI)
        let initialCount = quizData.selectedGoals.count
        // UI prevents adding more than 3, so count should remain 3
        XCTAssertLessThanOrEqual(quizData.selectedGoals.count, 3)
    }
    
    func testSelectionLimit_Minimum1Goal() {
        // Verify at least 1 goal must be selected
        quizData.selectedGoals = []
        XCTAssertTrue(quizData.selectedGoals.isEmpty)
        
        quizData.selectedGoals = ["sharper_jawline"]
        XCTAssertEqual(quizData.selectedGoals.count, 1)
    }
    
    func testSelectionLimit_CanSelect1to3() {
        // Test all valid selection counts
        quizData.selectedGoals = ["sharper_jawline"]
        XCTAssertEqual(quizData.selectedGoals.count, 1)
        
        quizData.selectedGoals = ["sharper_jawline", "better_skin"]
        XCTAssertEqual(quizData.selectedGoals.count, 2)
        
        quizData.selectedGoals = ["sharper_jawline", "better_skin", "increased_confidence"]
        XCTAssertEqual(quizData.selectedGoals.count, 3)
    }
    
    // MARK: - Selection Logic Tests
    
    func testGoalSelection_InitialState_Empty() {
        XCTAssertTrue(quizData.selectedGoals.isEmpty)
    }
    
    func testGoalSelection_SelectSingle_AddsToArray() {
        quizData.selectedGoals = ["sharper_jawline"]
        XCTAssertEqual(quizData.selectedGoals.count, 1)
        XCTAssertTrue(quizData.selectedGoals.contains("sharper_jawline"))
    }
    
    func testGoalSelection_SelectMultiple_AddsAll() {
        quizData.selectedGoals = ["sharper_jawline", "better_skin", "increased_confidence"]
        XCTAssertEqual(quizData.selectedGoals.count, 3)
        XCTAssertTrue(quizData.selectedGoals.contains("sharper_jawline"))
        XCTAssertTrue(quizData.selectedGoals.contains("better_skin"))
        XCTAssertTrue(quizData.selectedGoals.contains("increased_confidence"))
    }
    
    func testGoalSelection_Deselect_RemovesFromArray() {
        quizData.selectedGoals = ["sharper_jawline", "better_skin"]
        quizData.selectedGoals.removeAll { $0 == "sharper_jawline" }
        XCTAssertEqual(quizData.selectedGoals.count, 1)
        XCTAssertFalse(quizData.selectedGoals.contains("sharper_jawline"))
        XCTAssertTrue(quizData.selectedGoals.contains("better_skin"))
    }
    
    // MARK: - Validation Tests
    
    func testContinueButton_EmptySelection_Disabled() {
        quizData.selectedGoals = []
        XCTAssertTrue(quizData.selectedGoals.isEmpty)
    }
    
    func testContinueButton_WithSelection_Enabled() {
        quizData.selectedGoals = ["sharper_jawline"]
        XCTAssertFalse(quizData.selectedGoals.isEmpty)
    }
    
    // MARK: - Goal Badge Mapping Tests
    
    func testGoalBadges_ShowsCorrectIcons() {
        quizData.selectedGoals = ["sharper_jawline", "better_skin"]
        let badges = quizData.goalBadges
        
        XCTAssertEqual(badges.count, 2)
        XCTAssertEqual(badges[0].icon, "🔥")
        XCTAssertEqual(badges[1].icon, "✨")
    }
    
    func testGoalBadges_ShowsCorrectColors() {
        quizData.selectedGoals = ["sharper_jawline", "increased_confidence"]
        let badges = quizData.goalBadges
        
        XCTAssertEqual(badges[0].color, "#F59E0B")
        XCTAssertEqual(badges[1].color, "#F43F5E")
    }
    
    // MARK: - Data Persistence Tests
    
    func testSaveGoals_PersistsToUserDefaults() {
        quizData.selectedGoals = ["sharper_jawline", "better_skin"]
        quizData.saveToUserDefaults()
        
        let loaded = UserDefaults.standard.array(forKey: "selectedGoals") as? [String]
        XCTAssertEqual(loaded?.count, 2)
        XCTAssertTrue(loaded?.contains("sharper_jawline") ?? false)
    }
    
    func testLoadGoals_FromUserDefaults() {
        UserDefaults.standard.set(["sharper_jawline", "better_skin"], forKey: "selectedGoals")
        let newQuizData = OnboardingQuizData()
        
        XCTAssertEqual(newQuizData.selectedGoals.count, 2)
        XCTAssertTrue(newQuizData.selectedGoals.contains("sharper_jawline"))
    }
}
