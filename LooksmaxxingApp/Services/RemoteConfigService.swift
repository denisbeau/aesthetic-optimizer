//
//  RemoteConfigService.swift
//  LooksmaxxingApp
//
//  Service for Firebase Remote Config A/B testing
//  Allows changing app messaging without rebuilding
//

import Foundation
import FirebaseRemoteConfig
import FirebaseCore

class RemoteConfigService: ObservableObject {
    static let shared = RemoteConfigService()
    
    @Published var messagingVariant: MessagingVariant = .brutalHonesty
    @Published var isLoaded = false
    
    enum MessagingVariant: String {
        case brutalHonesty = "brutal_honesty"
        case optimizationFocus = "optimization_focus"
        case balanced = "balanced"
    }
    
    // MARK: - Remote Config Keys (set in Firebase Console)
    enum ConfigKey: String {
        // Messaging variants
        case messagingVariant = "onboarding_messaging_variant"
        
        // Results screen messaging
        case resultsHeadline = "results_headline"
        case resultsSubheadline = "results_subheadline"
        case resultsGapCallout = "results_gap_callout"
        case resultsCTA = "results_cta"
        
        // Paywall messaging
        case paywallHeadline = "paywall_headline"
        case paywallSubheadline = "paywall_subheadline"
        case paywallCTAText = "paywall_cta_text"
        case paywallFreeTrialText = "paywall_free_trial_text"
        
        // Pricing
        case monthlyPrice = "monthly_price"
        case showAnnualPlan = "show_annual_plan"
        
        // Feature flags
        case showSignatureScreen = "show_signature_screen"
        case showSymptomChecklist = "show_symptom_checklist"
    }
    
    private init() {
        loadConfig()
    }
    
    // MARK: - Configuration Loading
    
    func loadConfig() {
        // Check if Firebase is configured before using RemoteConfig
        guard FirebaseApp.app() != nil else {
            print("⚠️ [RemoteConfig] Firebase not configured (GoogleService-Info.plist missing) - using defaults only")
            // Firebase not configured, use defaults only
            DispatchQueue.main.async {
                self.isLoaded = true
            }
            return
        }
        
        print("🔄 [RemoteConfig] Starting fetch from Firebase...")
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        #if DEBUG
        settings.minimumFetchInterval = 0 // faster iteration when testing
        #else
        settings.minimumFetchInterval = 3600 // 1 hour cache
        #endif
        remoteConfig.configSettings = settings
        
        // Set default values (fallback if Firebase not configured)
        remoteConfig.setDefaults([
            ConfigKey.messagingVariant.rawValue: MessagingVariant.brutalHonesty.rawValue as NSObject,
            ConfigKey.resultsHeadline.rawValue: "You're spiraling harder than most" as NSObject,
            ConfigKey.resultsSubheadline.rawValue: "Your responses indicate significant appearance anxiety*" as NSObject,
            ConfigKey.resultsGapCallout.rawValue: "% higher concern than average" as NSObject,
            ConfigKey.resultsCTA.rawValue: "Check your symptoms" as NSObject,
            ConfigKey.paywallHeadline.rawValue: "Stop spiraling. Start optimizing." as NSObject,
            ConfigKey.paywallCTAText.rawValue: "Become a Member" as NSObject,
            ConfigKey.paywallFreeTrialText.rawValue: "Try For $0.00" as NSObject,
            ConfigKey.monthlyPrice.rawValue: 14.99 as NSObject,
            ConfigKey.showSignatureScreen.rawValue: true as NSObject,
            ConfigKey.showSymptomChecklist.rawValue: true as NSObject,
        ])
        
        remoteConfig.fetch { status, error in
            if status == .success {
                print("✅ [RemoteConfig] Fetch successful")
                remoteConfig.activate { changed, error in
                    if let error = error {
                        print("⚠️ [RemoteConfig] Activate error: \(error.localizedDescription)")
                    } else {
                        print("✅ [RemoteConfig] Activated (changed: \(changed))")
                    }
                    
                    // Log key values for verification
                    let headline = remoteConfig.configValue(forKey: ConfigKey.resultsHeadline.rawValue).stringValue ?? "not found"
                    let monthlyPrice = remoteConfig.configValue(forKey: ConfigKey.monthlyPrice.rawValue).stringValue ?? "not found"
                    print("📊 [RemoteConfig] Sample values - results_headline: '\(headline)', monthly_price: '\(monthlyPrice)'")
                    
                    DispatchQueue.main.async {
                        self.updateVariant()
                        self.isLoaded = true
                    }
                }
            } else {
                if let error = error {
                    print("❌ [RemoteConfig] Fetch failed: \(error.localizedDescription)")
                } else {
                    print("⚠️ [RemoteConfig] Fetch status: \(status.rawValue) - using defaults")
                }
                // Firebase not configured, use defaults
                DispatchQueue.main.async {
                    self.isLoaded = true
                }
            }
        }
    }
    
