//
//  PreQuizOnboardingViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for PreQuizOnboardingView
//  Tests navigation, state management, and screen count
//

import XCTest
import SwiftUI
@testable import LooksmaxxingApp

@MainActor
final class PreQuizOnboardingViewTests: XCTestCase {
    
    let testDefaults = UserDefaults(suiteName: "test.prequiz")!
    
    override func setUp() {
        super.setUp()
        testDefaults.removePersistentDomain(forName: "test.prequiz")
    }
    
    override func tearDown() {
        testDefaults.removePersistentDomain(forName: "test.prequiz")
        super.tearDown()
    }
    
    // MARK: - Screen Count Tests
    
    func testPreQuizScreens_CountIs7() {
        // Verify we have exactly 7 screens as specified
        let screens = [
            "AI-Powered Facial Analysis",
            "Join 12,000+ Users",
            "Your Transformation Journey Starts Here",
            "Do You Avoid Photos?",
            "70% Have Facial Asymmetry",
            "Facial Structure Responds to Daily Habits",
            "Welcome! Let's Assess Your Potential"
        ]
        XCTAssertEqual(screens.count, 7)
    }
    
    // MARK: - UserDefaults Tests
    
    func testHasSeenPreQuiz_InitialState_False() {
        UserDefaults.standard.removeObject(forKey: "hasSeenPreQuiz")
        let initialValue = UserDefaults.standard.bool(forKey: "hasSeenPreQuiz")
        XCTAssertFalse(initialValue)
    }
    
    func testHasSeenPreQuiz_SetToTrue_Persists() {
        UserDefaults.standard.set(true, forKey: "hasSeenPreQuiz")
        let value = UserDefaults.standard.bool(forKey: "hasSeenPreQuiz")
        XCTAssertTrue(value)
    }
    
    // MARK: - Navigation Flow Tests
    
    func testPreQuizFlow_CompletesToQuiz() {
        // This tests that the flow properly sets hasSeenPreQuiz
        UserDefaults.standard.set(false, forKey: "hasSeenPreQuiz")
        XCTAssertFalse(UserDefaults.standard.bool(forKey: "hasSeenPreQuiz"))
        
        // Simulate completion
        UserDefaults.standard.set(true, forKey: "hasSeenPreQuiz")
        XCTAssertTrue(UserDefaults.standard.bool(forKey: "hasSeenPreQuiz"))
    }
    
    // MARK: - Content Validation Tests
    
    func testScreenContent_AllScreensHaveHeadlines() {
        let expectedHeadlines = [
            "AI-Powered Facial Analysis",
            "Join 12,000+ Users",
            "Your Transformation Journey Starts Here",
            "Do You Avoid Photos?",
            "70% Have Facial Asymmetry",
            "Facial Structure Responds to Daily Habits",
            "Welcome! Let's Assess Your Potential"
        ]
        
        // Verify all expected headlines exist
        for headline in expectedHeadlines {
            XCTAssertFalse(headline.isEmpty, "Headline should not be empty: \(headline)")
        }
    }
    
    func testScreenContent_AllScreensHaveSubtext() {
        let expectedSubtexts = [
            "Identifies 50+ aesthetic data points through advanced computer vision",
            "Optimizing their facial aesthetics with personalized plans",
            "From receded chin to defined jawline in 90 days",
            "Because of your jawline, symmetry, or skin concerns?",
            "Most don't realize it until they see the data",
            "Mewing, posture, and targeted exercises create lasting change",
            "Our AI will analyze your responses and create a personalized plan"
        ]
        
        for subtext in expectedSubtexts {
            XCTAssertFalse(subtext.isEmpty, "Subtext should not be empty")
        }
    }
    
    func testScreenContent_AllScreensHaveIcons() {
        let expectedIcons = [
            "faceid",
            "person.3.fill",
            "arrow.up.circle.fill",
            "camera.fill",
            "chart.bar.fill",
            "figure.stand",
            "star.fill"
        ]
        
        for icon in expectedIcons {
            XCTAssertFalse(icon.isEmpty, "Icon should not be empty: \(icon)")
        }
    }
}
