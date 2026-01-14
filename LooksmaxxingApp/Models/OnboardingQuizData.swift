//
//  OnboardingQuizData.swift
//  LooksmaxxingApp
//
//  Observable data model for quiz answers
//  Used to personalize paywall and results
//

import Foundation

class OnboardingQuizData: ObservableObject {
    @Published var ageGroup: String = ""
    @Published var goal: String = ""
    @Published var currentSelfRating: String = ""
    @Published var dedicationLevel: Int = 5
    @Published var timeframe: String = ""
    @Published var hasRoutine: String = "None"
    
    // Computed properties for personalization
    var isHighlyDedicated: Bool {
        dedicationLevel >= 8
    }
    
    var potentialScore: Double {
        isHighlyDedicated ? 8.5 : 7.8
    }
    
    var improvementTimeframe: String {
        if timeframe.contains("2 weeks") || timeframe.contains("1-2 weeks") { return "14 days" }
        if timeframe.contains("1 month") { return "30 days" }
        return "90 days"
    }
    
    var criticalAreasCount: Int {
        switch hasRoutine {
        case "None": return 4
        case "Basic": return 3
        default: return 2
        }
    }
    
    // Alias for goal (used by PersonalizedPaywallView)
    var primaryGoal: String {
        // Strip emoji prefix if present for cleaner display
        let stripped = goal.components(separatedBy: " ").dropFirst().joined(separator: " ")
        return stripped.isEmpty ? goal : stripped
    }
    
    // Initialize from UserDefaults (synced with OnboardingQuizView)
    init() {
        loadFromUserDefaults()
    }
    
    func loadFromUserDefaults() {
        ageGroup = UserDefaults.standard.string(forKey: "userAgeGroup") ?? ""
        goal = UserDefaults.standard.string(forKey: "userGoal") ?? ""
        timeframe = UserDefaults.standard.string(forKey: "userTimeframe") ?? ""
        
        // Map commitment level to dedication score
        let commitment = UserDefaults.standard.string(forKey: "userCommitmentLevel") ?? ""
        if commitment.contains("100%") || commitment.contains("Whatever it takes") {
            dedicationLevel = 10
        } else if commitment.contains("High") || commitment.contains("Ready to work") {
            dedicationLevel = 8
        } else if commitment.contains("Medium") {
            dedicationLevel = 5
        } else {
            dedicationLevel = 3
        }
    }
}
