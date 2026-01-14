//
//  OnboardingQuizData.swift
//  LooksmaxxingApp
//
//  Observable data model for 12-question quiz answers
//  Used to personalize paywall, results, and recommendations
//

import Foundation

class OnboardingQuizData: ObservableObject {
    // Core quiz answers
    @Published var goal: String = ""
    @Published var ageGroup: String = ""
    @Published var photoConfidence: String = ""
    @Published var struggles: String = ""
    @Published var hasRoutine: String = ""
    @Published var sleepHours: String = ""
    @Published var dailyCommitment: String = ""
    @Published var timeframe: String = ""
    @Published var blockers: String = ""
    @Published var breathingType: String = ""
    @Published var dedicationLevel: Int = 5
    
    // MARK: - Computed Properties for Personalization
    
    var isHighlyDedicated: Bool {
        dedicationLevel >= 8
    }
    
    var potentialScore: Double {
        // Base potential increases with dedication
        let base = 6.5
        let dedication = Double(dedicationLevel) * 0.2
        return min(9.5, base + dedication)
    }
    
    var potentialScoreFormatted: String {
        String(format: "%.1f", potentialScore)
    }
    
    var improvementTimeframe: String {
        if timeframe.contains("2 weeks") { return "14 days" }
        if timeframe.contains("1 month") { return "30 days" }
        return "90 days"
    }
    
    var criticalAreasCount: Int {
        // More critical areas if they have more issues
        var count = 2
        if hasRoutine.contains("None") { count += 1 }
        if breathingType.contains("Mouth") { count += 1 }
        if sleepHours.contains("Less than 6") { count += 1 }
        return min(5, count)
    }
    
    // Strip emoji prefix for cleaner display
    var primaryGoal: String {
        let stripped = goal.components(separatedBy: " ").dropFirst().joined(separator: " ")
        return stripped.isEmpty ? goal : stripped
    }
    
    var primaryStruggle: String {
        let stripped = struggles.components(separatedBy: " ").dropFirst().joined(separator: " ")
        return stripped.isEmpty ? struggles : stripped
    }
    
    var breathingStatus: String {
        if breathingType.contains("Mouth") {
            return "mouth-breathing"
        } else if breathingType.contains("Nose") {
            return "nasal breathing"
        }
        return "mixed breathing"
    }
    
    var routineStatus: String {
        if hasRoutine.contains("None") { return "no routine" }
        if hasRoutine.contains("Basic") { return "basic routine" }
        if hasRoutine.contains("Intermediate") { return "intermediate routine" }
        return "advanced routine"
    }
    
    var urgencyLevel: String {
        if timeframe.contains("2 weeks") { return "high" }
        if timeframe.contains("1 month") { return "moderate" }
        return "steady"
    }
    
    // MARK: - Initialization
    
    init() {
        loadFromUserDefaults()
    }
    
    func loadFromUserDefaults() {
        let defaults = UserDefaults.standard
        
        goal = defaults.string(forKey: "userGoal") ?? ""
        ageGroup = defaults.string(forKey: "userAgeGroup") ?? ""
        photoConfidence = defaults.string(forKey: "userPhotoConfidence") ?? ""
        struggles = defaults.string(forKey: "userStruggles") ?? ""
        hasRoutine = defaults.string(forKey: "userRoutineLevel") ?? ""
        sleepHours = defaults.string(forKey: "userSleepHours") ?? ""
        dailyCommitment = defaults.string(forKey: "userDailyCommitment") ?? ""
        timeframe = defaults.string(forKey: "userTimeframe") ?? ""
        blockers = defaults.string(forKey: "userBlockers") ?? ""
        breathingType = defaults.string(forKey: "userBreathingType") ?? ""
        dedicationLevel = defaults.integer(forKey: "userDedicationLevel")
        
        // Default dedication if not set
        if dedicationLevel == 0 { dedicationLevel = 5 }
    }
}
