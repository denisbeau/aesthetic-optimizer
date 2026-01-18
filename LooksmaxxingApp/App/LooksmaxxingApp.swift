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
        // Initialize Firebase only if GoogleService-Info.plist exists AND is valid.
        // This allows builds to succeed in CI where the file may be absent or a placeholder.
        if
            let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
            let options = FirebaseOptions(contentsOfFile: filePath)
        {
            FirebaseApp.configure(options: options)
        } else {
            #if DEBUG
            print("⚠️ [Firebase] Skipping FirebaseApp.configure() (missing or invalid GoogleService-Info.plist)")
            #endif
        }
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
