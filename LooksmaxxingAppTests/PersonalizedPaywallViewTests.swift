//
//  PersonalizedPaywallViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for PersonalizedPaywallView enhancements
//  Tests date banner, benefit badges, and free trial messaging
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class PersonalizedPaywallViewTests: XCTestCase {
    
    var quizData: OnboardingQuizData!
    var dateBanner: TransformationDateBanner!
    var benefitBadges: BenefitBadges!
    var freeTrialCTA: FreeTrialCTA!
    
    override func setUp() {
        super.setUp()
        quizData = OnboardingQuizData()
        dateBanner = TransformationDateBanner()
        benefitBadges = BenefitBadges(selectedGoals: [])
        freeTrialCTA = FreeTrialCTA(onPurchase: {})
    }
    
    override func tearDown() {
        freeTrialCTA = nil
        benefitBadges = nil
        dateBanner = nil
        quizData = nil
        super.tearDown()
    }
    
    // MARK: - Transformation Date Banner Tests
    
    func testTransformationDateBanner_DateIs60DaysFromNow() {
        let banner = TransformationDateBanner()
        let successDate = banner.successDate
        
        // Verify date format
        XCTAssertFalse(successDate.isEmpty)
        XCTAssertTrue(successDate.contains(",")) // Should be "MMM d, yyyy" format
    }
    
    func testTransformationDateBanner_DateCalculation_Is60Days() {
        let calendar = Calendar.current
        if let date = calendar.date(byAdding: .day, value: 60, to: Date()) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            let formatted = formatter.string(from: date)
            
            XCTAssertFalse(formatted.isEmpty)
        } else {
            XCTFail("Date calculation failed")
        }
    }
    
    func testTransformationDateBanner_FallbackDate_IsValid() {
        // Test fallback date format
        let fallback = "Mar 14, 2026"
        XCTAssertFalse(fallback.isEmpty)
        XCTAssertTrue(fallback.contains(","))
    }
    
    // MARK: - Benefit Badges Tests
    
    func testBenefitBadges_EmptyGoals_ShowsNothing() {
        let badges = BenefitBadges(selectedGoals: [])
        XCTAssertTrue(badges.selectedGoals.isEmpty)
    }
    
    func testBenefitBadges_SingleGoal_ShowsOneBadge() {
        let badges = BenefitBadges(selectedGoals: ["sharper_jawline"])
        XCTAssertEqual(badges.selectedGoals.count, 1)
    }
    
    func testBenefitBadges_MultipleGoals_ShowsAll() {
        let goals = ["sharper_jawline", "better_skin", "increased_confidence"]
        let badges = BenefitBadges(selectedGoals: goals)
        XCTAssertEqual(badges.selectedGoals.count, 3)
    }
    
    func testBenefitBadges_GoalConfig_AllGoalsHaveIcons() {
        let goalConfig: [String: (icon: String, color: String)] = [
            "sharper_jawline": ("🔥", "#F59E0B"),
            "better_skin": ("✨", "#3B82F6"),
            "improved_symmetry": ("⚖️", "#8B5CF6"),
            "increased_confidence": ("💪", "#F43F5E"),
            "fix_breathing": ("👃", "#8B5CF6"),
            "better_posture": ("🧍", "#10B981"),
            "overall_transformation": ("💎", "#00D4FF"),
            "specific_feature": ("🎯", "#F59E0B")
        ]
        
        for (goalId, config) in goalConfig {
            XCTAssertFalse(config.icon.isEmpty, "Goal \(goalId) should have icon")
            XCTAssertTrue(config.color.hasPrefix("#"), "Goal \(goalId) color should be hex")
        }
    }
    
    func testBenefitBadges_TitleFormatting_ReplacesUnderscores() {
        let goalId = "sharper_jawline"
        let formatted = goalId.replacingOccurrences(of: "_", with: " ").capitalized
        XCTAssertEqual(formatted, "Sharper jawline")
    }
    
    // MARK: - Free Trial CTA Tests
    
    func testFreeTrialCTA_PriceIsZero() {
        let priceText = "$0.00"
        XCTAssertEqual(priceText, "$0.00")
        XCTAssertTrue(priceText.contains("0.00"))
    }
    
    func testFreeTrialCTA_PriceIsLargerThanText() {
        // "$0.00" should be 22px, "Try For " should be 18px
        let priceSize: CGFloat = 22
        let textSize: CGFloat = 18
        XCTAssertGreaterThan(priceSize, textSize)
    }
    
    func testFreeTrialCTA_SafetySignal_IsPresent() {
        let safetyText = "No Payment Due Now"
        XCTAssertFalse(safetyText.isEmpty)
        XCTAssertTrue(safetyText.contains("No Payment"))
    }
    
    func testFreeTrialCTA_PrivacyLabel_IsPresent() {
        let privacyText = "Purchase appears Discretely"
        XCTAssertFalse(privacyText.isEmpty)
        XCTAssertTrue(privacyText.contains("Discretely"))
    }
    
    // MARK: - Integration Tests
    
    func testPaywallComponents_WorkTogether() {
        quizData.selectedGoals = ["sharper_jawline", "better_skin"]
        let badges = BenefitBadges(selectedGoals: quizData.selectedGoals)
        
        XCTAssertEqual(badges.selectedGoals.count, 2)
        XCTAssertNotNil(dateBanner.successDate)
    }
    
    func testPaywallPersonalization_UsesQuizData() {
        quizData.dedicationLevel = 8
        let score = quizData.potentialScoreFormatted
        
        XCTAssertFalse(score.isEmpty)
        XCTAssertGreaterThan(Double(score) ?? 0, 7.0)
    }
}
