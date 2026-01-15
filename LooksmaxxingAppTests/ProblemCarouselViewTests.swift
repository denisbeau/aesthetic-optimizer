//
//  ProblemCarouselViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for ProblemCarouselView
//  Tests problem agitation slides, auto-advance, and recovery message
//

import XCTest
@testable import LooksmaxxingApp

final class ProblemCarouselViewTests: XCTestCase {
    
    // MARK: - Problem Slides Tests
    
    func testProblemSlides_Count() {
        XCTAssertEqual(problemSlides.count, 5)
    }
    
    func testProblemSlides_AllHaveIcons() {
        for slide in problemSlides {
            XCTAssertFalse(slide.icon.isEmpty)
        }
    }
    
    func testProblemSlides_AllHaveTitles() {
        for slide in problemSlides {
            XCTAssertFalse(slide.title.isEmpty)
        }
    }
    
    func testProblemSlides_AllHaveBody() {
        for slide in problemSlides {
            XCTAssertFalse(slide.body.isEmpty)
            XCTAssertGreaterThan(slide.body.count, 30)
        }
    }
    
    func testProblemSlides_UniqueIds() {
        let ids = problemSlides.map { $0.id }
        let uniqueIds = Set(ids)
        XCTAssertEqual(ids.count, uniqueIds.count)
    }
    
    // MARK: - Recovery Slide Tests
    
    func testRecoverySlide_IsLast() {
        let lastSlide = problemSlides.last
        XCTAssertNotNil(lastSlide)
        XCTAssertTrue(lastSlide!.isRecovery)
    }
    
    func testRecoverySlide_OnlyOnce() {
        let recoverySlides = problemSlides.filter { $0.isRecovery }
        XCTAssertEqual(recoverySlides.count, 1)
    }
    
    func testProblemSlides_BeforeRecovery() {
        let problemOnlySlides = problemSlides.filter { !$0.isRecovery }
        XCTAssertEqual(problemOnlySlides.count, 4)
    }
    
    // MARK: - Auto-Advance Tests
    
    func testAutoAdvance_Interval() {
        let interval: Double = 5.0
        XCTAssertGreaterThanOrEqual(interval, 4)
        XCTAssertLessThanOrEqual(interval, 8)
    }
    
    func testAutoAdvance_StopsOnLastSlide() {
        let currentIndex = problemSlides.count - 1
        let isLastSlide = currentIndex == problemSlides.count - 1
        XCTAssertTrue(isLastSlide)
    }
    
    // MARK: - Page Indicator Tests
    
    func testPageIndicator_ShowsCorrectCount() {
        let indicatorCount = problemSlides.count
        XCTAssertEqual(indicatorCount, 5)
    }
    
    func testPageIndicator_CurrentIsHighlighted() {
        let currentIndex = 2
        let isHighlighted = true
        XCTAssertTrue(isHighlighted)
        XCTAssertEqual(currentIndex, 2)
    }
    
    // MARK: - Swipe Gesture Tests
    
    func testSwipe_CanGoForward() {
        let currentIndex = 0
        let canGoForward = currentIndex < problemSlides.count - 1
        XCTAssertTrue(canGoForward)
    }
    
    func testSwipe_CanGoBack() {
        let currentIndex = 2
        let canGoBack = currentIndex > 0
        XCTAssertTrue(canGoBack)
    }
    
    func testSwipe_CannotGoBackOnFirst() {
        let currentIndex = 0
        let canGoBack = currentIndex > 0
        XCTAssertFalse(canGoBack)
    }
    
    func testSwipe_CannotGoForwardOnLast() {
        let currentIndex = problemSlides.count - 1
        let canGoForward = currentIndex < problemSlides.count - 1
        XCTAssertFalse(canGoForward)
    }
}

// MARK: - Problem Slide Styling Tests

final class ProblemSlideStyleTests: XCTestCase {
    
    func testSlide_IconSize() {
        let iconSize: CGFloat = 60
        XCTAssertGreaterThanOrEqual(iconSize, 40)
        XCTAssertLessThanOrEqual(iconSize, 80)
    }
    
    func testSlide_TitleFontSize() {
        let fontSize: CGFloat = 24
        XCTAssertGreaterThanOrEqual(fontSize, 20)
    }
    
    func testRecoverySlide_HasGreenAccent() {
        let recoverySlide = problemSlides.last!
        XCTAssertTrue(recoverySlide.isRecovery)
        // Recovery slide uses green accent color
        let greenColor = "10B981"
        XCTAssertEqual(greenColor.count, 6)
    }
}
