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
    
    // MARK: - New Quittr-Inspired Properties
    
    @Published var selectedSymptoms: [String] = []
    @Published var selectedGoals: [String] = []
    @Published var commitmentSignature: Data?
    
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
    
    // MARK: - New Computed Properties for Paywall
    
    var transformationDate: Date {
        Calendar.current.date(byAdding: .day, value: 60, to: Date()) ?? Date()
    }
    
    var transformationDateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: transformationDate)
    }
    
    var hasSignedCommitment: Bool {
        commitmentSignature != nil
    }
    
    struct GoalBadge {
        let id: String
        let title: String
        let icon: String
        let color: String
    }
    
    var goalBadges: [GoalBadge] {
        selectedGoals.compactMap { goalId in
            GoalBadge(
                id: goalId,
                title: goalId.replacingOccurrences(of: "_", with: " ").capitalized,
                icon: getGoalIcon(goalId),
                color: getGoalColor(goalId)
            )
        }
    }
    
    private func getGoalIcon(_ goalId: String) -> String {
        let icons: [String: String] = [
            "sharper_jawline": "🔥",
            "better_skin": "✨",
            "improved_symmetry": "⚖️",
            "increased_confidence": "💪",
            "fix_breathing": "👃",
            "better_posture": "🧍",
            "overall_transformation": "💎",
            "specific_feature": "🎯"
        ]
        return icons[goalId] ?? "🎯"
    }
    
    private func getGoalColor(_ goalId: String) -> String {
        let colors: [String: String] = [
            "sharper_jawline": "#F59E0B",
            "better_skin": "#3B82F6",
            "improved_symmetry": "#8B5CF6",
            "increased_confidence": "#F43F5E",
            "fix_breathing": "#8B5CF6",
            "better_posture": "#10B981",
            "overall_transformation": "#00D4FF",
            "specific_feature": "#F59E0B"
        ]
        return colors[goalId] ?? "#00D4FF"
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
        
        // Load new fields
        if let symptoms = defaults.array(forKey: "selectedSymptoms") as? [String] {
            selectedSymptoms = symptoms
        }
        if let goals = defaults.array(forKey: "selectedGoals") as? [String] {
            selectedGoals = goals
        }
        if let signature = defaults.data(forKey: "commitmentSignature") {
            commitmentSignature = signature
        }
    }
    
    func saveToUserDefaults() {
        let defaults = UserDefaults.standard
        
        // Save existing fields
        defaults.set(goal, forKey: "userGoal")
        defaults.set(ageGroup, forKey: "userAgeGroup")
        defaults.set(photoConfidence, forKey: "userPhotoConfidence")
        defaults.set(struggles, forKey: "userStruggles")
        defaults.set(hasRoutine, forKey: "userRoutineLevel")
        defaults.set(sleepHours, forKey: "userSleepHours")
        defaults.set(dailyCommitment, forKey: "userDailyCommitment")
        defaults.set(timeframe, forKey: "userTimeframe")
        defaults.set(blockers, forKey: "userBlockers")
        defaults.set(breathingType, forKey: "userBreathingType")
        defaults.set(dedicationLevel, forKey: "userDedicationLevel")
        
        // Save new fields
        defaults.set(selectedSymptoms, forKey: "selectedSymptoms")
        defaults.set(selectedGoals, forKey: "selectedGoals")
        if let signature = commitmentSignature {
            defaults.set(signature, forKey: "commitmentSignature")
        }
    }
}