    private func updateVariant() {
        guard FirebaseApp.app() != nil else { return }
        let remoteConfig = RemoteConfig.remoteConfig()
        let variantString = remoteConfig.configValue(forKey: ConfigKey.messagingVariant.rawValue).stringValue ?? MessagingVariant.brutalHonesty.rawValue
        messagingVariant = MessagingVariant(rawValue: variantString) ?? .brutalHonesty
    }
    
    // MARK: - Public API for Views
    
    func getString(for key: ConfigKey, fallback: String) -> String {
        guard FirebaseApp.app() != nil else { return fallback }
        let remoteConfig = RemoteConfig.remoteConfig()
        return remoteConfig.configValue(forKey: key.rawValue).stringValue ?? fallback
    }
    
    func getDouble(for key: ConfigKey, fallback: Double) -> Double {
        guard FirebaseApp.app() != nil else { return fallback }
        let remoteConfig = RemoteConfig.remoteConfig()
        let configValue = remoteConfig.configValue(forKey: key.rawValue)
        if configValue.source != .static {
            let numberValue = configValue.numberValue
            if numberValue != nil {
                return numberValue.doubleValue
            }
        }
        return fallback
    }
    
    func getBool(for key: ConfigKey, fallback: Bool) -> Bool {
        guard FirebaseApp.app() != nil else { return fallback }
        let remoteConfig = RemoteConfig.remoteConfig()
        let configValue = remoteConfig.configValue(forKey: key.rawValue)
        if configValue.source != .static {
            return configValue.boolValue
        }
        return fallback
    }
    
    // MARK: - Convenience Methods for Key Messages
    
    func getResultsHeadline() -> String {
        switch messagingVariant {
        case .brutalHonesty:
            return getString(for: .resultsHeadline, fallback: "You're spiraling harder than most")
        case .optimizationFocus:
            return getString(for: .resultsHeadline, fallback: "You have 40% optimization potential")
        case .balanced:
            return getString(for: .resultsHeadline, fallback: "You're operating below your potential")
        }
    }
    
    func getResultsSubheadline() -> String {
        switch messagingVariant {
        case .brutalHonesty:
            return getString(for: .resultsSubheadline, fallback: "Your responses indicate significant appearance anxiety*")
        case .optimizationFocus:
            return getString(for: .resultsSubheadline, fallback: "You're leaving 40% of your optimization potential unused*")
        case .balanced:
            return getString(for: .resultsSubheadline, fallback: "Your bone structure is what it is. Your habits are what you control.*")
        }
    }
    
    func getResultsGapCallout(scoreDifference: Int) -> String {
        let template = getString(for: .resultsGapCallout, fallback: "% higher concern than average")
        switch messagingVariant {
        case .brutalHonesty:
            return "\(scoreDifference)% higher concern than average"
        case .optimizationFocus:
            return "You're \(scoreDifference)% above average potential"
        case .balanced:
            return "\(scoreDifference)% above average - focus on the 40% you can optimize"
        }
    }
    
    func getPaywallHeadline() -> String {
        switch messagingVariant {
        case .brutalHonesty:
            return getString(for: .paywallHeadline, fallback: "Stop spiraling. Start optimizing.")
        case .optimizationFocus:
            return getString(for: .paywallHeadline, fallback: "Optimize your 40% potential")
        case .balanced:
            return getString(for: .paywallHeadline, fallback: "Your system for transformation")
        }
    }
    
    func getMonthlyPrice() -> Double {
        return getDouble(for: .monthlyPrice, fallback: 14.99)
    }
    
    func shouldShowSignatureScreen() -> Bool {
        return getBool(for: .showSignatureScreen, fallback: true)
    }
    
    func shouldShowSymptomChecklist() -> Bool {
        return getBool(for: .showSymptomChecklist, fallback: true)
    }
}
