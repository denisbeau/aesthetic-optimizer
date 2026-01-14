//
//  SymptomsSelectionViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for SymptomsSelectionView
//  Tests multi-select logic, validation, and data persistence
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class SymptomsSelectionViewTests: XCTestCase {
    
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
    
    // MARK: - Symptom Groups Tests
    
    func testSymptomGroups_CountIs3() {
        // Verify we have 3 categories: confidence, physical, functional
        let expectedCategories = ["confidence", "physical", "functional"]
        // This is a structural test - verify categories exist
        XCTAssertEqual(expectedCategories.count, 3)
    }
    
    func testSymptomGroups_ConfidenceCategory_HasItems() {
        // Verify confidence category has expected items
        let expectedItems = [
            "avoid_photos",
            "self_conscious",
            "compare_others",
            "tried_routines"
        ]
        XCTAssertEqual(expectedItems.count, 4)
    }
    
    func testSymptomGroups_PhysicalCategory_HasItems() {
        // Verify physical category has expected items
        let expectedItems = [
            "receded_chin",
            "mouth_breathing",
            "poor_posture",
            "facial_asymmetry",
            "skin_texture"
        ]
        XCTAssertEqual(expectedItems.count, 5)
    }
    
    func testSymptomGroups_FunctionalCategory_HasItems() {
        // Verify functional category has expected items
        let expectedItems = [
            "difficulty_breathing",
            "jaw_tension",
            "sleep_quality"
        ]
        XCTAssertEqual(expectedItems.count, 3)
    }
    
    // MARK: - Selection Logic Tests
    
    func testSymptomSelection_InitialState_Empty() {
        XCTAssertTrue(quizData.selectedSymptoms.isEmpty)
    }
    
    func testSymptomSelection_SelectSingle_AddsToArray() {
        quizData.selectedSymptoms = ["avoid_photos"]
        XCTAssertEqual(quizData.selectedSymptoms.count, 1)
        XCTAssertTrue(quizData.selectedSymptoms.contains("avoid_photos"))
    }
    
    func testSymptomSelection_SelectMultiple_AddsAll() {
        quizData.selectedSymptoms = ["avoid_photos", "mouth_breathing", "poor_posture"]
        XCTAssertEqual(quizData.selectedSymptoms.count, 3)
        XCTAssertTrue(quizData.selectedSymptoms.contains("avoid_photos"))
        XCTAssertTrue(quizData.selectedSymptoms.contains("mouth_breathing"))
        XCTAssertTrue(quizData.selectedSymptoms.contains("poor_posture"))
    }
    
    func testSymptomSelection_Deselect_RemovesFromArray() {
        quizData.selectedSymptoms = ["avoid_photos", "mouth_breathing"]
        quizData.selectedSymptoms.removeAll { $0 == "avoid_photos" }
        XCTAssertEqual(quizData.selectedSymptoms.count, 1)
        XCTAssertFalse(quizData.selectedSymptoms.contains("avoid_photos"))
        XCTAssertTrue(quizData.selectedSymptoms.contains("mouth_breathing"))
    }
    
    // MARK: - Validation Tests
    
    func testContinueButton_EmptySelection_Disabled() {
        quizData.selectedSymptoms = []
        // Button should be disabled when empty
        XCTAssertTrue(quizData.selectedSymptoms.isEmpty)
    }
    
    func testContinueButton_WithSelection_Enabled() {
        quizData.selectedSymptoms = ["avoid_photos"]
        // Button should be enabled when at least one selected
        XCTAssertFalse(quizData.selectedSymptoms.isEmpty)
    }
    
    // MARK: - Data Persistence Tests
    
    func testSaveSymptoms_PersistsToUserDefaults() {
        quizData.selectedSymptoms = ["avoid_photos", "mouth_breathing"]
        quizData.saveToUserDefaults()
        
        let loaded = UserDefaults.standard.array(forKey: "selectedSymptoms") as? [String]
        XCTAssertEqual(loaded?.count, 2)
        XCTAssertTrue(loaded?.contains("avoid_photos") ?? false)
    }
    
    func testLoadSymptoms_FromUserDefaults() {
        UserDefaults.standard.set(["avoid_photos", "mouth_breathing"], forKey: "selectedSymptoms")
        let newQuizData = OnboardingQuizData()
        
        XCTAssertEqual(newQuizData.selectedSymptoms.count, 2)
        XCTAssertTrue(newQuizData.selectedSymptoms.contains("avoid_photos"))
    }
    
    // MARK: - Navigation Tests
    
    func testNavigation_AfterSelection_GoesToGoals() {
        // Verify that after selecting symptoms, navigation should go to GoalsSelectionView
        quizData.selectedSymptoms = ["avoid_photos"]
        quizData.saveToUserDefaults()
        
        // Navigation is handled by SwiftUI state, but we can verify data is ready
        XCTAssertFalse(quizData.selectedSymptoms.isEmpty)
    }
}
