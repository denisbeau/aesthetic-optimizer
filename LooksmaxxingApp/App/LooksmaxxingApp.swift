//
//  LooksmaxxingApp.swift
//  LooksmaxxingApp
//
//  Created on January 12, 2026
//  MVP - AI Facial Analysis & Self-Improvement
//

import SwiftUI

@main
struct LooksmaxxingApp: App {
    @StateObject private var coreDataManager = CoreDataManager.shared
    @StateObject private var subscriptionVM = SubscriptionViewModel.shared
    @StateObject private var streakVM = StreakViewModel.shared
    
    init() {
        setupApp()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(subscriptionVM)
                .environmentObject(streakVM)
                .environment(\.managedObjectContext, coreDataManager.viewContext)
        }
    }
    
    private func setupApp() {
        // Initialize device ID if not exists
        _ = UserDefaults.standard.deviceID
        
        // RevenueCat is configured in SubscriptionViewModel.init()
        // Notifications are requested after first scan, not on launch
    }
}
