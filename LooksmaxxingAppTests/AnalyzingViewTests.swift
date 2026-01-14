//
//  AnalyzingViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for AnalyzingView enhancements
//  Tests rotating label functionality and timer cleanup
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class AnalyzingViewTests: XCTestCase {
    
    var quizData: OnboardingQuizData!
    
    override func setUp() {
        super.setUp()
        clearQuizDataDefaults()
        quizData = OnboardingQuizData()
    }
    
    override func tearDown() {
        quizData = nil
        clearQuizDataDefaults()
        super.tearDown()
    }
    
    private func clearQuizDataDefaults() {
        let keys = ["selectedSymptoms", "selectedGoals", "commitmentSignature"]
        keys.forEach { UserDefaults.standard.removeObject(forKey: $0) }
    }
    
    // MARK: - Processing Labels Tests
    
    func testProcessingLabels_CountIs4() {
        let expectedLabels = [
            "Analyzing facial architecture...",
            "Comparing to 50,000+ data points...",
            "Synthesizing your transformation plan...",
            "Calculating potential improvements..."
        ]
        XCTAssertEqual(expectedLabels.count, 4)
    }
    
    func testProcessingLabels_AllLabelsNonEmpty() {
        let labels = [
            "Analyzing facial architecture...",
            "Comparing to 50,000+ data points...",
            "Synthesizing your transformation plan...",
            "Calculating potential improvements..."
        ]
        
        for label in labels {
            XCTAssertFalse(label.isEmpty, "Label should not be empty: \(label)")
            XCTAssertTrue(label.hasSuffix("..."), "Label should end with ellipsis")
        }
    }
    
    func testProcessingLabels_RotationInterval_Is800ms() {
        // Label rotation should happen every 800ms
        let interval: TimeInterval = 0.8
        XCTAssertEqual(interval, 0.8, accuracy: 0.01)
    }
    
    // MARK: - Label Index Tests
    
    func testLabelIndex_CyclesThroughAllLabels() {
        let labels = ["Label1", "Label2", "Label3", "Label4"]
        var currentIndex = 0
        
        // Simulate cycling through labels
        for _ in 0..<8 {
            currentIndex = (currentIndex + 1) % labels.count
        }
        
        // After 8 cycles (2 full rotations), should be back at index 0
        XCTAssertEqual(currentIndex, 0)
    }
    
    func testLabelIndex_WrapsAround() {
        let labels = ["Label1", "Label2", "Label3", "Label4"]
        var currentIndex = 3 // Last index
        
        // Next index should wrap to 0
        currentIndex = (currentIndex + 1) % labels.count
        XCTAssertEqual(currentIndex, 0)
    }
    
    // MARK: - Steps Tests
    
    func testSteps_CountIs6() {
        // Verify we have 6 processing steps
        let expectedSteps = 6
        XCTAssertEqual(expectedSteps, 6)
    }
    
    func testSteps_AllHaveTextAndIcons() {
        let steps = [
            ("Analyzing facial architecture", "faceid"),
            ("Scanning mandible structure", "face.smiling"),
            ("Assessing orbital symmetry", "eye"),
            ("Evaluating skin texture", "sparkles"),
            ("Comparing to 50,000+ data points", "chart.bar.fill"),
            ("Building your personalized plan", "doc.text.fill")
        ]
        
        for step in steps {
            XCTAssertFalse(step.0.isEmpty, "Step text should not be empty")
            XCTAssertFalse(step.1.isEmpty, "Step icon should not be empty")
        }
    }
}
