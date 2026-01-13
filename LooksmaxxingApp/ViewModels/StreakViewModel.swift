//
//  StreakViewModel.swift
//  LooksmaxxingApp
//
//  Manages streak logic - primary retention mechanism
//  Uses loss aversion to drive daily engagement
//

import Foundation
import Combine

@MainActor
class StreakViewModel: ObservableObject {
    static let shared = StreakViewModel()
    
    @Published var currentStreak: Int = 0
    @Published var lastCompletionDate: Date?
    @Published var totalDays: Int = 0
    @Published var isStreakAtRisk: Bool = false
    @Published var hoursRemaining: Int = 0
    
    private let coreData = CoreDataManager.shared
    private var timer: Timer?
    
    private init() {
        loadStreak()
        startStreakMonitor()
    }
    
    // MARK: - Load Streak from Core Data
    
    func loadStreak() {
        if let streak = coreData.fetchStreak() {
            currentStreak = Int(streak.currentStreak)
            lastCompletionDate = streak.lastCompletionDate
            totalDays = Int(streak.totalDays)
        }
        updateStreakStatus()
    }
    
    // MARK: - Update Streak (called when all 3 tasks complete)
    
    func updateStreak() {
        let today = Date()
        let calendar = Calendar.current
        
        // Check if already completed today
        if let lastCompletion = lastCompletionDate,
           calendar.isDate(lastCompletion, inSameDayAs: today) {
            // Already completed today, don't increment
            return
        }
        
        // Check if within 24-hour window
        if let lastCompletion = lastCompletionDate {
            let hoursSinceLastCompletion = calendar.dateComponents([.hour], from: lastCompletion, to: today).hour ?? 0
            
            if hoursSinceLastCompletion <= 24 {
                // Within window, increment streak
                currentStreak += 1
            } else {
                // Outside window, reset streak
                currentStreak = 1
            }
        } else {
            // First completion ever
            currentStreak = 1
        }
        
        // Update Core Data
        coreData.updateStreak(currentStreak: currentStreak, lastCompletion: today)
        
        lastCompletionDate = today
        totalDays += 1
        isStreakAtRisk = false
        
        // Schedule streak at risk notification
        NotificationService.shared.scheduleStreakAtRisk()
    }
    
    // MARK: - Check if User Can Maintain Streak
    
    func canMaintainStreak() -> Bool {
        guard let lastCompletion = lastCompletionDate else { return true }
        let hoursSinceLastCompletion = Calendar.current.dateComponents([.hour], from: lastCompletion, to: Date()).hour ?? 0
        return hoursSinceLastCompletion <= 24
    }
    
    // MARK: - Check if Streak Freeze is Available/Needed
    
    func isStreakFreezeAvailable() -> Bool {
        // Streak is at risk if >24h since last completion and streak > 0
        return !canMaintainStreak() && currentStreak > 0
    }
    
    // MARK: - Apply Streak Freeze
    
    func applyStreakFreeze() -> Bool {
        // Check if user has streak freeze
        guard UserDefaults.standard.streakFreezeCount > 0 else { return false }
        
        // Use one streak freeze
        UserDefaults.standard.streakFreezeCount -= 1
        
        // Extend the last completion date by 24 hours
        if let lastCompletion = lastCompletionDate {
            let newDate = Calendar.current.date(byAdding: .hour, value: 24, to: lastCompletion) ?? Date()
            lastCompletionDate = newDate
            coreData.updateStreak(currentStreak: currentStreak, lastCompletion: newDate)
        }
        
        isStreakAtRisk = false
        return true
    }
    
    // MARK: - Reset Streak (when user misses window)
    
    func resetStreak() {
        currentStreak = 0
        lastCompletionDate = nil
        coreData.resetStreak()
        isStreakAtRisk = false
    }
    
    // MARK: - Update Streak Status
    
    private func updateStreakStatus() {
        guard let lastCompletion = lastCompletionDate else {
            isStreakAtRisk = false
            hoursRemaining = 24
            return
        }
        
        let calendar = Calendar.current
        let hoursSince = calendar.dateComponents([.hour], from: lastCompletion, to: Date()).hour ?? 0
        hoursRemaining = max(0, 24 - hoursSince)
        
        // Streak is at risk if less than 4 hours remaining
        isStreakAtRisk = hoursRemaining > 0 && hoursRemaining <= 4 && currentStreak > 0
        
        // Check if streak has expired
        if hoursRemaining == 0 && currentStreak > 0 {
            // Streak has expired - will reset when they complete tasks
        }
    }
    
    // MARK: - Background Timer
    
    private func startStreakMonitor() {
        timer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateStreakStatus()
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
