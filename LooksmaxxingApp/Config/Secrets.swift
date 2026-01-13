//
//  Secrets.swift
//  LooksmaxxingApp
//
//  API keys and configuration - DO NOT COMMIT TO PUBLIC REPO
//

import Foundation

enum Secrets {
    // MARK: - RevenueCat
    // Get from: https://app.revenuecat.com/apps → API Keys
    static let revenueCatAPIKey = "YOUR_REVENUECAT_API_KEY"
    
    // MARK: - Product IDs (Configure in RevenueCat Dashboard)
    static let proMonthlyProductID = "pro_monthly_1499"
    static let proYearlyProductID = "pro_yearly_9999"
    static let streakFreezeProductID = "streak_freeze_199"
    
    // MARK: - Firebase (Optional)
    // Get from: Firebase Console → Project Settings
    static let firebaseProjectID = "YOUR_FIREBASE_PROJECT_ID"
    
    // MARK: - App Configuration
    static let appStoreID = "YOUR_APP_STORE_ID"
    static let supportEmail = "support@aestheticoptimizer.com"
    static let privacyPolicyURL = "https://yoursite.com/privacy"
    static let termsOfServiceURL = "https://yoursite.com/terms"
}
