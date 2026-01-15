//
//  OnboardingDataTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for OnboardingData model
//  Tests score calculation, data storage, and computed properties
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class OnboardingDataTests: XCTestCase {
    
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
    
    func testInitialState() {
        XCTAssertEqual(onboardingData.userName, "")
        XCTAssertEqual(onboardingData.userAge, "")
        XCTAssertEqual(onboardingData.primaryGoal, "")
        XCTAssertEqual(onboardingData.userScore, 0)
        XCTAssertTrue(onboardingData.selectedSymptoms.isEmpty)
        XCTAssertTrue(onboardingData.selectedGoals.isEmpty)
        XCTAssertFalse(onboardingData.hasSignedCommitment)
    }
    
    // MARK: - Score Calculation Tests
    
    func testCalculateScore_BaseScore() {
        onboardingData.calculateScore()
        XCTAssertGreaterThanOrEqual(onboardingData.userScore, 20)
    }
    
    func testCalculateScore_HighFrequency_AddsPoints() {
        onboardingData.checkFrequency = "Multiple times daily"
        onboardingData.calculateScore()
        XCTAssertGreaterThanOrEqual(onboardingData.userScore, 35) // 20 base + 15
    }
    
    func testCalculateScore_DailyFrequency_AddsPoints() {
        onboardingData.checkFrequency = "Daily"
        onboardingData.calculateScore()
        XCTAssertGreaterThanOrEqual(onboardingData.userScore, 30) // 20 base + 10
    }
    
    func testCalculateScore_WeeklyFrequency_AddsPoints() {
        onboardingData.checkFrequency = "Weekly"
        onboardingData.calculateScore()
        XCTAssertGreaterThanOrEqual(onboardingData.userScore, 25) // 20 base + 5
    }
    
    func testCalculateScore_HasGottenWorse_AddsPoints() {
        onboardingData.hasGottenWorse = true
        onboardingData.calculateScore()
        XCTAssertGreaterThanOrEqual(onboardingData.userScore, 30) // 20 base + 10
    }
    
    func testCalculateScore_PhotoAvoidanceAlways_AddsPoints() {
        onboardingData.photoAvoidance = "Always"
        onboardingData.calculateScore()
        XCTAssertGreaterThanOrEqual(onboardingData.userScore, 32) // 20 base + 12
    }
    
    func testCalculateScore_PhotoAvoidanceSometimes_AddsPoints() {
        onboardingData.photoAvoidance = "Sometimes"
        onboardingData.calculateScore()
        XCTAssertGreaterThanOrEqual(onboardingData.userScore, 28) // 20 base + 8
    }
    
    func testCalculateScore_StressMirrorCheckFrequently_AddsPoints() {
        onboardingData.stressMirrorCheck = "Frequently"
        onboardingData.calculateScore()
        XCTAssertGreaterThanOrEqual(onboardingData.userScore, 30) // 20 base + 10
    }
    
    func testCalculateScore_SocialMediaTrigger_AddsPoints() {
        onboardingData.socialMediaTrigger = true
        onboardingData.calculateScore()
        XCTAssertGreaterThanOrEqual(onboardingData.userScore, 28) // 20 base + 8
    }
    
    func testCalculateScore_HasSpentMoney_AddsPoints() {
        onboardingData.hasSpentMoney = true
        onboardingData.calculateScore()
        XCTAssertGreaterThanOrEqual(onboardingData.userScore, 27) // 20 base + 7
    }
    
    func testCalculateScore_MaximumCappedAt85() {
        // Set all high-scoring options
        onboardingData.checkFrequency = "Multiple times daily"
        onboardingData.hasGottenWorse = true
        onboardingData.photoAvoidance = "Always"
        onboardingData.stressMirrorCheck = "Frequently"
        onboardingData.socialMediaTrigger = true
        onboardingData.hasSpentMoney = true
        
        onboardingData.calculateScore()
        XCTAssertLessThanOrEqual(onboardingData.userScore, 85)
    }
    
    // MARK: - Computed Properties Tests
    
    func testScoreDifference() {
        onboardingData.userScore = 50
        onboardingData.averageScore = 13
        XCTAssertEqual(onboardingData.scoreDifference, 37)
    }
    
    func testTransformationDate_Is60DaysFromNow() {
        let expectedDate = Calendar.current.date(byAdding: .day, value: 60, to: Date())!
        let transformationDate = onboardingData.transformationDate
        
        let calendar = Calendar.current
        let expectedComponents = calendar.dateComponents([.year, .month, .day], from: expectedDate)
        let actualComponents = calendar.dateComponents([.year, .month, .day], from: transformationDate)
        
        XCTAssertEqual(expectedComponents.year, actualComponents.year)
        XCTAssertEqual(expectedComponents.month, actualComponents.month)
        XCTAssertEqual(expectedComponents.day, actualComponents.day)
    }
    
    func testFormattedTransformationDate_HasCorrectFormat() {
        let formattedDate = onboardingData.formattedTransformationDate
        // Should be in "MMM d, yyyy" format (e.g., "Mar 15, 2026")
        XCTAssertTrue(formattedDate.contains(","))
        XCTAssertGreaterThan(formattedDate.count, 8)
    }
    
    func testTodayFormatted_HasCorrectFormat() {
        let today = onboardingData.todayFormatted
        // Should be in "MM/dd" format (e.g., "01/15")
        XCTAssertTrue(today.contains("/"))
        XCTAssertEqual(today.count, 5)
    }
    
    // MARK: - Symptom Selection Tests
    
    func testSymptomSelection_AddSymptom() {
        onboardingData.selectedSymptoms.insert("low_confidence")
        XCTAssertTrue(onboardingData.selectedSymptoms.contains("low_confidence"))
        XCTAssertEqual(onboardingData.selectedSymptoms.count, 1)
    }
    
    func testSymptomSelection_RemoveSymptom() {
        onboardingData.selectedSymptoms.insert("low_confidence")
        onboardingData.selectedSymptoms.insert("anxiety")
        onboardingData.selectedSymptoms.remove("low_confidence")
        
        XCTAssertFalse(onboardingData.selectedSymptoms.contains("low_confidence"))
        XCTAssertTrue(onboardingData.selectedSymptoms.contains("anxiety"))
        XCTAssertEqual(onboardingData.selectedSymptoms.count, 1)
    }
    
    func testSymptomSelection_MultipleSymptoms() {
        onboardingData.selectedSymptoms.insert("low_confidence")
        onboardingData.selectedSymptoms.insert("poor_posture")
        onboardingData.selectedSymptoms.insert("avoid_photos")
        
        XCTAssertEqual(onboardingData.selectedSymptoms.count, 3)
    }
    
    // MARK: - Goal Selection Tests
    
    func testGoalSelection_AddGoal() {
        onboardingData.selectedGoals.insert("jawline")
        XCTAssertTrue(onboardingData.selectedGoals.contains("jawline"))
        XCTAssertEqual(onboardingData.selectedGoals.count, 1)
    }
    
    func testGoalSelection_RemoveGoal() {
        onboardingData.selectedGoals.insert("jawline")
        onboardingData.selectedGoals.insert("skin")
        onboardingData.selectedGoals.remove("jawline")
        
        XCTAssertFalse(onboardingData.selectedGoals.contains("jawline"))
        XCTAssertTrue(onboardingData.selectedGoals.contains("skin"))
    }
    
    func testGoalSelection_MultipleGoals() {
        onboardingData.selectedGoals.insert("jawline")
        onboardingData.selectedGoals.insert("skin")
        onboardingData.selectedGoals.insert("confidence")
        
        XCTAssertEqual(onboardingData.selectedGoals.count, 3)
    }
    
    // MARK: - Reset Tests
    
    func testReset_ClearsAllData() {
        // Set up some data
        onboardingData.userName = "Test"
        onboardingData.userAge = "25"
        onboardingData.primaryGoal = "Define my jawline"
        onboardingData.userScore = 50
        onboardingData.selectedSymptoms.insert("anxiety")
        onboardingData.selectedGoals.insert("jawline")
        onboardingData.hasSignedCommitment = true
        
        // Reset
        onboardingData.reset()
        
        // Verify all cleared
        XCTAssertEqual(onboardingData.userName, "")
        XCTAssertEqual(onboardingData.userAge, "")
        XCTAssertEqual(onboardingData.primaryGoal, "")
        XCTAssertEqual(onboardingData.userScore, 0)
        XCTAssertTrue(onboardingData.selectedSymptoms.isEmpty)
        XCTAssertTrue(onboardingData.selectedGoals.isEmpty)
        XCTAssertFalse(onboardingData.hasSignedCommitment)
    }
}

