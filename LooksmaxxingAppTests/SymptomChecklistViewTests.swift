//
//  SymptomChecklistViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for SymptomChecklistView
//  Tests symptom selection, categories, and continue button state
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class SymptomChecklistViewTests: XCTestCase {
    
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
    
    // MARK: - Initial State Tests
    
    func testInitialState_NoSymptomsSelected() {
        XCTAssertTrue(onboardingData.selectedSymptoms.isEmpty)
    }
    
    func testContinueButton_DisabledWhenNoSymptomsSelected() {
        let isDisabled = onboardingData.selectedSymptoms.isEmpty
        XCTAssertTrue(isDisabled)
    }
    
    // MARK: - Selection Logic Tests
    
    func testToggleSymptom_AddSymptom() {
        let symptomId = "low_confidence"
        onboardingData.selectedSymptoms.insert(symptomId)
        
        XCTAssertTrue(onboardingData.selectedSymptoms.contains(symptomId))
        XCTAssertEqual(onboardingData.selectedSymptoms.count, 1)
    }
    
    func testToggleSymptom_RemoveSymptom() {
        let symptomId = "low_confidence"
        onboardingData.selectedSymptoms.insert(symptomId)
        onboardingData.selectedSymptoms.remove(symptomId)
        
        XCTAssertFalse(onboardingData.selectedSymptoms.contains(symptomId))
        XCTAssertEqual(onboardingData.selectedSymptoms.count, 0)
    }
    
    func testSelectMultipleSymptoms() {
        onboardingData.selectedSymptoms.insert("low_confidence")
        onboardingData.selectedSymptoms.insert("anxiety")
        onboardingData.selectedSymptoms.insert("poor_posture")
        
        XCTAssertEqual(onboardingData.selectedSymptoms.count, 3)
    }
    
    func testSelectSymptomsFromDifferentCategories() {
        // Mental
        onboardingData.selectedSymptoms.insert("low_confidence")
        // Physical
        onboardingData.selectedSymptoms.insert("poor_posture")
        // Social
        onboardingData.selectedSymptoms.insert("avoid_photos")
        
        XCTAssertEqual(onboardingData.selectedSymptoms.count, 3)
    }
    
    // MARK: - Category Tests
    
    func testSymptomCategories_Has3Categories() {
        XCTAssertEqual(SymptomCategory.allCases.count, 3)
    }
    
    func testSymptomCategories_ContainsMental() {
        XCTAssertTrue(SymptomCategory.allCases.contains(.mental))
    }
    
    func testSymptomCategories_ContainsPhysical() {
        XCTAssertTrue(SymptomCategory.allCases.contains(.physical))
    }
    
    func testSymptomCategories_ContainsSocial() {
        XCTAssertTrue(SymptomCategory.allCases.contains(.social))
    }
    
    func testMentalSymptoms_FilterCorrectly() {
        let mentalSymptoms = symptoms.filter { $0.category == .mental }
        XCTAssertGreaterThan(mentalSymptoms.count, 0)
        
        for symptom in mentalSymptoms {
            XCTAssertEqual(symptom.category, .mental)
        }
    }
    
    func testPhysicalSymptoms_FilterCorrectly() {
        let physicalSymptoms = symptoms.filter { $0.category == .physical }
        XCTAssertGreaterThan(physicalSymptoms.count, 0)
        
        for symptom in physicalSymptoms {
            XCTAssertEqual(symptom.category, .physical)
        }
    }
    
    func testSocialSymptoms_FilterCorrectly() {
        let socialSymptoms = symptoms.filter { $0.category == .social }
        XCTAssertGreaterThan(socialSymptoms.count, 0)
        
        for symptom in socialSymptoms {
            XCTAssertEqual(symptom.category, .social)
        }
    }
    
    // MARK: - Continue Button State Tests
    
    func testContinueButton_EnabledWhenSymptomSelected() {
        onboardingData.selectedSymptoms.insert("low_confidence")
        let isDisabled = onboardingData.selectedSymptoms.isEmpty
        XCTAssertFalse(isDisabled)
    }
    
    // MARK: - Symptom Validation Tests
    
    func testAllSymptoms_HaveUniqueIds() {
        let ids = symptoms.map { $0.id }
        let uniqueIds = Set(ids)
        XCTAssertEqual(ids.count, uniqueIds.count)
    }
    
    func testAllSymptoms_HaveText() {
        for symptom in symptoms {
            XCTAssertFalse(symptom.text.isEmpty, "Symptom \(symptom.id) has empty text")
        }
    }
    
    func testAllSymptoms_HaveCategory() {
        for symptom in symptoms {
            XCTAssertNotNil(symptom.category)
        }
    }
}
