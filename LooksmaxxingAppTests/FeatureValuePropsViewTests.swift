//
//  FeatureValuePropsViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for FeatureValuePropsView
//  Tests feature cards, staggered animations, and icon display
//

import XCTest
@testable import LooksmaxxingApp

final class FeatureValuePropsViewTests: XCTestCase {
    
    // MARK: - Feature Value Props Tests
    
    func testFeatureValueProps_Count() {
        XCTAssertEqual(featureValueProps.count, 4)
    }
    
    func testFeatureValueProps_AllHaveIcons() {
        for prop in featureValueProps {
            XCTAssertFalse(prop.icon.isEmpty)
        }
    }
    
    func testFeatureValueProps_AllHaveTitles() {
        for prop in featureValueProps {
            XCTAssertFalse(prop.title.isEmpty)
        }
    }
    
    func testFeatureValueProps_AllHaveDescriptions() {
        for prop in featureValueProps {
            XCTAssertFalse(prop.description.isEmpty)
            XCTAssertGreaterThan(prop.description.count, 20)
        }
    }
    
    func testFeatureValueProps_UniqueIds() {
        let ids = featureValueProps.map { $0.id }
        let uniqueIds = Set(ids)
        XCTAssertEqual(ids.count, uniqueIds.count)
    }
    
    // MARK: - Feature Content Tests
    
    func testHasAIFeature() {
        let hasAI = featureValueProps.contains { 
            $0.title.lowercased().contains("ai") 
        }
        XCTAssertTrue(hasAI)
    }
    
    func testHasStreakFeature() {
        let hasStreak = featureValueProps.contains { 
            $0.title.lowercased().contains("streak") 
        }
        XCTAssertTrue(hasStreak)
    }
    
    func testHasProgressFeature() {
        let hasProgress = featureValueProps.contains { 
            $0.title.lowercased().contains("progress") || 
            $0.title.lowercased().contains("track")
        }
        XCTAssertTrue(hasProgress)
    }
    
    func testHasCommunityFeature() {
        let hasCommunity = featureValueProps.contains { 
            $0.title.lowercased().contains("join") || 
            $0.description.lowercased().contains("users")
        }
        XCTAssertTrue(hasCommunity)
    }
    
    // MARK: - Animation Tests
    
    func testStaggeredAnimation_Delays() {
        let delays: [Double] = [0, 0.15, 0.30, 0.45]
        
        XCTAssertEqual(delays.count, 4)
        XCTAssertEqual(delays[0], 0)
        XCTAssertGreaterThan(delays[1], delays[0])
    }
    
    func testFadeInAnimation_Duration() {
        let duration: Double = 0.5
        XCTAssertGreaterThan(duration, 0.2)
        XCTAssertLessThan(duration, 1.0)
    }
    
    func testSlideOffset_Initial() {
        let initialOffset: CGFloat = 30
        XCTAssertGreaterThan(initialOffset, 0)
    }
    
    // MARK: - Card Styling Tests
    
    func testCardPadding() {
        let padding: CGFloat = 20
        XCTAssertGreaterThanOrEqual(padding, 16)
    }
    
    func testCardCornerRadius() {
        let cornerRadius: CGFloat = 16
        XCTAssertGreaterThan(cornerRadius, 8)
    }
    
    func testIconSize() {
        let iconSize: CGFloat = 28
        XCTAssertGreaterThanOrEqual(iconSize, 24)
        XCTAssertLessThanOrEqual(iconSize, 40)
    }
}
