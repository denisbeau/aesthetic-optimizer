//
//  FaceAnalysisResultTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for FaceAnalysisResult model
//

import XCTest
@testable import LooksmaxxingApp

final class FaceAnalysisResultTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        let result = FaceAnalysisResult(
            rating: 7.5,
            strengths: ["Strong jawline", "Good symmetry"],
            weaknesses: ["Skin clarity"],
            processingTime: 0.5
        )
        
        XCTAssertEqual(result.rating, 7.5)
        XCTAssertEqual(result.strengths.count, 2)
        XCTAssertEqual(result.weaknesses.count, 1)
        XCTAssertEqual(result.processingTime, 0.5)
        XCTAssertNotNil(result.id)
        XCTAssertNotNil(result.scanDate)
    }
    
    func testDefaultScanDate() {
        let before = Date()
        let result = FaceAnalysisResult(
            rating: 7.0,
            strengths: [],
            weaknesses: [],
            processingTime: 0.3
        )
        let after = Date()
        
        XCTAssertGreaterThanOrEqual(result.scanDate, before)
        XCTAssertLessThanOrEqual(result.scanDate, after)
    }
    
    func testUniqueIDs() {
        let result1 = FaceAnalysisResult(rating: 7.0, strengths: [], weaknesses: [], processingTime: 0.1)
        let result2 = FaceAnalysisResult(rating: 7.0, strengths: [], weaknesses: [], processingTime: 0.1)
        
        XCTAssertNotEqual(result1.id, result2.id)
    }
    
    // MARK: - Rating Formatted Tests
    
    func testRatingFormatted_WholeNumber() {
        let result = FaceAnalysisResult(rating: 7.0, strengths: [], weaknesses: [], processingTime: 0.1)
        XCTAssertEqual(result.ratingFormatted, "7.0")
    }
    
    func testRatingFormatted_OneDecimal() {
        let result = FaceAnalysisResult(rating: 7.5, strengths: [], weaknesses: [], processingTime: 0.1)
        XCTAssertEqual(result.ratingFormatted, "7.5")
    }
    
    func testRatingFormatted_MultipleDecimals() {
        let result = FaceAnalysisResult(rating: 7.567, strengths: [], weaknesses: [], processingTime: 0.1)
        XCTAssertEqual(result.ratingFormatted, "7.6") // Rounded
    }
    
    func testRatingFormatted_MinRating() {
        let result = FaceAnalysisResult(rating: 1.0, strengths: [], weaknesses: [], processingTime: 0.1)
        XCTAssertEqual(result.ratingFormatted, "1.0")
    }
    
    func testRatingFormatted_MaxRating() {
        let result = FaceAnalysisResult(rating: 10.0, strengths: [], weaknesses: [], processingTime: 0.1)
        XCTAssertEqual(result.ratingFormatted, "10.0")
    }
    
    // MARK: - Top Strength Tests
    
    func testTopStrength_WithStrengths() {
        let result = FaceAnalysisResult(
            rating: 7.0,
            strengths: ["Strong jawline", "Good symmetry"],
            weaknesses: [],
            processingTime: 0.1
        )
        XCTAssertEqual(result.topStrength, "Strong jawline")
    }
    
    func testTopStrength_EmptyStrengths() {
        let result = FaceAnalysisResult(
            rating: 7.0,
            strengths: [],
            weaknesses: [],
            processingTime: 0.1
        )
        XCTAssertEqual(result.topStrength, "Analyzing...")
    }
    
    // MARK: - Top Weakness Tests
    
    func testTopWeakness_WithWeaknesses() {
        let result = FaceAnalysisResult(
            rating: 7.0,
            strengths: [],
            weaknesses: ["Skin clarity", "Facial proportions"],
            processingTime: 0.1
        )
        XCTAssertEqual(result.topWeakness, "Skin clarity")
    }
    
    func testTopWeakness_EmptyWeaknesses() {
        let result = FaceAnalysisResult(
            rating: 7.0,
            strengths: [],
            weaknesses: [],
            processingTime: 0.1
        )
        XCTAssertEqual(result.topWeakness, "Analyzing...")
    }
    
    // MARK: - Codable Tests
    
    func testEncodeDecode() throws {
        let original = FaceAnalysisResult(
            rating: 8.2,
            strengths: ["Jawline", "Symmetry"],
            weaknesses: ["Skin"],
            processingTime: 0.75
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(FaceAnalysisResult.self, from: data)
        
        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.rating, original.rating)
        XCTAssertEqual(decoded.strengths, original.strengths)
        XCTAssertEqual(decoded.weaknesses, original.weaknesses)
        XCTAssertEqual(decoded.processingTime, original.processingTime)
    }
    
    // MARK: - Mock Data Tests
    
    func testMockResult() {
        let mock = FaceAnalysisResult.mockResult
        
        XCTAssertEqual(mock.rating, 7.2)
        XCTAssertEqual(mock.strengths.count, 3)
        XCTAssertEqual(mock.weaknesses.count, 3)
        XCTAssertGreaterThan(mock.processingTime, 0)
    }
    
    // MARK: - Edge Cases
    
    func testRatingBounds_BelowMin() {
        let result = FaceAnalysisResult(rating: 0.5, strengths: [], weaknesses: [], processingTime: 0.1)
        // Model allows any rating, bounds checking is in CoreMLService
        XCTAssertEqual(result.rating, 0.5)
    }
    
    func testRatingBounds_AboveMax() {
        let result = FaceAnalysisResult(rating: 11.0, strengths: [], weaknesses: [], processingTime: 0.1)
        // Model allows any rating, bounds checking is in CoreMLService
        XCTAssertEqual(result.rating, 11.0)
    }
}
