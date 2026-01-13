//
//  CoreMLService.swift
//  LooksmaxxingApp
//
//  AI facial analysis service
//  MVP: Uses Vision framework with simple heuristics
//  Production: Replace with trained Core ML model
//

import Foundation
import UIKit
import Vision

class CoreMLService {
    static let shared = CoreMLService()
    
    // MARK: - Predefined Analysis Content
    
    private let strengths = [
        "Strong jawline definition",
        "Symmetrical facial features",
        "Clear, healthy skin",
        "Well-proportioned face",
        "Defined cheekbones",
        "Balanced eye spacing",
        "Good facial harmony",
        "Strong chin projection",
        "Healthy skin tone",
        "Well-defined brow ridge"
    ]
    
    private let weaknesses = [
        "Improve jawline definition",
        "Enhance skin clarity",
        "Balance facial symmetry",
        "Optimize eye spacing",
        "Refine facial proportions",
        "Strengthen cheekbone definition",
        "Improve chin projection",
        "Work on facial harmony",
        "Enhance brow definition",
        "Focus on skin health"
    ]
    
    private init() {}
    
    // MARK: - Analyze Face
    
    func analyzeFace(frontImage: UIImage, sideImage: UIImage) async throws -> FaceAnalysisResult {
        let startTime = Date()
        
        // Convert to CGImage
        guard let frontCGImage = frontImage.cgImage else {
            throw AppError.processingFailed
        }
        
        // Detect face landmarks using Vision
        let request = VNDetectFaceLandmarksRequest()
        let handler = VNImageRequestHandler(cgImage: frontCGImage, options: [:])
        
        try handler.perform([request])
        
        guard let observation = request.results?.first else {
            throw AppError.noFaceDetected
        }
        
        // Check for multiple faces
        if let results = request.results, results.count > 1 {
            throw AppError.multipleFacesDetected
        }
        
        // Calculate metrics from face observation
        let faceMetrics = calculateFaceMetrics(observation: observation)
        
        // Calculate rating based on metrics
        var baseRating = calculateBaseRating(metrics: faceMetrics)
        
        // Add variable reward (±0.2 randomization for curiosity gap)
        let randomVariation = Double.random(in: -0.2...0.2)
        let finalRating = min(10.0, max(1.0, baseRating + randomVariation))
        
        // Select strengths and weaknesses based on metrics
        let selectedStrengths = selectStrengths(metrics: faceMetrics, count: 3)
        let selectedWeaknesses = selectWeaknesses(metrics: faceMetrics, count: 3)
        
        let processingTime = Date().timeIntervalSince(startTime)
        
        return FaceAnalysisResult(
            rating: finalRating,
            strengths: selectedStrengths,
            weaknesses: selectedWeaknesses,
            processingTime: processingTime
        )
    }
    
    // MARK: - Face Metrics Calculation
    
    private struct FaceMetrics {
        let symmetry: Double      // 0-1, higher is more symmetric
        let aspectRatio: Double   // width/height
        let jawlineAngle: Double  // estimated from bounding box
        let eyeSpacing: Double    // relative to face width
        let faceWidth: Double
        let faceHeight: Double
    }
    
    private func calculateFaceMetrics(observation: VNFaceObservation) -> FaceMetrics {
        let boundingBox = observation.boundingBox
        let faceWidth = boundingBox.width
        let faceHeight = boundingBox.height
        let aspectRatio = faceWidth / faceHeight
        
        // Calculate symmetry from landmarks if available
        var symmetry: Double = 0.8 // Default to good symmetry
        
        if let landmarks = observation.landmarks {
            // Check eye position symmetry
            if let leftEye = landmarks.leftEye, let rightEye = landmarks.rightEye {
                let leftCenter = leftEye.normalizedPoints.reduce(CGPoint.zero) { 
                    CGPoint(x: $0.x + $1.x, y: $0.y + $1.y) 
                }
                let rightCenter = rightEye.normalizedPoints.reduce(CGPoint.zero) { 
                    CGPoint(x: $0.x + $1.x, y: $0.y + $1.y) 
                }
                
                let leftCount = CGFloat(leftEye.pointCount)
                let rightCount = CGFloat(rightEye.pointCount)
                
                if leftCount > 0 && rightCount > 0 {
                    let leftY = leftCenter.y / leftCount
                    let rightY = rightCenter.y / rightCount
                    let eyeSymmetry = 1.0 - abs(leftY - rightY)
                    symmetry = min(1.0, eyeSymmetry * 1.2) // Scale up slightly
                }
            }
        }
        
        // Estimate jawline angle from bounding box shape
        let jawlineAngle = aspectRatio > 0.75 ? 0.7 : 0.5
        
        // Eye spacing estimation
        let eyeSpacing = 0.3 + (aspectRatio * 0.1)
        
        return FaceMetrics(
            symmetry: symmetry,
            aspectRatio: aspectRatio,
            jawlineAngle: jawlineAngle,
            eyeSpacing: eyeSpacing,
            faceWidth: faceWidth,
            faceHeight: faceHeight
        )
    }
    
    // MARK: - Rating Calculation
    
    private func calculateBaseRating(metrics: FaceMetrics) -> Double {
        var rating: Double = 6.5 // Start with above average
        
        // Symmetry contribution (up to +1.5)
        rating += (metrics.symmetry - 0.5) * 3.0
        
        // Aspect ratio contribution (ideal is 0.75-0.85)
        if metrics.aspectRatio > 0.7 && metrics.aspectRatio < 0.9 {
            rating += 0.5 // Good proportions
        } else if metrics.aspectRatio > 0.6 && metrics.aspectRatio < 1.0 {
            rating += 0.2 // Acceptable proportions
        }
        
        // Jawline contribution
        rating += metrics.jawlineAngle * 0.5
        
        // Ensure within bounds
        return min(9.5, max(4.0, rating))
    }
    
    // MARK: - Strength/Weakness Selection
    
    private func selectStrengths(metrics: FaceMetrics, count: Int) -> [String] {
        var selected: [String] = []
        
        // Add based on actual metrics
        if metrics.symmetry > 0.75 {
            selected.append("Symmetrical facial features")
        }
        if metrics.aspectRatio > 0.7 && metrics.aspectRatio < 0.85 {
            selected.append("Well-proportioned face")
        }
        if metrics.jawlineAngle > 0.6 {
            selected.append("Strong jawline definition")
        }
        
        // Fill remaining with random strengths
        let remaining = strengths.filter { !selected.contains($0) }.shuffled()
        while selected.count < count && !remaining.isEmpty {
            if let next = remaining.first(where: { !selected.contains($0) }) {
                selected.append(next)
            }
        }
        
        return Array(selected.prefix(count))
    }
    
    private func selectWeaknesses(metrics: FaceMetrics, count: Int) -> [String] {
        var selected: [String] = []
        
        // Add based on actual metrics
        if metrics.symmetry < 0.7 {
            selected.append("Balance facial symmetry")
        }
        if metrics.aspectRatio < 0.7 || metrics.aspectRatio > 0.9 {
            selected.append("Refine facial proportions")
        }
        if metrics.jawlineAngle < 0.5 {
            selected.append("Improve jawline definition")
        }
        
        // Fill remaining with random weaknesses
        let remaining = weaknesses.filter { !selected.contains($0) }.shuffled()
        while selected.count < count && !remaining.isEmpty {
            if let next = remaining.first(where: { !selected.contains($0) }) {
                selected.append(next)
            }
        }
        
        return Array(selected.prefix(count))
    }
}
