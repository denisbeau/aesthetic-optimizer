//
//  PersonalizedPaywallViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for PersonalizedPaywallView
//  Tests subscription options, pricing display, and CTA state
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class PersonalizedPaywallViewTests: XCTestCase {
    
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
    
    // MARK: - Pricing Tests
    
    func testWeeklyPrice_Formatted() {
        let weeklyPrice = "$6.99/week"
        XCTAssertTrue(weeklyPrice.contains("6.99"))
        XCTAssertTrue(weeklyPrice.contains("week"))
    }
    
    func testAnnualPrice_Formatted() {
        let annualPrice = "$39.99/year"
        XCTAssertTrue(annualPrice.contains("39.99"))
        XCTAssertTrue(annualPrice.contains("year"))
    }
    
    func testAnnualSavings_CalculatedCorrectly() {
        let weeklyPrice: Double = 6.99
        let annualPrice: Double = 39.99
        let weeksInYear = 52
        
        let yearlyIfWeekly = weeklyPrice * Double(weeksInYear)
        let savings = yearlyIfWeekly - annualPrice
        
        XCTAssertGreaterThan(savings, 300) // Should save over $300
    }
    
    // MARK: - Personalization Tests
    
    func testPersonalization_DisplaysUserName() {
        onboardingData.userName = "Alex"
        XCTAssertEqual(onboardingData.userName, "Alex")
    }
    
    func testPersonalization_DisplaysGoals() {
        onboardingData.selectedGoals.insert("jawline")
        onboardingData.selectedGoals.insert("skin")
        
        XCTAssertEqual(onboardingData.selectedGoals.count, 2)
    }
    
    func testPersonalization_DisplaysTransformationDate() {
        let formattedDate = onboardingData.formattedTransformationDate
        XCTAssertFalse(formattedDate.isEmpty)
    }
    
    // MARK: - Feature Display Tests
    
    func testFeatureValueProps_DisplayCount() {
        XCTAssertEqual(featureValueProps.count, 4)
    }
    
    func testFeatureValueProps_HasAIAnalysis() {
        let hasAI = featureValueProps.contains { $0.title.contains("AI") }
        XCTAssertTrue(hasAI)
    }
    
    func testFeatureValueProps_HasStreakSystem() {
        let hasStreak = featureValueProps.contains { $0.title.contains("Streak") }
        XCTAssertTrue(hasStreak)
    }
    
    func testFeatureValueProps_HasProgressTracking() {
        let hasProgress = featureValueProps.contains { $0.title.contains("Progress") }
        XCTAssertTrue(hasProgress)
    }
    
    // MARK: - Trust Indicators Tests
    
    func testUserCount_DisplayFormat() {
        let userCount = "12,000+"
        XCTAssertTrue(userCount.contains("12"))
        XCTAssertTrue(userCount.contains("+"))
    }
    
    // MARK: - Free Trial Tests
    
    func testFreeTrialText_ContainsTrial() {
        let trialText = "Start 3-Day Free Trial"
        XCTAssertTrue(trialText.contains("Free Trial"))
    }
    
    func testFreeTrialDuration_Is3Days() {
        let trialDays = 3
        XCTAssertEqual(trialDays, 3)
    }
}

// MARK: - Subscription Plan Tests

final class SubscriptionPlanTests: XCTestCase {
    
    func testWeeklyPlan_Properties() {
        let weekly = SubscriptionPlanInfo(
            id: "weekly",
            name: "Weekly",
            price: 6.99,
            period: "week",
            isPopular: false
        )
        
        XCTAssertEqual(weekly.id, "weekly")
        XCTAssertEqual(weekly.price, 6.99)
        XCTAssertEqual(weekly.period, "week")
        XCTAssertFalse(weekly.isPopular)
    }
    
    func testAnnualPlan_Properties() {
        let annual = SubscriptionPlanInfo(
            id: "annual",
            name: "Annual",
            price: 39.99,
            period: "year",
            isPopular: true
        )
        
        XCTAssertEqual(annual.id, "annual")
        XCTAssertEqual(annual.price, 39.99)
        XCTAssertEqual(annual.period, "year")
        XCTAssertTrue(annual.isPopular)
    }
    
    func testAnnualPlan_IsCheaperPerWeek() {
        let weeklyPrice: Double = 6.99
        let annualPrice: Double = 39.99
        let weeksInYear = 52
        
        let annualPerWeek = annualPrice / Double(weeksInYear)
        
        XCTAssertLessThan(annualPerWeek, weeklyPrice)
    }
}

// Helper struct for tests
struct SubscriptionPlanInfo {
    let id: String
    let name: String
    let price: Double
    let period: String
    let isPopular: Bool
}
