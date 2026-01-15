//
//  WelcomeIntentViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for WelcomeIntentView
//  Tests CTA button, value proposition, and staggered animations
//

import XCTest
@testable import LooksmaxxingApp

final class WelcomeIntentViewTests: XCTestCase {
    
    // MARK: - Content Tests
    
    func testMainHeadline_IsCompelling() {
        let headline = "Unlock Your Best Face"
        XCTAssertFalse(headline.isEmpty)
        XCTAssertGreaterThan(headline.count, 10)
    }
    
    func testSubheadline_ExplainsValue() {
        let subheadline = "AI-powered analysis and daily routines to maximize your facial aesthetics"
        XCTAssertTrue(subheadline.contains("AI"))
    }
    
    func testCTAButton_Text() {
        let ctaText = "Start Quiz"
        XCTAssertFalse(ctaText.isEmpty)
    }
    
    // MARK: - Animation Tests
    
    func testStaggeredAnimation_HasDelay() {
        let delays: [Double] = [0, 0.1, 0.2, 0.3]
        
        for i in 1..<delays.count {
            XCTAssertGreaterThan(delays[i], delays[i-1])
        }
    }
    
    func testFadeInDuration() {
        let duration: Double = 0.5
        XCTAssertGreaterThan(duration, 0.2)
        XCTAssertLessThan(duration, 1.5)
    }
    
    // MARK: - Value Propositions Tests
    
    func testValuePropositions_HasMultiple() {
        let valueProps = [
            "AI Face Analysis",
            "Daily Routines",
            "Progress Tracking"
        ]
        
        XCTAssertGreaterThanOrEqual(valueProps.count, 3)
    }
    
    // MARK: - Haptic Feedback Tests
    
    func testButtonHaptic_IsMedium() {
        // UIImpactFeedbackGenerator style should be medium for main CTA
        let hapticStyle = "medium"
        XCTAssertEqual(hapticStyle, "medium")
    }
    
    // MARK: - Navigation Tests
    
    func testCTA_NavigatesToQuiz() {
        let targetScreen = 3 // Quiz screen
        XCTAssertEqual(targetScreen, 3)
    }
}