// MARK: - Quiz Questions Tests

final class QuizQuestionsTests: XCTestCase {
    
    func testQuizQuestions_Has10Questions() {
        XCTAssertEqual(quizQuestions.count, 10)
    }
    
    func testQuizQuestions_AllHaveOptions() {
        for question in quizQuestions {
            XCTAssertGreaterThan(question.options.count, 0, "Question \(question.id) has no options")
        }
    }
    
    func testQuizQuestions_YesNoQuestionsHave2Options() {
        let yesNoQuestions = quizQuestions.filter { $0.isYesNo }
        for question in yesNoQuestions {
            XCTAssertEqual(question.options.count, 2, "Yes/No question \(question.id) should have 2 options")
        }
    }
    
    func testQuizQuestions_AllHaveUniqueIds() {
        let ids = quizQuestions.map { $0.id }
        let uniqueIds = Set(ids)
        XCTAssertEqual(ids.count, uniqueIds.count, "Question IDs are not unique")
    }
}

// MARK: - Symptom Model Tests

final class SymptomModelTests: XCTestCase {
    
    func testSymptoms_Has14Symptoms() {
        XCTAssertEqual(symptoms.count, 14)
    }
    
    func testSymptoms_HasAllCategories() {
        let categories = Set(symptoms.map { $0.category })
        XCTAssertEqual(categories.count, 3)
        XCTAssertTrue(categories.contains(.mental))
        XCTAssertTrue(categories.contains(.physical))
        XCTAssertTrue(categories.contains(.social))
    }
    
