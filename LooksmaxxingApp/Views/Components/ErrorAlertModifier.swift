//
//  ErrorAlertModifier.swift
//  LooksmaxxingApp
//
//  Unified error handling with user-friendly messages
//

import SwiftUI

// MARK: - Error Alert Manager

class ErrorAlertManager: ObservableObject {
    static let shared = ErrorAlertManager()
    
    @Published var isShowing = false
    @Published var title = ""
    @Published var message = ""
    @Published var actionTitle = "OK"
    @Published var action: (() -> Void)?
    
    func show(_ error: AppError) {
        switch error {
        case .noFaceDetected:
            title = "No Face Detected"
            message = "Please make sure your face is clearly visible and well-lit. Try moving to a brighter area."
            
        case .multipleFacesDetected:
            title = "Multiple Faces"
            message = "Please ensure only one face is in the frame for accurate analysis."
            
        case .cameraUnavailable:
            title = "Camera Unavailable"
            message = "Unable to access your camera. Please check your device settings."
            
        case .cameraPermissionDenied:
            showCameraPermissionDenied()
            return
            
        case .processingFailed:
            title = "Processing Error"
            message = "Something went wrong while analyzing your photo. Please try again."
            
        case .processingTimeout:
            title = "Processing Timeout"
            message = "Analysis took too long. Please try again."
            
        case .purchaseFailed(let reason):
            title = "Purchase Failed"
            message = reason
            
        case .purchaseCancelled:
            title = "Purchase Cancelled"
            message = "Your purchase was cancelled."
            
        case .restoreFailed:
            title = "Restore Failed"
            message = "Unable to restore your purchases. Please check your internet connection and try again."
            
        case .networkError:
            title = "Connection Error"
            message = "Please check your internet connection and try again."
            
        case .coreDataError(let detail):
            title = "Data Error"
            message = "There was a problem with your data: \(detail)"
            
        case .unknown(let detail):
            title = "Something Went Wrong"
            message = detail.isEmpty ? "An unexpected error occurred. Please try again." : detail
        }
        
        actionTitle = "OK"
        action = nil
        isShowing = true
    }
    
    func showCameraPermissionDenied() {
        title = "Camera Access Required"
        message = "To analyze your facial features, we need access to your camera. Please enable camera access in Settings."
        actionTitle = "Open Settings"
        action = {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        isShowing = true
    }
}

// MARK: - View Modifier

struct ErrorAlertModifier: ViewModifier {
    @ObservedObject var errorManager = ErrorAlertManager.shared
    
    func body(content: Content) -> some View {
        content
            .alert(errorManager.title, isPresented: $errorManager.isShowing) {
                Button(errorManager.actionTitle) {
                    errorManager.action?()
                }
                if errorManager.action != nil {
                    Button("Cancel", role: .cancel) {}
                }
            } message: {
                Text(errorManager.message)
            }
    }
}

extension View {
    func withErrorAlert() -> some View {
        modifier(ErrorAlertModifier())
    }
}
