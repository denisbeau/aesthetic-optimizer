//
//  LooksmaxxingApp.swift
//  LooksmaxxingApp
//
//  Created on January 12, 2026
//  MVP - AI Facial Analysis & Self-Improvement
//

import SwiftUI
import FirebaseCore

@main
struct LooksmaxxingApp: App {
    @StateObject private var coreDataManager = CoreDataManager.shared
    @StateObject private var subscriptionVM = SubscriptionViewModel.shared
    @StateObject private var streakVM = StreakViewModel.shared
    
    init() {
        // Initialize Firebase (must be called before any Firebase services)
        FirebaseApp.configure()
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
        
        // Load Remote Config for A/B testing (non-blocking)
        _ = RemoteConfigService.shared
        
        // RevenueCat is configured in SubscriptionViewModel.init()
        // Notifications are requested after first scan, not on launch
    }
}