    func testSymptoms_MentalCategoryCount() {
        let mentalSymptoms = symptoms.filter { $0.category == .mental }
        XCTAssertEqual(mentalSymptoms.count, 5)
    }
    
    func testSymptoms_PhysicalCategoryCount() {
        let physicalSymptoms = symptoms.filter { $0.category == .physical }
        XCTAssertEqual(physicalSymptoms.count, 5)
    }
    
    func testSymptoms_SocialCategoryCount() {
        let socialSymptoms = symptoms.filter { $0.category == .social }
        XCTAssertEqual(socialSymptoms.count, 4)
    }
    
    func testSymptoms_AllHaveUniqueIds() {
        let ids = symptoms.map { $0.id }
        let uniqueIds = Set(ids)
        XCTAssertEqual(ids.count, uniqueIds.count, "Symptom IDs are not unique")
    }
}

// MARK: - Goal Items Tests

final class GoalItemsTests: XCTestCase {
    
    func testGoalItems_Has8Goals() {
        XCTAssertEqual(goalItems.count, 8)
    }
    
    func testGoalItems_AllHaveUniqueIds() {
        let ids = goalItems.map { $0.id }
        let uniqueIds = Set(ids)
        XCTAssertEqual(ids.count, uniqueIds.count, "Goal IDs are not unique")
    }
    
    func testGoalItems_AllHaveTitles() {
        for goal in goalItems {
            XCTAssertFalse(goal.title.isEmpty, "Goal \(goal.id) has empty title")
        }
    }
    
    func testGoalItems_AllHaveIcons() {
        for goal in goalItems {
            XCTAssertFalse(goal.icon.isEmpty, "Goal \(goal.id) has empty icon")
        }
    }
}

// MARK: - Testimonial Tests

final class TestimonialTests: XCTestCase {
    
    func testTestimonials_Has8Testimonials() {
        XCTAssertEqual(testimonials.count, 8)
    }
    
    func testTestimonials_AllHaveText() {
        for testimonial in testimonials {
            XCTAssertFalse(testimonial.text.isEmpty, "\(testimonial.name) has empty text")
        }
    }
    
    func testTestimonials_AllHaveRating() {
        for testimonial in testimonials {
            XCTAssertGreaterThan(testimonial.rating, 0)
            XCTAssertLessThanOrEqual(testimonial.rating, 5)
        }
    }
}

// MARK: - Problem Slides Tests

final class ProblemSlidesTests: XCTestCase {
    
    func testProblemSlides_Has5Slides() {
        XCTAssertEqual(problemSlides.count, 5)
    }
    
    func testProblemSlides_LastSlideIsRecovery() {
        let lastSlide = problemSlides.last
        XCTAssertNotNil(lastSlide)
        XCTAssertTrue(lastSlide!.isRecovery)
    }
    
    func testProblemSlides_AllHaveIcons() {
        for slide in problemSlides {
            XCTAssertFalse(slide.icon.isEmpty, "Slide \(slide.id) has empty icon")
        }
    }
}

// MARK: - Feature Value Props Tests

final class FeatureValuePropsTests: XCTestCase {
    
    func testFeatureValueProps_Has4Features() {
        XCTAssertEqual(featureValueProps.count, 4)
    }
    
    func testFeatureValueProps_AllHaveDescriptions() {
        for prop in featureValueProps {
            XCTAssertFalse(prop.description.isEmpty, "Feature \(prop.id) has empty description")
        }
    }
}
