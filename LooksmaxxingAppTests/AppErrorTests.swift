//
//  AppErrorTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for AppError enum
//  Tests error descriptions, recovery suggestions, and retryability
//

import XCTest
@testable import LooksmaxxingApp

final class AppErrorTests: XCTestCase {
    
    // MARK: - Error Description Tests
    
    func testCameraPermissionDenied_Description() {
        let error = AppError.cameraPermissionDenied
        XCTAssertTrue(error.errorDescription?.contains("Camera") ?? false)
        XCTAssertTrue(error.errorDescription?.contains("Settings") ?? false)
    }
    
    func testCameraUnavailable_Description() {
        let error = AppError.cameraUnavailable
        XCTAssertTrue(error.errorDescription?.contains("not available") ?? false)
    }
    
    func testNoFaceDetected_Description() {
        let error = AppError.noFaceDetected
        XCTAssertTrue(error.errorDescription?.contains("No face") ?? false)
    }
    
    func testMultipleFacesDetected_Description() {
        let error = AppError.multipleFacesDetected
        XCTAssertTrue(error.errorDescription?.contains("Multiple faces") ?? false)
    }
    
    func testProcessingFailed_Description() {
        let error = AppError.processingFailed
        XCTAssertTrue(error.errorDescription?.contains("failed") ?? false)
    }
    
    func testProcessingTimeout_Description() {
        let error = AppError.processingTimeout
        XCTAssertTrue(error.errorDescription?.contains("too long") ?? false)
    }
    
    func testPurchaseFailed_Description() {
        let error = AppError.purchaseFailed("Payment declined")
        XCTAssertTrue(error.errorDescription?.contains("Purchase failed") ?? false)
        XCTAssertTrue(error.errorDescription?.contains("Payment declined") ?? false)
    }
    
    func testPurchaseCancelled_Description() {
        let error = AppError.purchaseCancelled
        XCTAssertTrue(error.errorDescription?.contains("cancelled") ?? false)
    }
    
    func testRestoreFailed_Description() {
        let error = AppError.restoreFailed
        XCTAssertTrue(error.errorDescription?.contains("restore") ?? false)
    }
    
    func testNetworkError_Description() {
        let error = AppError.networkError
        XCTAssertTrue(error.errorDescription?.contains("Network") ?? false)
    }
    
    func testCoreDataError_Description() {
        let error = AppError.coreDataError("Save failed")
        XCTAssertTrue(error.errorDescription?.contains("Data error") ?? false)
        XCTAssertTrue(error.errorDescription?.contains("Save failed") ?? false)
    }
    
    func testUnknown_Description() {
        let error = AppError.unknown("Custom error message")
        XCTAssertEqual(error.errorDescription, "Custom error message")
    }
    
    // MARK: - Recovery Suggestion Tests
    
    func testCameraPermissionDenied_Recovery() {
        let error = AppError.cameraPermissionDenied
        XCTAssertNotNil(error.recoverySuggestion)
        XCTAssertTrue(error.recoverySuggestion?.contains("Settings") ?? false)
    }
    
    func testNoFaceDetected_Recovery() {
        let error = AppError.noFaceDetected
        XCTAssertNotNil(error.recoverySuggestion)
        XCTAssertTrue(error.recoverySuggestion?.contains("well-lit") ?? false)
    }
    
    func testProcessingFailed_Recovery() {
        let error = AppError.processingFailed
        XCTAssertNotNil(error.recoverySuggestion)
        XCTAssertTrue(error.recoverySuggestion?.contains("new photo") ?? false)
    }
    
    func testProcessingTimeout_Recovery() {
        let error = AppError.processingTimeout
        XCTAssertNotNil(error.recoverySuggestion)
    }
    
    func testPurchaseFailed_Recovery() {
        let error = AppError.purchaseFailed("Test")
        XCTAssertNotNil(error.recoverySuggestion)
        XCTAssertTrue(error.recoverySuggestion?.contains("try again") ?? false)
    }
    
    func testRestoreFailed_Recovery() {
        let error = AppError.restoreFailed
        XCTAssertNotNil(error.recoverySuggestion)
    }
    
