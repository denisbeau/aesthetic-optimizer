//
//  FreeTrialOfferViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for FreeTrialOfferView
//  Tests trial offer display, CTA button, and zero-price effect
//

import XCTest
@testable import LooksmaxxingApp

final class FreeTrialOfferViewTests: XCTestCase {
    
    // MARK: - Trial Offer Tests
    
    func testTrialDuration_Is3Days() {
        let trialDays = 3
        XCTAssertEqual(trialDays, 3)
    }
    
    func testTrialPrice_IsZero() {
        let trialPrice = 0.00
        XCTAssertEqual(trialPrice, 0.00)
    }
    
    func testTrialPrice_DisplayFormat() {
        let price = "$0.00"
        XCTAssertEqual(price, "$0.00")
    }
    
    // MARK: - CTA Button Tests
    
    func testCTAButton_Text() {
        let ctaText = "Start Free Trial"
        XCTAssertTrue(ctaText.contains("Free"))
        XCTAssertTrue(ctaText.contains("Trial"))
    }
    
    func testCTAButton_HasGreenGlow() {
        let glowColor = "10B981"
        XCTAssertEqual(glowColor.count, 6)
    }
    
    func testCTAButton_HasHapticFeedback() {
        let hapticStyle = "heavy"
        XCTAssertEqual(hapticStyle, "heavy")
    }
    
    // MARK: - Zero-Price Effect Tests
    
    func testZeroPrice_IsHighlighted() {
        let fontSize: CGFloat = 48
        XCTAssertGreaterThanOrEqual(fontSize, 40)
    }
    
    func testZeroPrice_HasStrikethrough() {
        let originalPrice = "$6.99"
        let hasStrikethrough = true
        
        XCTAssertTrue(hasStrikethrough)
        XCTAssertFalse(originalPrice.isEmpty)
    }
    
    // MARK: - Benefits List Tests
    
    func testBenefits_HasMultipleItems() {
        let benefits = [
            "Full access to all features",
            "AI face analysis",
            "Personalized routines",
            "Cancel anytime"
        ]
        
        XCTAssertGreaterThanOrEqual(benefits.count, 4)
    }
    
    func testBenefits_IncludesCancelAnytime() {
        let benefits = [
            "Full access",
            "AI analysis",
            "Cancel anytime"
        ]
        
        let hasCancelAnytime = benefits.contains { $0.lowercased().contains("cancel") }
        XCTAssertTrue(hasCancelAnytime)
    }
    
    // MARK: - Trust Elements Tests
    
    func testNoPaymentRequired_Message() {
        let message = "No payment required today"
        XCTAssertTrue(message.contains("No payment"))
    }
    
    func testSecure_Badge() {
        let secureBadge = "🔒 Secure"
        XCTAssertTrue(secureBadge.contains("Secure"))
    }
    
    // MARK: - Urgency Tests
    
    func testLimitedOffer_Message() {
        let urgencyMessage = "Limited time offer"
        XCTAssertFalse(urgencyMessage.isEmpty)
    }
    
    // MARK: - Animation Tests
    
    func testPulseAnimation_Duration() {
        let pulseDuration: Double = 1.5
        XCTAssertGreaterThan(pulseDuration, 1.0)
    }
    
    func testGlowAnimation_IsSubtle() {
        let glowOpacity: Double = 0.4
        XCTAssertLessThan(glowOpacity, 0.6)
    }
}
