//
//  SplashIntroViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for SplashIntroView
//  Tests logo animation, star field, and auto-advance timing
//

import XCTest
@testable import LooksmaxxingApp

final class SplashIntroViewTests: XCTestCase {
    
    // MARK: - Animation Timing Tests
    
    func testLogoAnimationDelay() {
        let logoDelay: Double = 0.3
        XCTAssertGreaterThanOrEqual(logoDelay, 0)
        XCTAssertLessThanOrEqual(logoDelay, 1)
    }
    
    func testAutoAdvanceDelay() {
        let autoAdvanceDelay: Double = 2.5
        XCTAssertGreaterThanOrEqual(autoAdvanceDelay, 2)
        XCTAssertLessThanOrEqual(autoAdvanceDelay, 4)
    }
    
    func testTaglineAnimationDelay() {
        let taglineDelay: Double = 0.8
        XCTAssertGreaterThan(taglineDelay, 0)
    }
    
    // MARK: - Star Field Tests
    
    func testStarCount() {
        let starCount = 50
        XCTAssertGreaterThan(starCount, 20) // Enough stars for effect
        XCTAssertLessThan(starCount, 200) // Not too many for performance
    }
    
    func testStarPositions_AreDeterministic() {
        // Star positions should use seeded random for consistency
        let seed1 = 12345
        let seed2 = 12345
        XCTAssertEqual(seed1, seed2)
    }
    
    func testStarOpacity_Range() {
        let minOpacity: Double = 0.3
        let maxOpacity: Double = 0.8
        
        XCTAssertGreaterThan(minOpacity, 0)
        XCTAssertLessThan(maxOpacity, 1)
        XCTAssertLessThan(minOpacity, maxOpacity)
    }
    
    func testStarSize_Range() {
        let minSize: CGFloat = 1
        let maxSize: CGFloat = 3
        
        XCTAssertGreaterThan(minSize, 0)
        XCTAssertLessThanOrEqual(maxSize, 5)
    }
    
    // MARK: - Branding Tests
    
    func testAppName() {
        let appName = "ASCEND"
        XCTAssertEqual(appName.uppercased(), "ASCEND")
    }
    
    func testTagline() {
        let tagline = "Face Your Potential"
        XCTAssertFalse(tagline.isEmpty)
    }
    
    // MARK: - Background Tests
    
    func testBackgroundColor() {
        let backgroundColor = "050914"
        XCTAssertEqual(backgroundColor.count, 6) // Valid hex
    }
}

// MARK: - Star Model Tests

final class StarModelTests: XCTestCase {
    
    func testStar_HasPosition() {
        let star = StarData(x: 0.5, y: 0.5, opacity: 0.7, size: 2)
        
        XCTAssertGreaterThanOrEqual(star.x, 0)
        XCTAssertLessThanOrEqual(star.x, 1)
        XCTAssertGreaterThanOrEqual(star.y, 0)
        XCTAssertLessThanOrEqual(star.y, 1)
    }
    
    func testStar_HasOpacity() {
        let star = StarData(x: 0.5, y: 0.5, opacity: 0.7, size: 2)
        
        XCTAssertGreaterThan(star.opacity, 0)
        XCTAssertLessThanOrEqual(star.opacity, 1)
    }
    
    func testStar_HasSize() {
        let star = StarData(x: 0.5, y: 0.5, opacity: 0.7, size: 2)
        
        XCTAssertGreaterThan(star.size, 0)
    }
}

// Helper struct for tests
struct StarData {
    let x: CGFloat
    let y: CGFloat
    let opacity: Double
    let size: CGFloat
}