    func testNetworkError_Recovery() {
        let error = AppError.networkError
        XCTAssertNotNil(error.recoverySuggestion)
        XCTAssertTrue(error.recoverySuggestion?.contains("internet") ?? false)
    }
    
    func testUnknown_Recovery() {
        let error = AppError.unknown("Test")
        XCTAssertNil(error.recoverySuggestion)
    }
    
    func testCameraUnavailable_Recovery() {
        let error = AppError.cameraUnavailable
        XCTAssertNil(error.recoverySuggestion)
    }
    
    func testMultipleFacesDetected_Recovery() {
        let error = AppError.multipleFacesDetected
        XCTAssertNil(error.recoverySuggestion)
    }
    
    func testPurchaseCancelled_Recovery() {
        let error = AppError.purchaseCancelled
        XCTAssertNil(error.recoverySuggestion)
    }
    
    func testCoreDataError_Recovery() {
        let error = AppError.coreDataError("Test")
        XCTAssertNil(error.recoverySuggestion)
    }
    
    // MARK: - Is Retryable Tests
    
    func testIsRetryable_CameraPermissionDenied() {
        let error = AppError.cameraPermissionDenied
        XCTAssertFalse(error.isRetryable)
    }
    
    func testIsRetryable_CameraUnavailable() {
        let error = AppError.cameraUnavailable
        XCTAssertFalse(error.isRetryable)
    }
    
    func testIsRetryable_PurchaseCancelled() {
        let error = AppError.purchaseCancelled
        XCTAssertFalse(error.isRetryable)
    }
    
    func testIsRetryable_NoFaceDetected() {
        let error = AppError.noFaceDetected
        XCTAssertTrue(error.isRetryable)
    }
    
    func testIsRetryable_MultipleFacesDetected() {
        let error = AppError.multipleFacesDetected
        XCTAssertTrue(error.isRetryable)
    }
    
    func testIsRetryable_ProcessingFailed() {
        let error = AppError.processingFailed
        XCTAssertTrue(error.isRetryable)
    }
    
    func testIsRetryable_ProcessingTimeout() {
        let error = AppError.processingTimeout
        XCTAssertTrue(error.isRetryable)
    }
    
    func testIsRetryable_PurchaseFailed() {
        let error = AppError.purchaseFailed("Test")
        XCTAssertTrue(error.isRetryable)
    }
    
    func testIsRetryable_RestoreFailed() {
        let error = AppError.restoreFailed
        XCTAssertTrue(error.isRetryable)
    }
    
    func testIsRetryable_NetworkError() {
        let error = AppError.networkError
        XCTAssertTrue(error.isRetryable)
    }
    
    func testIsRetryable_CoreDataError() {
        let error = AppError.coreDataError("Test")
        XCTAssertTrue(error.isRetryable)
    }
    
    func testIsRetryable_Unknown() {
        let error = AppError.unknown("Test")
        XCTAssertTrue(error.isRetryable)
    }
    
    // MARK: - LocalizedError Conformance Tests
    
    func testLocalizedError_Conformance() {
        let errors: [AppError] = [
            .cameraPermissionDenied,
            .cameraUnavailable,
            .noFaceDetected,
            .multipleFacesDetected,
            .processingFailed,
            .processingTimeout,
            .purchaseFailed("Test"),
            .purchaseCancelled,
            .restoreFailed,
            .networkError,
            .coreDataError("Test"),
            .unknown("Test")
        ]
        
        for error in errors {
            // Every error should have a description
            XCTAssertNotNil(error.errorDescription, "\(error) should have errorDescription")
        }
    }
    
    // MARK: - All Cases Have Description Test
    
    func testAllCases_HaveNonEmptyDescription() {
        let errors: [AppError] = [
            .cameraPermissionDenied,
            .cameraUnavailable,
            .noFaceDetected,
            .multipleFacesDetected,
            .processingFailed,
            .processingTimeout,
            .purchaseFailed("Reason"),
            .purchaseCancelled,
            .restoreFailed,
            .networkError,
            .coreDataError("Message"),
            .unknown("Custom")
        ]
        
        for error in errors {
            XCTAssertFalse(error.errorDescription?.isEmpty ?? true, "\(error) should have non-empty description")
        }
    }
}
