//
//  ScanViewModel.swift
//  LooksmaxxingApp
//
//  Handles camera capture and AI processing flow
//

import Foundation
import SwiftUI
import AVFoundation
import Combine

@MainActor
class ScanViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var frontImage: UIImage?
    @Published var sideImage: UIImage?
    @Published var isProcessing: Bool = false
    @Published var processingProgress: Double = 0.0
    @Published var analysisResult: FaceAnalysisResult?
    @Published var error: AppError?
    @Published var captureMode: CaptureMode = .front
    
    // MARK: - Capture Mode
    
    enum CaptureMode {
        case front
        case side
        case complete
        
        var instruction: String {
            switch self {
            case .front: return "Position your face in the frame and look straight ahead"
            case .side: return "Turn your head to show your side profile"
            case .complete: return "Photos captured! Analyzing..."
            }
        }
        
        var buttonTitle: String {
            switch self {
            case .front: return "Capture Front"
            case .side: return "Capture Side"
            case .complete: return "Processing..."
            }
        }
    }
    
    // MARK: - Camera Service
    
    private let coreMLService = CoreMLService.shared
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - Photo Capture
    
    func captureFront(_ image: UIImage) {
        frontImage = image
        captureMode = .side
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
    
    func captureSide(_ image: UIImage) {
        sideImage = image
        captureMode = .complete
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Start processing
        Task {
            await processImages()
        }
    }
    
    // MARK: - Process Images
    
    func processImages() async {
        guard let front = frontImage, let side = sideImage else {
            error = .processingFailed
            return
        }
        
        isProcessing = true
        processingProgress = 0.0
        error = nil
        
        // Animate progress
        await animateProgress()
        
        do {
            // Analyze images
            let result = try await coreMLService.analyzeFace(frontImage: front, sideImage: side)
            
            // Save to Core Data
            coreDataManager.createFaceAnalysis(
                rating: result.rating,
                strengths: result.strengths,
                weaknesses: result.weaknesses
            )
            
            analysisResult = result
            
            // Success haptic
            let feedback = UINotificationFeedbackGenerator()
            feedback.notificationOccurred(.success)
            
        } catch let appError as AppError {
            error = appError
            
            // Error haptic
            let feedback = UINotificationFeedbackGenerator()
            feedback.notificationOccurred(.error)
        } catch {
            self.error = .processingFailed
        }
        
        isProcessing = false
    }
    
    // MARK: - Progress Animation
    
    private func animateProgress() async {
        let steps = 20
        let stepDuration: UInt64 = 40_000_000 // 40ms per step = 800ms total
        
        for i in 0...steps {
            processingProgress = Double(i) / Double(steps)
            try? await Task.sleep(nanoseconds: stepDuration)
        }
    }
    
    // MARK: - Reset
    
    func reset() {
        frontImage = nil
        sideImage = nil
        isProcessing = false
        processingProgress = 0.0
        analysisResult = nil
        error = nil
        captureMode = .front
    }
}
