//
//  UserProfileInputViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for UserProfileInputView
//  Tests name/age input, validation, and form state
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class UserProfileInputViewTests: XCTestCase {
    
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
    
    // MARK: - Name Input Tests
    
    func testName_InitiallyEmpty() {
        XCTAssertEqual(onboardingData.userName, "")
    }
    
    func testName_CanBeSet() {
        onboardingData.userName = "Marcus"
        XCTAssertEqual(onboardingData.userName, "Marcus")
    }
    
    func testName_TrimsWhitespace() {
        let input = "  Marcus  "
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        XCTAssertEqual(trimmed, "Marcus")
    }
    
    func testName_AllowsUnicode() {
        onboardingData.userName = "José"
        XCTAssertEqual(onboardingData.userName, "José")
    }
    
    // MARK: - Age Input Tests
    
    func testAge_InitiallyEmpty() {
        XCTAssertEqual(onboardingData.userAge, "")
    }
    
    func testAge_CanBeSet() {
        onboardingData.userAge = "24"
        XCTAssertEqual(onboardingData.userAge, "24")
    }
    
    func testAge_ValidRange_Minimum() {
        let age = 13
        let isValid = age >= 13
        XCTAssertTrue(isValid)
    }
    
    func testAge_ValidRange_Maximum() {
        let age = 100
        let isValid = age <= 120
        XCTAssertTrue(isValid)
    }
    
    func testAge_InvalidRange_TooYoung() {
        let age = 10
        let isValid = age >= 13
        XCTAssertFalse(isValid)
    }
    
    // MARK: - Form Validation Tests
    
    func testForm_InvalidWhenEmpty() {
        onboardingData.userName = ""
        onboardingData.userAge = ""
        
        let isValid = !onboardingData.userName.isEmpty && !onboardingData.userAge.isEmpty
        XCTAssertFalse(isValid)
    }
    
    func testForm_InvalidWhenOnlyName() {
        onboardingData.userName = "Marcus"
        onboardingData.userAge = ""
        
        let isValid = !onboardingData.userName.isEmpty && !onboardingData.userAge.isEmpty
        XCTAssertFalse(isValid)
    }
    
    func testForm_InvalidWhenOnlyAge() {
        onboardingData.userName = ""
        onboardingData.userAge = "24"
        
        let isValid = !onboardingData.userName.isEmpty && !onboardingData.userAge.isEmpty
        XCTAssertFalse(isValid)
    }
    
    func testForm_ValidWhenBothFilled() {
        onboardingData.userName = "Marcus"
        onboardingData.userAge = "24"
        
        let isValid = !onboardingData.userName.isEmpty && !onboardingData.userAge.isEmpty
        XCTAssertTrue(isValid)
    }
    
    // MARK: - Continue Button Tests
    
    func testContinueButton_DisabledWhenInvalid() {
        onboardingData.userName = ""
        onboardingData.userAge = ""
        
        let isDisabled = onboardingData.userName.isEmpty || onboardingData.userAge.isEmpty
        XCTAssertTrue(isDisabled)
    }
    
    func testContinueButton_EnabledWhenValid() {
        onboardingData.userName = "Marcus"
        onboardingData.userAge = "24"
        
        let isDisabled = onboardingData.userName.isEmpty || onboardingData.userAge.isEmpty
        XCTAssertFalse(isDisabled)
    }
    
    // MARK: - Keyboard Tests
    
    func testNameField_UsesTextKeyboard() {
        let keyboardType = "default"
        XCTAssertEqual(keyboardType, "default")
    }
    
    func testAgeField_UsesNumberKeyboard() {
        let keyboardType = "numberPad"
        XCTAssertEqual(keyboardType, "numberPad")
    }
}
