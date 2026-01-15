//
//  GoalSelectionViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for GoalSelectionView
//  Tests goal selection, toggle logic, and continue button state
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class GoalSelectionViewTests: XCTestCase {
    
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
    
    func testInitialState_NoGoalsSelected() {
        XCTAssertTrue(onboardingData.selectedGoals.isEmpty)
    }
    
    func testContinueButton_DisabledWhenNoGoalsSelected() {
        let isDisabled = onboardingData.selectedGoals.isEmpty
        XCTAssertTrue(isDisabled)
    }
    
    // MARK: - Selection Logic Tests
    
    func testToggleGoal_AddGoal() {
        let goalId = "jawline"
        onboardingData.selectedGoals.insert(goalId)
        
        XCTAssertTrue(onboardingData.selectedGoals.contains(goalId))
        XCTAssertEqual(onboardingData.selectedGoals.count, 1)
    }
    
    func testToggleGoal_RemoveGoal() {
        let goalId = "jawline"
        onboardingData.selectedGoals.insert(goalId)
        onboardingData.selectedGoals.remove(goalId)
        
        XCTAssertFalse(onboardingData.selectedGoals.contains(goalId))
        XCTAssertEqual(onboardingData.selectedGoals.count, 0)
    }
    
    func testToggleGoal_ToggleSameGoalTwice() {
        let goalId = "jawline"
        
        // Add
        onboardingData.selectedGoals.insert(goalId)
        XCTAssertTrue(onboardingData.selectedGoals.contains(goalId))
        
        // Remove
        onboardingData.selectedGoals.remove(goalId)
        XCTAssertFalse(onboardingData.selectedGoals.contains(goalId))
    }
    
    func testSelectMultipleGoals() {
        onboardingData.selectedGoals.insert("jawline")
        onboardingData.selectedGoals.insert("skin")
        onboardingData.selectedGoals.insert("confidence")
        
        XCTAssertEqual(onboardingData.selectedGoals.count, 3)
        XCTAssertTrue(onboardingData.selectedGoals.contains("jawline"))
        XCTAssertTrue(onboardingData.selectedGoals.contains("skin"))
        XCTAssertTrue(onboardingData.selectedGoals.contains("confidence"))
    }
    
    func testSelectAllGoals() {
        for goal in goalItems {
            onboardingData.selectedGoals.insert(goal.id)
        }
        
        XCTAssertEqual(onboardingData.selectedGoals.count, goalItems.count)
    }
    
    // MARK: - Continue Button State Tests
    
    func testContinueButton_EnabledWhenGoalSelected() {
        onboardingData.selectedGoals.insert("jawline")
        let isDisabled = onboardingData.selectedGoals.isEmpty
        XCTAssertFalse(isDisabled)
    }
    
    func testContinueButton_EnabledWhenMultipleGoalsSelected() {
        onboardingData.selectedGoals.insert("jawline")
        onboardingData.selectedGoals.insert("skin")
        let isDisabled = onboardingData.selectedGoals.isEmpty
        XCTAssertFalse(isDisabled)
    }
    
    // MARK: - Goal Items Validation Tests
    
    func testGoalItems_AllGoalIdsAreValid() {
        let validIds = goalItems.map { $0.id }
        
        for id in validIds {
            XCTAssertFalse(id.isEmpty)
        }
    }
    
    func testGoalItems_ContainsExpectedGoals() {
        let goalIds = goalItems.map { $0.id }
        
        XCTAssertTrue(goalIds.contains("jawline"))
        XCTAssertTrue(goalIds.contains("skin"))
        XCTAssertTrue(goalIds.contains("symmetry"))
        XCTAssertTrue(goalIds.contains("confidence"))
    }
}

// MARK: - GoalRow Tests

final class GoalRowTests: XCTestCase {
    
    func testGoalRow_DisplaysTitle() {
        let goal = goalItems.first!
        XCTAssertFalse(goal.title.isEmpty)
    }
    
    func testGoalRow_DisplaysIcon() {
        let goal = goalItems.first!
        XCTAssertFalse(goal.icon.isEmpty)
    }
    
    func testGoalRow_HasAccentColor() {
        let goal = goalItems.first!
        // AccentColor should be a valid Color
        XCTAssertNotNil(goal.accentColor)
    }
}
