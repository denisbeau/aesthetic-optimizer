//
//  DataExportService.swift
//  LooksmaxxingApp
//
//  GDPR/Law 25 compliant data export functionality
//

import Foundation

class DataExportService {
    
    struct ExportData: Codable {
        let exportDate: String
        let appVersion: String
        let userData: UserData
    }
    
    struct UserData: Codable {
        let streak: StreakData
        let dailyTasks: [DailyTaskData]
        let faceAnalyses: [FaceAnalysisData]
        let preferences: PreferencesData
    }
    
    struct StreakData: Codable {
        let currentStreak: Int
        let totalDays: Int
        let lastCompletionDate: String?
    }
    
    struct DailyTaskData: Codable {
        let taskType: String
        let completedDate: String
        let isCompleted: Bool
    }
    
    struct FaceAnalysisData: Codable {
        let rating: Double
        let strengths: [String]
        let weaknesses: [String]
        let scanDate: String
    }
    
    struct PreferencesData: Codable {
        let isProUser: Bool
        let hasCompletedOnboarding: Bool
        let notificationHour: Int
        let notificationMinute: Int
    }
    
    func exportUserData() -> Bool {
        let dateFormatter = ISO8601DateFormatter()
        
        // Gather streak data
        let streakEntity = CoreDataManager.shared.fetchStreak()
        let streakData = StreakData(
            currentStreak: Int(streakEntity?.currentStreak ?? 0),
            totalDays: Int(streakEntity?.totalDays ?? 0),
            lastCompletionDate: streakEntity?.lastCompletionDate.map { dateFormatter.string(from: $0) }
        )
        
        // Gather daily tasks
        let dailyTasks = CoreDataManager.shared.fetchDailyTasks(for: Date())
        let dailyTasksData = dailyTasks.map { task in
            DailyTaskData(
                taskType: task.taskType ?? "",
                completedDate: dateFormatter.string(from: task.completedDate ?? Date()),
                isCompleted: task.isCompleted
            )
        }
        
        // Gather face analyses
        let analyses = CoreDataManager.shared.fetchFaceAnalyses()
        let analysesData = analyses.map { analysis in
            FaceAnalysisData(
                rating: analysis.rating,
                strengths: (analysis.strengths as? [String]) ?? [],
                weaknesses: (analysis.weaknesses as? [String]) ?? [],
                scanDate: dateFormatter.string(from: analysis.scanDate ?? Date())
            )
        }
        
        // Gather preferences
        let preferencesData = PreferencesData(
            isProUser: UserDefaults.standard.isProUser,
            hasCompletedOnboarding: UserDefaults.standard.bool(forKey: "hasCompletedOnboarding"),
            notificationHour: UserDefaults.standard.integer(forKey: "notificationHour"),
            notificationMinute: UserDefaults.standard.integer(forKey: "notificationMinute")
        )
        
        // Build export
        let userData = UserData(
            streak: streakData,
            dailyTasks: dailyTasksData,
            faceAnalyses: analysesData,
            preferences: preferencesData
        )
        
        let exportData = ExportData(
            exportDate: dateFormatter.string(from: Date()),
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0",
            userData: userData
        )
        
        // Save to Documents
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let jsonData = try encoder.encode(exportData)
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("AestheticOptimizer_Export_\(Int(Date().timeIntervalSince1970)).json")
            
            try jsonData.write(to: fileURL)
            return true
        } catch {
            print("Export failed: \(error)")
            return false
        }
    }
}
