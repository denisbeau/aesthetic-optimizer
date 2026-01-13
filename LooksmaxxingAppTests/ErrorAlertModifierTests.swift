//
//  ErrorAlertModifierTests.swift
//  LooksmaxxingAppTests
//
//  Tests for unified error handling
//

import XCTest
@testable import LooksmaxxingApp

final class ErrorAlertModifierTests: XCTestCase {
    
    var errorManager: ErrorAlertManager!
    
    override func setUp() {
        super.setUp()
        errorManager = ErrorAlertManager.shared
        errorManager.isShowing = false
        errorManager.title = ""
        errorManager.message = ""
        errorManager.actionTitle = "OK"
        errorManager.action = nil
    }
    
    override func tearDown() {
        errorManager.isShowing = false
        errorManager = nil
        super.tearDown()
    }
    
    // MARK: - Singleton Tests
    
    func testErrorAlertManager_IsSingleton() {
        let instance1 = ErrorAlertManager.shared
        let instance2 = ErrorAlertManager.shared
        XCTAssertTrue(instance1 === instance2, "Should be same instance")
    }
    
    func testErrorAlertManager_InitialState() {
        // Reset to initial state
        errorManager.isShowing = false
        errorManager.title = ""
        errorManager.message = ""
        
        XCTAssertFalse(errorManager.isShowing)
        XCTAssertTrue(errorManager.title.isEmpty)
        XCTAssertTrue(errorManager.message.isEmpty)
        XCTAssertEqual(errorManager.actionTitle, "OK")
        XCTAssertNil(errorManager.action)
    }
    
    // MARK: - Error Display Tests
    
    func testShow_NoFaceDetected() {
        errorManager.show(.noFaceDetected)
        
        XCTAssertTrue(errorManager.isShowing)
        XCTAssertEqual(errorManager.title, "No Face Detected")
        XCTAssertTrue(errorManager.message.contains("face"))
    }
    
    func testShow_MultipleFacesDetected() {
        errorManager.show(.multipleFacesDetected)
        
        XCTAssertTrue(errorManager.isShowing)
        XCTAssertEqual(errorManager.title, "Multiple Faces")
        XCTAssertTrue(errorManager.message.contains("one face"))
    }
    
    func testShow_CameraUnavailable() {
        errorManager.show(.cameraUnavailable)
        
        XCTAssertTrue(errorManager.isShowing)
        XCTAssertEqual(errorManager.title, "Camera Unavailable")
    }
    
    func testShow_CameraPermissionDenied() {
        errorManager.show(.cameraPermissionDenied)
        
        XCTAssertTrue(errorManager.isShowing)
        XCTAssertEqual(errorManager.title, "Camera Access Required")
        XCTAssertEqual(errorManager.actionTitle, "Open Settings")
        XCTAssertNotNil(errorManager.action, "Should have action to open settings")
    }
    
    func testShow_ProcessingFailed() {
        errorManager.show(.processingFailed)
        
        XCTAssertTrue(errorManager.isShowing)
        XCTAssertEqual(errorManager.title, "Processing Error")
    }
    
    func testShow_ProcessingTimeout() {
        errorManager.show(.processingTimeout)
        
        XCTAssertTrue(errorManager.isShowing)
        XCTAssertEqual(errorManager.title, "Processing Timeout")
    }
    
    func testShow_PurchaseFailed() {
        let reason = "Card declined"
        errorManager.show(.purchaseFailed(reason: reason))
        
        XCTAssertTrue(errorManager.isShowing)
        XCTAssertEqual(errorManager.title, "Purchase Failed")
        XCTAssertEqual(errorManager.message, reason)
    }
    
    func testShow_PurchaseCancelled() {
        errorManager.show(.purchaseCancelled)
        
        XCTAssertTrue(errorManager.isShowing)
        XCTAssertEqual(errorManager.title, "Purchase Cancelled")
    }
    
    func testShow_RestoreFailed() {
        errorManager.show(.restoreFailed)
        
        XCTAssertTrue(errorManager.isShowing)
        XCTAssertEqual(errorManager.title, "Restore Failed")
    }
    
    func testShow_NetworkError() {
        errorManager.show(.networkError)
        
        XCTAssertTrue(errorManager.isShowing)
        XCTAssertEqual(errorManager.title, "Connection Error")
    }
    
    func testShow_CoreDataError() {
        let detail = "Failed to save"
        errorManager.show(.coreDataError(detail: detail))
        
        XCTAssertTrue(errorManager.isShowing)
        XCTAssertEqual(errorManager.title, "Data Error")
        XCTAssertTrue(errorManager.message.contains(detail))
    }
    
    func testShow_Unknown_WithDetail() {
        let detail = "Something unexpected"
        errorManager.show(.unknown(detail: detail))
        
        XCTAssertTrue(errorManager.isShowing)
        XCTAssertEqual(errorManager.title, "Something Went Wrong")
        XCTAssertEqual(errorManager.message, detail)
    }
    
    func testShow_Unknown_EmptyDetail() {
        errorManager.show(.unknown(detail: ""))
        
        XCTAssertTrue(errorManager.isShowing)
        XCTAssertEqual(errorManager.title, "Something Went Wrong")
        XCTAssertTrue(errorManager.message.contains("unexpected"))
    }
    
    // MARK: - Action Tests
    
    func testDefaultAction_IsNil() {
        errorManager.show(.noFaceDetected)
        XCTAssertNil(errorManager.action)
    }
    
    func testCameraPermission_HasAction() {
        errorManager.show(.cameraPermissionDenied)
        XCTAssertNotNil(errorManager.action)
    }
    
    func testActionTitle_DefaultsToOK() {
        errorManager.show(.processingFailed)
        XCTAssertEqual(errorManager.actionTitle, "OK")
    }
    
    func testActionTitle_OpenSettings_ForCameraPermission() {
        errorManager.show(.cameraPermissionDenied)
        XCTAssertEqual(errorManager.actionTitle, "Open Settings")
    }
    
    // MARK: - User-Friendly Message Tests
    
    func testMessages_AreUserFriendly() {
        // Messages should not contain technical jargon
        errorManager.show(.processingFailed)
        
        XCTAssertFalse(errorManager.message.contains("error code"))
        XCTAssertFalse(errorManager.message.contains("exception"))
        XCTAssertFalse(errorManager.message.contains("stack trace"))
    }
    
    func testMessages_ProvideGuidance() {
        // Messages should tell user what to do
        errorManager.show(.noFaceDetected)
        
        // Should contain actionable guidance
        let hasGuidance = errorManager.message.contains("Please") ||
                          errorManager.message.contains("Try") ||
                          errorManager.message.contains("make sure")
        XCTAssertTrue(hasGuidance, "Error message should provide guidance")
    }
    
    // MARK: - State Reset Tests
    
    func testShow_ResetsActionForNonCameraErrors() {
        // First show camera permission (which sets action)
        errorManager.show(.cameraPermissionDenied)
        XCTAssertNotNil(errorManager.action)
        
        // Then show different error
        errorManager.show(.noFaceDetected)
        XCTAssertNil(errorManager.action, "Action should be reset for non-camera errors")
    }
}
