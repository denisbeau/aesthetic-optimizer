//
//  CelebrationViewTests.swift
//  LooksmaxxingAppTests
//
//  Tests for celebration animations and milestones
//

import XCTest
@testable import LooksmaxxingApp

final class CelebrationViewTests: XCTestCase {
    
    var celebrationManager: CelebrationManager!
    
    override func setUp() {
        super.setUp()
        celebrationManager = CelebrationManager.shared
        celebrationManager.isShowing = false
        celebrationManager.message = ""
        celebrationManager.emoji = ""
    }
    
    override func tearDown() {
        celebrationManager.isShowing = false
        celebrationManager = nil
        super.tearDown()
    }
    
    // MARK: - CelebrationManager Singleton Tests
    
    func testCelebrationManager_IsSingleton() {
        let instance1 = CelebrationManager.shared
        let instance2 = CelebrationManager.shared
        XCTAssertTrue(instance1 === instance2, "Should be same instance")
    }
    
    func testCelebrationManager_InitialState() {
        // Reset state
        celebrationManager.isShowing = false
        celebrationManager.message = ""
        celebrationManager.emoji = ""
        
        XCTAssertFalse(celebrationManager.isShowing, "Should not be showing initially")
        XCTAssertTrue(celebrationManager.message.isEmpty, "Message should be empty")
        XCTAssertTrue(celebrationManager.emoji.isEmpty, "Emoji should be empty")
    }
    
    // MARK: - Milestone Tests
    
    func testMilestone_Streak7() {
        celebrationManager.celebrate(for: .streak7)
        
        XCTAssertTrue(celebrationManager.isShowing, "Should show celebration")
        XCTAssertEqual(celebrationManager.message, "One Week Streak!")
    }
    
    func testMilestone_Streak30() {
        celebrationManager.celebrate(for: .streak30)
        
        XCTAssertTrue(celebrationManager.isShowing)
        XCTAssertEqual(celebrationManager.message, "30 Day Champion!")
    }
    
    func testMilestone_Streak100() {
        celebrationManager.celebrate(for: .streak100)
        
        XCTAssertTrue(celebrationManager.isShowing)
        XCTAssertEqual(celebrationManager.message, "100 Day Legend!")
    }
    
    func testMilestone_FirstScan() {
        celebrationManager.celebrate(for: .firstScan)
        
        XCTAssertTrue(celebrationManager.isShowing)
        XCTAssertEqual(celebrationManager.message, "First Scan Complete!")
    }
    
    func testMilestone_Score8() {
        celebrationManager.celebrate(for: .score8)
        
        XCTAssertTrue(celebrationManager.isShowing)
        XCTAssertEqual(celebrationManager.message, "You Hit 8.0!")
    }
    
    func testMilestone_PerfectWeek() {
        celebrationManager.celebrate(for: .perfectWeek)
        
        XCTAssertTrue(celebrationManager.isShowing)
        XCTAssertEqual(celebrationManager.message, "Perfect Week!")
    }
    
    // MARK: - Milestone Enum Tests
    
    func testMilestoneEnum_AllCases() {
        // Verify all milestone types exist
        let milestones: [CelebrationManager.Milestone] = [
            .streak7, .streak30, .streak100,
            .firstScan, .score8, .perfectWeek
        ]
        XCTAssertEqual(milestones.count, 6, "Should have 6 milestone types")
    }
    
    // MARK: - Particle Tests
    
    func testParticle_Initialization() {
        let particle = Particle()
        
        XCTAssertNotNil(particle.id, "Particle should have ID")
        XCTAssertGreaterThanOrEqual(particle.velocity, 3, "Velocity should be at least 3")
        XCTAssertLessThanOrEqual(particle.velocity, 8, "Velocity should be at most 8")
        XCTAssertGreaterThanOrEqual(particle.size, 6, "Size should be at least 6")
        XCTAssertLessThanOrEqual(particle.size, 12, "Size should be at most 12")
        XCTAssertEqual(particle.opacity, 1.0, accuracy: 0.01, "Initial opacity should be 1.0")
    }
    
    func testParticle_UniqueIDs() {
        var ids = Set<UUID>()
        for _ in 0..<100 {
            let particle = Particle()
            XCTAssertFalse(ids.contains(particle.id), "Each particle should have unique ID")
            ids.insert(particle.id)
        }
    }
    
    func testParticle_PositionWithinBounds() {
        let particle = Particle()
        
        // X should be within screen bounds (0 to screen width)
        XCTAssertGreaterThanOrEqual(particle.position.x, 0)
        
        // Y should start above screen (negative or zero)
        XCTAssertLessThanOrEqual(particle.position.y, 0)
    }
    
    // MARK: - Color Tests
    
    func testParticle_ColorVariety() {
        var colors = Set<String>()
        
        // Generate many particles to ensure we get variety
        for _ in 0..<100 {
            let particle = Particle()
            // We can't directly compare SwiftUI Colors, but we verify variety exists
            colors.insert(particle.color.description)
        }
        
        // Should have multiple different colors
        XCTAssertGreaterThan(colors.count, 1, "Should have color variety")
    }
    
    // MARK: - State Management Tests
    
    func testCelebration_ShowsWhenCalled() {
        XCTAssertFalse(celebrationManager.isShowing)
        
        celebrationManager.celebrate(for: .firstScan)
        
        XCTAssertTrue(celebrationManager.isShowing, "Should show after celebrate() called")
    }
    
    func testCelebration_MessageAndEmojiSet() {
        celebrationManager.celebrate(for: .streak7)
        
        XCTAssertFalse(celebrationManager.message.isEmpty, "Message should be set")
        XCTAssertFalse(celebrationManager.emoji.isEmpty, "Emoji should be set")
    }
}
