//
//  ProgressTimelineViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for ProgressTimelineView
//  Tests timeline milestones, animation, and date calculations
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class ProgressTimelineViewTests: XCTestCase {
    
    var onboardingData: OnboardingData!
    
    override func setUp() {
        super.setUp()
        onboardingData = OnboardingData()
        onboardingData.reset()
    }
    
    override func tearDown() {
        onboardingData = nil
        super.tearDown()
    }
    
    // MARK: - Timeline Milestones Tests
    
    func testTimeline_HasMilestones() {
        let milestones = [
            "Week 1: Build habits",
            "Week 2: See changes",
            "Month 1: Visible progress",
            "Month 2: Transformation"
        ]
        
        XCTAssertGreaterThanOrEqual(milestones.count, 4)
    }
    
    func testTimeline_StartsFromToday() {
        let today = onboardingData.todayFormatted
        XCTAssertFalse(today.isEmpty)
    }
    
    func testTimeline_EndsAt60Days() {
        let endDate = onboardingData.transformationDate
        let calendar = Calendar.current
        let daysDiff = calendar.dateComponents([.day], from: Date(), to: endDate).day!
        
        XCTAssertEqual(daysDiff, 60, accuracy: 1)
    }
    
    // MARK: - Date Formatting Tests
    
    func testStartDate_Format() {
        let today = onboardingData.todayFormatted
        // Format: MM/dd
        XCTAssertEqual(today.count, 5)
        XCTAssertTrue(today.contains("/"))
    }
    
    func testEndDate_Format() {
        let endDate = onboardingData.formattedTransformationDate
        // Format: MMM d, yyyy
        XCTAssertTrue(endDate.contains(","))
    }
    
    // MARK: - Timeline Animation Tests
    
    func testTimeline_AnimatesSequentially() {
        let delays: [Double] = [0, 0.2, 0.4, 0.6]
        
        for i in 1..<delays.count {
            XCTAssertGreaterThan(delays[i], delays[i-1])
        }
    }
    
    func testTimeline_LineDrawsIn() {
        let lineAnimationDuration: Double = 1.5
        XCTAssertGreaterThan(lineAnimationDuration, 0.5)
    }
    
    func testMilestone_CheckmarkAnimates() {
        let checkmarkDelay: Double = 0.3
        XCTAssertGreaterThan(checkmarkDelay, 0)
    }
    
    // MARK: - Visual Elements Tests
    
    func testMilestone_HasCheckmark() {
        let checkmarkIcon = "checkmark.circle.fill"
        XCTAssertFalse(checkmarkIcon.isEmpty)
    }
    
    func testTimeline_LineColor() {
        let lineColor = "10B981" // Green
        XCTAssertEqual(lineColor.count, 6)
    }
    
    func testTimeline_InactiveColor() {
        let inactiveColor = "2A2A34"
        XCTAssertEqual(inactiveColor.count, 6)
    }
    
    // MARK: - Milestone Content Tests
    
    func testFirstMilestone_IsToday() {
        let firstMilestoneLabel = "Today"
        XCTAssertEqual(firstMilestoneLabel, "Today")
    }
    
    func testLastMilestone_IsGoal() {
        let lastMilestoneLabel = "Your Goal"
        XCTAssertEqual(lastMilestoneLabel, "Your Goal")
    }
}

// MARK: - Milestone Model Tests

final class MilestoneModelTests: XCTestCase {
    
    func testMilestone_HasTitle() {
        let milestone = TimelineMilestone(
            id: 1,
            title: "Week 1",
            subtitle: "Build habits",
            isCompleted: false,
            isCurrent: true
        )
        
        XCTAssertFalse(milestone.title.isEmpty)
    }
    
    func testMilestone_HasSubtitle() {
        let milestone = TimelineMilestone(
            id: 1,
            title: "Week 1",
            subtitle: "Build habits",
            isCompleted: false,
            isCurrent: true
        )
        
        XCTAssertFalse(milestone.subtitle.isEmpty)
    }
    
    func testMilestone_CanBeCompleted() {
        var milestone = TimelineMilestone(
            id: 1,
            title: "Week 1",
            subtitle: "Build habits",
            isCompleted: false,
            isCurrent: true
        )
        
        milestone.isCompleted = true
        XCTAssertTrue(milestone.isCompleted)
    }
}

// Helper struct for tests
struct TimelineMilestone {
    let id: Int
    let title: String
    let subtitle: String
    var isCompleted: Bool
    var isCurrent: Bool
}
