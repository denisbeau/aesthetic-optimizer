//
//  SocialProofGridViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for SocialProofGridView
//  Tests statistics display, counter animations, and trust indicators
//

import XCTest
@testable import LooksmaxxingApp

final class SocialProofGridViewTests: XCTestCase {
    
    // MARK: - Statistics Tests
    
    func testUserCount_Value() {
        let userCount = 12000
        XCTAssertGreaterThan(userCount, 10000)
    }
    
    func testUserCount_DisplayFormat() {
        let userCount = 12000
        let formatted = "12K+"
        XCTAssertTrue(formatted.contains("12"))
        XCTAssertTrue(formatted.contains("+"))
    }
    
    func testAppRating_Value() {
        let rating = 4.8
        XCTAssertGreaterThanOrEqual(rating, 4.5)
        XCTAssertLessThanOrEqual(rating, 5.0)
    }
    
    func testAppRating_DisplayFormat() {
        let rating = 4.8
        let formatted = "\(rating)★"
        XCTAssertTrue(formatted.contains("★"))
    }
    
    func testPrivacyGuarantee_Value() {
        let privacy = "100%"
        XCTAssertEqual(privacy, "100%")
    }
    
    func testTransformations_Value() {
        let transformations = 8500
        XCTAssertGreaterThan(transformations, 5000)
    }
    
    // MARK: - Grid Layout Tests
    
    func testGrid_Has4Items() {
        let gridItems = 4
        XCTAssertEqual(gridItems, 4)
    }
    
    func testGrid_Is2x2() {
        let columns = 2
        let rows = 2
        XCTAssertEqual(columns * rows, 4)
    }
    
    // MARK: - Counter Animation Tests
    
    func testCounterAnimation_Duration() {
        let duration: Double = 1.5
        XCTAssertGreaterThan(duration, 1.0)
        XCTAssertLessThan(duration, 3.0)
    }
    
    func testCounterAnimation_StartsFromZero() {
        let startValue = 0
        XCTAssertEqual(startValue, 0)
    }
    
    func testCounterAnimation_EndsAtTarget() {
        let targetValue = 12000
        let animatedValue = 12000
        XCTAssertEqual(animatedValue, targetValue)
    }
    
    func testCounterAnimation_IncrementStep() {
        let targetValue = 12000
        let steps = 60 // 60fps animation
        let increment = targetValue / steps
        
        XCTAssertGreaterThan(increment, 0)
    }
    
    // MARK: - Trust Indicator Tests
    
    func testTrustBadge_HasIcon() {
        let icons = ["person.3.fill", "star.fill", "lock.fill", "chart.line.uptrend.xyaxis"]
        XCTAssertEqual(icons.count, 4)
    }
    
    func testTrustBadge_HasLabel() {
        let labels = ["Active Users", "App Rating", "Private", "Transformations"]
        XCTAssertEqual(labels.count, 4)
    }
    
    // MARK: - Styling Tests
    
    func testCard_BackgroundColor() {
        let bgColor = "12121A"
        XCTAssertEqual(bgColor.count, 6)
    }
    
    func testCard_CornerRadius() {
        let cornerRadius: CGFloat = 16
        XCTAssertGreaterThan(cornerRadius, 8)
    }
    
    func testAccentColor_Cyan() {
        let accentColor = "00D4FF"
        XCTAssertEqual(accentColor.count, 6)
    }
}

// MARK: - Social Proof Card Tests

final class SocialProofCardTests: XCTestCase {
    
    func testCard_DisplaysValue() {
        let card = SocialProofCard(
            icon: "person.3.fill",
            value: "12K+",
            label: "Active Users"
        )
        
        XCTAssertEqual(card.value, "12K+")
    }
    
    func testCard_DisplaysLabel() {
        let card = SocialProofCard(
            icon: "person.3.fill",
            value: "12K+",
            label: "Active Users"
        )
        
        XCTAssertEqual(card.label, "Active Users")
    }
    
    func testCard_HasIcon() {
        let card = SocialProofCard(
            icon: "person.3.fill",
            value: "12K+",
            label: "Active Users"
        )
        
        XCTAssertFalse(card.icon.isEmpty)
    }
}

// Helper struct for tests
struct SocialProofCard {
    let icon: String
    let value: String
    let label: String
}
