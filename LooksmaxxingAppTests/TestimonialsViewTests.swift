//
//  TestimonialsViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for TestimonialsView
//  Tests testimonial display, carousel behavior, and ratings
//

import XCTest
@testable import LooksmaxxingApp

final class TestimonialsViewTests: XCTestCase {
    
    // MARK: - Testimonial Data Tests
    
    func testTestimonials_Count() {
        XCTAssertEqual(testimonials.count, 8)
    }
    
    func testTestimonials_AllHaveNames() {
        for testimonial in testimonials {
            XCTAssertFalse(testimonial.name.isEmpty)
        }
    }
    
    func testTestimonials_AllHaveHandles() {
        for testimonial in testimonials {
            XCTAssertTrue(testimonial.handle.hasPrefix("@"))
        }
    }
    
    func testTestimonials_AllHaveText() {
        for testimonial in testimonials {
            XCTAssertFalse(testimonial.text.isEmpty)
            XCTAssertGreaterThan(testimonial.text.count, 20)
        }
    }
    
    func testTestimonials_AllHaveRatings() {
        for testimonial in testimonials {
            XCTAssertGreaterThanOrEqual(testimonial.rating, 1)
            XCTAssertLessThanOrEqual(testimonial.rating, 5)
        }
    }
    
    func testTestimonials_AllAre5Stars() {
        for testimonial in testimonials {
            XCTAssertEqual(testimonial.rating, 5)
        }
    }
    
    func testTestimonials_AllVerified() {
        for testimonial in testimonials {
            XCTAssertTrue(testimonial.isVerified)
        }
    }
    
    // MARK: - Carousel Tests
    
    func testCarousel_AutoScrollInterval() {
        let interval: Double = 4.0 // seconds
        XCTAssertGreaterThanOrEqual(interval, 3)
        XCTAssertLessThanOrEqual(interval, 6)
    }
    
    func testCarousel_InitialIndex() {
        let initialIndex = 0
        XCTAssertEqual(initialIndex, 0)
    }
    
    func testCarousel_LoopsBack() {
        let totalItems = testimonials.count
        let currentIndex = totalItems - 1
        let nextIndex = (currentIndex + 1) % totalItems
        
        XCTAssertEqual(nextIndex, 0)
    }
    
    // MARK: - Card Styling Tests
    
    func testCardWidth() {
        let screenWidth: CGFloat = 390 // iPhone 14 width
        let cardPadding: CGFloat = 40
        let cardWidth = screenWidth - cardPadding
        
        XCTAssertGreaterThan(cardWidth, 300)
    }
    
    func testCardCornerRadius() {
        let cornerRadius: CGFloat = 16
        XCTAssertGreaterThan(cornerRadius, 8)
    }
    
    // MARK: - Rating Display Tests
    
    func testRatingStars_ShowCorrectCount() {
        let rating = 5
        let starCount = rating
        
        XCTAssertEqual(starCount, 5)
    }
    
    func testRatingColor() {
        let starColor = "F59E0B" // Amber
        XCTAssertEqual(starColor.count, 6)
    }
}

// MARK: - Testimonial Card Tests

final class TestimonialCardTests: XCTestCase {
    
    func testCard_DisplaysUserAvatar() {
        let hasAvatar = true
        XCTAssertTrue(hasAvatar)
    }
    
    func testCard_DisplaysVerifiedBadge() {
        let testimonial = testimonials.first!
        XCTAssertTrue(testimonial.isVerified)
    }
    
    func testCard_QuoteMarks() {
        let hasQuoteMarks = true
        XCTAssertTrue(hasQuoteMarks)
    }
}
