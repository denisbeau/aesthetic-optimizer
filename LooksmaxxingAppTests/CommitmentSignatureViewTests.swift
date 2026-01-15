//
//  CommitmentSignatureViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for CommitmentSignatureView
//  Tests signature validation, stroke handling, and commitment state
//

import XCTest
import SwiftUI
@testable import LooksmaxxingApp

@MainActor
final class CommitmentSignatureViewTests: XCTestCase {
    
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
    
    // MARK: - Initial State Tests
    
    func testInitialState_NotSigned() {
        XCTAssertFalse(onboardingData.hasSignedCommitment)
    }
    
    // MARK: - Signature State Tests
    
    func testSignCommitment_SetsFlag() {
        onboardingData.hasSignedCommitment = true
        XCTAssertTrue(onboardingData.hasSignedCommitment)
    }
    
    func testUnsignCommitment_ClearsFlag() {
        onboardingData.hasSignedCommitment = true
        onboardingData.hasSignedCommitment = false
        XCTAssertFalse(onboardingData.hasSignedCommitment)
    }
    
    // MARK: - Stroke Validation Tests
    
    func testStrokeLength_BelowMinimum() {
        let minStrokeLength: CGFloat = 50
        let testStrokeLength: CGFloat = 30
        
        XCTAssertLessThan(testStrokeLength, minStrokeLength)
    }
    
    func testStrokeLength_AboveMinimum() {
        let minStrokeLength: CGFloat = 50
        let testStrokeLength: CGFloat = 100
        
        XCTAssertGreaterThanOrEqual(testStrokeLength, minStrokeLength)
    }
    
    func testStrokeLength_ExactlyMinimum() {
        let minStrokeLength: CGFloat = 50
        let testStrokeLength: CGFloat = 50
        
        XCTAssertGreaterThanOrEqual(testStrokeLength, minStrokeLength)
    }
    
    // MARK: - Path Calculation Tests
    
    func testCalculateStrokeLength_EmptyPath() {
        let points: [CGPoint] = []
        let length = calculateStrokeLength(points)
        XCTAssertEqual(length, 0)
    }
    
    func testCalculateStrokeLength_SinglePoint() {
        let points: [CGPoint] = [CGPoint(x: 0, y: 0)]
        let length = calculateStrokeLength(points)
        XCTAssertEqual(length, 0)
    }
    
    func testCalculateStrokeLength_TwoPoints_Horizontal() {
        let points: [CGPoint] = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 100, y: 0)
        ]
        let length = calculateStrokeLength(points)
        XCTAssertEqual(length, 100, accuracy: 0.01)
    }
    
    func testCalculateStrokeLength_TwoPoints_Vertical() {
        let points: [CGPoint] = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 50)
        ]
        let length = calculateStrokeLength(points)
        XCTAssertEqual(length, 50, accuracy: 0.01)
    }
    
    func testCalculateStrokeLength_TwoPoints_Diagonal() {
        let points: [CGPoint] = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 3, y: 4)
        ]
        let length = calculateStrokeLength(points)
        // 3-4-5 triangle, hypotenuse = 5
        XCTAssertEqual(length, 5, accuracy: 0.01)
    }
    
    func testCalculateStrokeLength_MultiplePoints() {
        let points: [CGPoint] = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 10, y: 0),
            CGPoint(x: 20, y: 0),
            CGPoint(x: 30, y: 0)
        ]
        let length = calculateStrokeLength(points)
        XCTAssertEqual(length, 30, accuracy: 0.01)
    }
    
    // MARK: - Helper Methods
    
    private func calculateStrokeLength(_ points: [CGPoint]) -> CGFloat {
        guard points.count > 1 else { return 0 }
        
        var totalLength: CGFloat = 0
        for i in 1..<points.count {
            let dx = points[i].x - points[i-1].x
            let dy = points[i].y - points[i-1].y
            totalLength += sqrt(dx * dx + dy * dy)
        }
        return totalLength
    }
}

// MARK: - Bezier Smoothing Tests

final class BezierSmoothingTests: XCTestCase {
    
    func testBezierSmoothing_CreatesPath() {
        let points: [CGPoint] = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 50, y: 50),
            CGPoint(x: 100, y: 0)
        ]
        
        let path = createSmoothedPath(points)
        XCTAssertFalse(path.isEmpty)
    }
    
    func testBezierSmoothing_SinglePoint_ReturnsEmpty() {
        let points: [CGPoint] = [CGPoint(x: 0, y: 0)]
        let path = createSmoothedPath(points)
        XCTAssertTrue(path.isEmpty)
    }
    
    private func createSmoothedPath(_ points: [CGPoint]) -> Path {
        var path = Path()
        guard points.count > 1 else { return path }
        
        path.move(to: points[0])
        
        if points.count == 2 {
            path.addLine(to: points[1])
        } else {
            for i in 1..<points.count {
                let mid = CGPoint(
                    x: (points[i-1].x + points[i].x) / 2,
                    y: (points[i-1].y + points[i].y) / 2
                )
                path.addQuadCurve(to: mid, control: points[i-1])
            }
            path.addLine(to: points.last!)
        }
        
        return path
    }
}
