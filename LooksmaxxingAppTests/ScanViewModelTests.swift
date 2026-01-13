//
//  ScanViewModelTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for ScanViewModel
//  Tests capture flow, processing state, and error handling
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class ScanViewModelTests: XCTestCase {
    
    var viewModel: ScanViewModel!
    
    override func setUp() async throws {
        try await super.setUp()
        viewModel = ScanViewModel()
    }
    
    override func tearDown() async throws {
        viewModel = nil
        try await super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        XCTAssertNil(viewModel.frontImage)
        XCTAssertNil(viewModel.sideImage)
        XCTAssertFalse(viewModel.isProcessing)
        XCTAssertEqual(viewModel.processingProgress, 0.0)
        XCTAssertNil(viewModel.analysisResult)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.captureMode, .front)
    }
    
    // MARK: - Capture Mode Tests
    
    func testCaptureMode_Instructions() {
        XCTAssertEqual(ScanViewModel.CaptureMode.front.instruction, "Position your face in the frame and look straight ahead")
        XCTAssertEqual(ScanViewModel.CaptureMode.side.instruction, "Turn your head to show your side profile")
        XCTAssertEqual(ScanViewModel.CaptureMode.complete.instruction, "Photos captured! Analyzing...")
    }
    
    func testCaptureMode_ButtonTitles() {
        XCTAssertEqual(ScanViewModel.CaptureMode.front.buttonTitle, "Capture Front")
        XCTAssertEqual(ScanViewModel.CaptureMode.side.buttonTitle, "Capture Side")
        XCTAssertEqual(ScanViewModel.CaptureMode.complete.buttonTitle, "Processing...")
    }
    
    // MARK: - Capture Front Tests
    
    func testCaptureFront() {
        let testImage = createTestImage()
        
        viewModel.captureFront(testImage)
        
        XCTAssertNotNil(viewModel.frontImage)
        XCTAssertEqual(viewModel.captureMode, .side)
        XCTAssertNil(viewModel.sideImage)
    }
    
    // MARK: - Capture Side Tests
    
    func testCaptureSide_StartsProcessing() {
        let testImage = createTestImage()
        
        viewModel.captureFront(testImage)
        viewModel.captureSide(testImage)
        
        XCTAssertNotNil(viewModel.sideImage)
        XCTAssertEqual(viewModel.captureMode, .complete)
    }
    
    // MARK: - Reset Tests
    
    func testReset() {
        let testImage = createTestImage()
        
        // Set up some state
        viewModel.captureFront(testImage)
        viewModel.captureSide(testImage)
        
        // Reset
        viewModel.reset()
        
        XCTAssertNil(viewModel.frontImage)
        XCTAssertNil(viewModel.sideImage)
        XCTAssertFalse(viewModel.isProcessing)
        XCTAssertEqual(viewModel.processingProgress, 0.0)
        XCTAssertNil(viewModel.analysisResult)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.captureMode, .front)
    }
    
    // MARK: - Process Images Tests
    
    func testProcessImages_MissingFront() async {
        viewModel.frontImage = nil
        viewModel.sideImage = createTestImage()
        
        await viewModel.processImages()
        
        XCTAssertEqual(viewModel.error, .processingFailed)
    }
    
    func testProcessImages_MissingSide() async {
        viewModel.frontImage = createTestImage()
        viewModel.sideImage = nil
        
        await viewModel.processImages()
        
        XCTAssertEqual(viewModel.error, .processingFailed)
    }
    
    func testProcessImages_BothMissing() async {
        viewModel.frontImage = nil
        viewModel.sideImage = nil
        
        await viewModel.processImages()
        
        XCTAssertEqual(viewModel.error, .processingFailed)
    }
    
    // MARK: - Helper Methods
    
    private func createTestImage() -> UIImage {
        // Create a simple 1x1 red pixel image for testing
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        UIColor.red.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - Capture Flow Integration Tests

@MainActor
final class ScanFlowTests: XCTestCase {
    
    func testFullCaptureFlow() {
        let viewModel = ScanViewModel()
        
        // Initial state
        XCTAssertEqual(viewModel.captureMode, .front)
        
        // Capture front
        let frontImage = createTestImage()
        viewModel.captureFront(frontImage)
        XCTAssertEqual(viewModel.captureMode, .side)
        XCTAssertNotNil(viewModel.frontImage)
        
        // Capture side
        let sideImage = createTestImage()
        viewModel.captureSide(sideImage)
        XCTAssertEqual(viewModel.captureMode, .complete)
        XCTAssertNotNil(viewModel.sideImage)
    }
    
    func testCaptureFlowReset() {
        let viewModel = ScanViewModel()
        
        // Complete a capture
        viewModel.captureFront(createTestImage())
        viewModel.captureSide(createTestImage())
        
        // Reset
        viewModel.reset()
        
        // Should be back to start
        XCTAssertEqual(viewModel.captureMode, .front)
        XCTAssertNil(viewModel.frontImage)
        XCTAssertNil(viewModel.sideImage)
    }
    
    private func createTestImage() -> UIImage {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        UIColor.blue.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
