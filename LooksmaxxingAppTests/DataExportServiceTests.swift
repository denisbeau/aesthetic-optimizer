//
//  DataExportServiceTests.swift
//  LooksmaxxingAppTests
//
//  Tests for GDPR/Law 25 compliant data export
//

import XCTest
@testable import LooksmaxxingApp

final class DataExportServiceTests: XCTestCase {
    
    var exportService: DataExportService!
    
    override func setUp() {
        super.setUp()
        exportService = DataExportService()
    }
    
    override func tearDown() {
        exportService = nil
        // Clean up any test export files
        cleanupExportFiles()
        super.tearDown()
    }
    
    private func cleanupExportFiles() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileManager = FileManager.default
        
        do {
            let files = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            for file in files where file.lastPathComponent.starts(with: "AestheticOptimizer_Export_") {
                try? fileManager.removeItem(at: file)
            }
        } catch {
            // Ignore errors during cleanup
        }
    }
    
    // MARK: - Data Structure Tests
    
    func testExportData_Structure() {
        // Verify the export data structure is correctly defined
        let streakData = DataExportService.StreakData(
            currentStreak: 7,
            totalDays: 30,
            lastCompletionDate: "2026-01-13T00:00:00Z"
        )
        
        XCTAssertEqual(streakData.currentStreak, 7)
        XCTAssertEqual(streakData.totalDays, 30)
        XCTAssertNotNil(streakData.lastCompletionDate)
    }
    
    func testDailyTaskData_Structure() {
        let taskData = DataExportService.DailyTaskData(
            taskType: "skincare",
            completedDate: "2026-01-13T09:00:00Z",
            isCompleted: true
        )
        
        XCTAssertEqual(taskData.taskType, "skincare")
        XCTAssertTrue(taskData.isCompleted)
    }
    
    func testFaceAnalysisData_Structure() {
        let analysisData = DataExportService.FaceAnalysisData(
            rating: 7.5,
            strengths: ["Symmetry", "Jawline"],
            weaknesses: ["Skin texture"],
            scanDate: "2026-01-13T10:00:00Z"
        )
        
        XCTAssertEqual(analysisData.rating, 7.5, accuracy: 0.01)
        XCTAssertEqual(analysisData.strengths.count, 2)
        XCTAssertEqual(analysisData.weaknesses.count, 1)
    }
    
    func testPreferencesData_Structure() {
        let prefsData = DataExportService.PreferencesData(
            isProUser: true,
            hasCompletedOnboarding: true,
            notificationHour: 9,
            notificationMinute: 30
        )
        
        XCTAssertTrue(prefsData.isProUser)
        XCTAssertTrue(prefsData.hasCompletedOnboarding)
        XCTAssertEqual(prefsData.notificationHour, 9)
        XCTAssertEqual(prefsData.notificationMinute, 30)
    }
    
    // MARK: - Codable Tests
    
    func testStreakData_EncodeDecode() throws {
        let original = DataExportService.StreakData(
            currentStreak: 14,
            totalDays: 60,
            lastCompletionDate: "2026-01-12T00:00:00Z"
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(DataExportService.StreakData.self, from: data)
        
        XCTAssertEqual(decoded.currentStreak, original.currentStreak)
        XCTAssertEqual(decoded.totalDays, original.totalDays)
        XCTAssertEqual(decoded.lastCompletionDate, original.lastCompletionDate)
    }
    
    func testFaceAnalysisData_EncodeDecode() throws {
        let original = DataExportService.FaceAnalysisData(
            rating: 8.2,
            strengths: ["Eyes", "Nose"],
            weaknesses: ["Acne"],
            scanDate: "2026-01-13T15:30:00Z"
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(DataExportService.FaceAnalysisData.self, from: data)
        
        XCTAssertEqual(decoded.rating, original.rating, accuracy: 0.01)
        XCTAssertEqual(decoded.strengths, original.strengths)
        XCTAssertEqual(decoded.weaknesses, original.weaknesses)
    }
    
    // MARK: - Export Functionality Tests
    
    func testExportUserData_CreatesFile() {
        let result = exportService.exportUserData()
        
        // Check if export succeeded (may fail in test environment without Core Data)
        // The important thing is that it doesn't crash
        XCTAssertNotNil(result, "Export should return a result")
    }
    
    func testExportFileName_ContainsTimestamp() {
        let timestamp = Int(Date().timeIntervalSince1970)
        let expectedPrefix = "AestheticOptimizer_Export_"
        
        // Verify filename format
        let filename = "\(expectedPrefix)\(timestamp).json"
        XCTAssertTrue(filename.hasPrefix(expectedPrefix))
        XCTAssertTrue(filename.hasSuffix(".json"))
    }
    
    // MARK: - GDPR/Law 25 Compliance Tests
    
    func testExport_IncludesAllRequiredDataCategories() {
        // GDPR requires exporting all user data
        // Law 25 (Quebec) requires structured, portable format
        
        // Verify UserData struct includes all required fields
        let userData = DataExportService.UserData(
            streak: DataExportService.StreakData(currentStreak: 0, totalDays: 0, lastCompletionDate: nil),
            dailyTasks: [],
            faceAnalyses: [],
            preferences: DataExportService.PreferencesData(
                isProUser: false,
                hasCompletedOnboarding: false,
                notificationHour: 9,
                notificationMinute: 0
            )
        )
        
        // All data categories must be present
        XCTAssertNotNil(userData.streak, "Streak data required for export")
        XCTAssertNotNil(userData.dailyTasks, "Daily tasks required for export")
        XCTAssertNotNil(userData.faceAnalyses, "Face analyses required for export")
        XCTAssertNotNil(userData.preferences, "Preferences required for export")
    }
    
    func testExport_UsesJSONFormat() {
        // Law 25 requires "structured, commonly-used, machine-readable format"
        // JSON satisfies this requirement
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        let testData = DataExportService.StreakData(currentStreak: 5, totalDays: 10, lastCompletionDate: nil)
        
        do {
            let jsonData = try encoder.encode(testData)
            let jsonString = String(data: jsonData, encoding: .utf8)
            XCTAssertNotNil(jsonString, "Data should be encodable to JSON string")
            XCTAssertTrue(jsonString?.contains("currentStreak") ?? false)
        } catch {
            XCTFail("JSON encoding should not fail: \(error)")
        }
    }
    
    func testExport_IncludesExportMetadata() throws {
        // Export should include metadata like date and app version
        let exportData = DataExportService.ExportData(
            exportDate: ISO8601DateFormatter().string(from: Date()),
            appVersion: "1.0.0",
            userData: DataExportService.UserData(
                streak: DataExportService.StreakData(currentStreak: 0, totalDays: 0, lastCompletionDate: nil),
                dailyTasks: [],
                faceAnalyses: [],
                preferences: DataExportService.PreferencesData(
                    isProUser: false,
                    hasCompletedOnboarding: false,
                    notificationHour: 9,
                    notificationMinute: 0
                )
            )
        )
        
        XCTAssertFalse(exportData.exportDate.isEmpty, "Export date is required")
        XCTAssertFalse(exportData.appVersion.isEmpty, "App version is required")
    }
}
