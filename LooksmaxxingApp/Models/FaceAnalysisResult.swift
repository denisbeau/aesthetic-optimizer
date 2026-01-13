//
//  FaceAnalysisResult.swift
//  LooksmaxxingApp
//
//  Model for face analysis results from CoreML processing
//

import Foundation

struct FaceAnalysisResult: Identifiable, Codable {
    let id: UUID
    let rating: Double
    let strengths: [String]
    let weaknesses: [String]
    let scanDate: Date
    let processingTime: TimeInterval
    
    init(
        id: UUID = UUID(),
        rating: Double,
        strengths: [String],
        weaknesses: [String],
        scanDate: Date = Date(),
        processingTime: TimeInterval
    ) {
        self.id = id
        self.rating = rating
        self.strengths = strengths
        self.weaknesses = weaknesses
        self.scanDate = scanDate
        self.processingTime = processingTime
    }
    
    // MARK: - Computed Properties
    
    /// Rating formatted as string (e.g., "7.2")
    var ratingFormatted: String {
        String(format: "%.1f", rating)
    }
    
    /// First strength (for free tier display)
    var topStrength: String {
        strengths.first ?? "Analyzing..."
    }
    
    /// First weakness (blurred for free tier)
    var topWeakness: String {
        weaknesses.first ?? "Analyzing..."
    }
}

// MARK: - Mock Data for Previews

extension FaceAnalysisResult {
    static let mockResult = FaceAnalysisResult(
        rating: 7.2,
        strengths: ["Strong jawline definition", "Symmetrical facial features", "Clear, healthy skin"],
        weaknesses: ["Improve jawline definition", "Enhance skin clarity", "Balance facial symmetry"],
        processingTime: 0.45
    )
}
