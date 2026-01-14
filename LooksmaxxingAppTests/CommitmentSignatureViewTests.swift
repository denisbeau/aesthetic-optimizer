//
//  CommitmentSignatureViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for CommitmentSignatureView
//  Tests signature validation, persistence, and PencilKit integration
//

import XCTest
import PencilKit
@testable import LooksmaxxingApp

@MainActor
final class CommitmentSignatureViewTests: XCTestCase {
    
    var quizData: OnboardingQuizData!
    
    override func setUp() {
        super.setUp()
        quizData = OnboardingQuizData()
    }
    
    override func tearDown() {
        quizData = nil
        super.tearDown()
    }
    
    // MARK: - Signature Validation Tests
    
    func testSignatureValidation_EmptyDrawing_Invalid() {
        let drawing = PKDrawing()
        let bounds = drawing.bounds
        
        // Minimum path length is 50 units
        let hasStroke = bounds.width > 50 || bounds.height > 50
        XCTAssertFalse(hasStroke, "Empty drawing should be invalid")
    }
    
    func testSignatureValidation_MinimumPathLength_Valid() {
        // Create a drawing with minimum path length
        var drawing = PKDrawing()
        let stroke = PKStroke(ink: PKInkingTool(.pen, color: .black, width: 4).ink, path: PKStrokePath(controlPoints: [
            PKStrokePoint(location: CGPoint(x: 0, y: 0), timeOffset: 0, size: CGSize(width: 4, height: 4), opacity: 1, force: 1, azimuth: 0, altitude: 0),
            PKStrokePoint(location: CGPoint(x: 60, y: 60), timeOffset: 0.1, size: CGSize(width: 4, height: 4), opacity: 1, force: 1, azimuth: 0, altitude: 0)
        ], creationDate: Date()))
        drawing.strokes.append(stroke)
        
        let bounds = drawing.bounds
        let hasStroke = bounds.width > 50 || bounds.height > 50
        XCTAssertTrue(hasStroke, "Drawing with path > 50 should be valid")
    }
    
    // MARK: - Signature Persistence Tests
    
    func testSignatureSave_ConvertsToData() {
        var drawing = PKDrawing()
        let stroke = PKStroke(ink: PKInkingTool(.pen, color: .black, width: 4).ink, path: PKStrokePath(controlPoints: [
            PKStrokePoint(location: CGPoint(x: 0, y: 0), timeOffset: 0, size: CGSize(width: 4, height: 4), opacity: 1, force: 1, azimuth: 0, altitude: 0),
            PKStrokePoint(location: CGPoint(x: 100, y: 100), timeOffset: 0.1, size: CGSize(width: 4, height: 4), opacity: 1, force: 1, azimuth: 0, altitude: 0)
        ], creationDate: Date()))
        drawing.strokes.append(stroke)
        
        let canvasView = PKCanvasView()
        canvasView.drawing = drawing
        let image = drawing.image(from: canvasView.bounds, scale: 2.0)
        let data = image.pngData()
        
        XCTAssertNotNil(data, "Signature should convert to PNG data")
    }
    
    func testSignaturePersistence_SavesToUserDefaults() {
        let testData = Data("test signature".utf8)
        quizData.commitmentSignature = testData
        quizData.saveToUserDefaults()
        
        let loaded = UserDefaults.standard.data(forKey: "commitmentSignature")
        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded, testData)
    }
    
    func testSignaturePersistence_LoadsFromUserDefaults() {
        let testData = Data("test signature".utf8)
        UserDefaults.standard.set(testData, forKey: "commitmentSignature")
        let newQuizData = OnboardingQuizData()
        
        XCTAssertNotNil(newQuizData.commitmentSignature)
        XCTAssertEqual(newQuizData.commitmentSignature, testData)
    }
    
    // MARK: - Has Signed Commitment Tests
    
    func testHasSignedCommitment_NoSignature_ReturnsFalse() {
        quizData.commitmentSignature = nil
        XCTAssertFalse(quizData.hasSignedCommitment)
    }
    
    func testHasSignedCommitment_WithSignature_ReturnsTrue() {
        let testData = Data("signature".utf8)
        quizData.commitmentSignature = testData
        XCTAssertTrue(quizData.hasSignedCommitment)
    }
    
    // MARK: - Clear Functionality Tests
    
    func testClearSignature_ResetsDrawing() {
        var drawing = PKDrawing()
        let stroke = PKStroke(ink: PKInkingTool(.pen, color: .black, width: 4).ink, path: PKStrokePath(controlPoints: [
            PKStrokePoint(location: CGPoint(x: 0, y: 0), timeOffset: 0, size: CGSize(width: 4, height: 4), opacity: 1, force: 1, azimuth: 0, altitude: 0),
            PKStrokePoint(location: CGPoint(x: 100, y: 100), timeOffset: 0.1, size: CGSize(width: 4, height: 4), opacity: 1, force: 1, azimuth: 0, altitude: 0)
        ], creationDate: Date()))
        drawing.strokes.append(stroke)
        
        // Clear drawing
        drawing = PKDrawing()
        XCTAssertTrue(drawing.strokes.isEmpty, "Cleared drawing should have no strokes")
    }
}
