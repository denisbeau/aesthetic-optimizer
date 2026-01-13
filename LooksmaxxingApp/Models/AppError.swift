//
//  AppError.swift
//  LooksmaxxingApp
//
//  Centralized error handling with user-friendly messages
//

import Foundation

enum AppError: LocalizedError, Equatable {
    case cameraPermissionDenied
    case cameraUnavailable
    case noFaceDetected
    case multipleFacesDetected
    case processingFailed
    case processingTimeout
    case purchaseFailed(String)
    case purchaseCancelled
    case restoreFailed
    case networkError
    case coreDataError(String)
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .cameraPermissionDenied:
            return "Camera access is required. Please enable in Settings."
        case .cameraUnavailable:
            return "Camera is not available on this device."
        case .noFaceDetected:
            return "No face detected. Please try again with better lighting and position your face clearly in the frame."
        case .multipleFacesDetected:
            return "Multiple faces detected. Please ensure only one face is in the frame."
        case .processingFailed:
            return "Analysis failed. Please try again."
        case .processingTimeout:
            return "Processing took too long. Please try again."
        case .purchaseFailed(let message):
            return "Purchase failed: \(message)"
        case .purchaseCancelled:
            return "Purchase was cancelled."
        case .restoreFailed:
            return "Could not restore purchases. Please try again."
        case .networkError:
            return "Network error. Please check your connection."
        case .coreDataError(let message):
            return "Data error: \(message)"
        case .unknown(let message):
            return message
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .cameraPermissionDenied:
            return "Tap the button below to open Settings and enable camera access."
        case .noFaceDetected:
            return "Make sure you're in a well-lit area and your full face is visible."
        case .processingFailed, .processingTimeout:
            return "Try taking a new photo."
        case .purchaseFailed, .restoreFailed:
            return "Please try again or contact support."
        case .networkError:
            return "Check your internet connection and try again."
        default:
            return nil
        }
    }
    
    var isRetryable: Bool {
        switch self {
        case .cameraPermissionDenied, .cameraUnavailable, .purchaseCancelled:
            return false
        default:
            return true
        }
    }
}
