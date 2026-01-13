//
//  SubscriptionViewModel.swift
//  LooksmaxxingApp
//
//  Manages subscription state and RevenueCat integration
//  Handles Pro tier and Streak Freeze IAP
//

import Foundation
import StoreKit

// Note: In production, import RevenueCat
// import RevenueCat

@MainActor
class SubscriptionViewModel: ObservableObject {
    static let shared = SubscriptionViewModel()
    
    // MARK: - Published Properties
    
    @Published var isProUser: Bool = false
    @Published var subscriptionStatus: SubscriptionStatus = .free
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var hasStreakFreeze: Bool = false
    @Published var streakFreezeCount: Int = 0
    
    // MARK: - Product IDs
    
    static let proMonthlyProductID = "pro_monthly"
    static let streakFreezeProductID = "streak_freeze"
    
    // MARK: - Subscription Status Enum
    
    enum SubscriptionStatus {
        case free
        case pro
        case trial
        
        var displayName: String {
            switch self {
            case .free: return "Free"
            case .pro: return "Pro"
            case .trial: return "Trial"
            }
        }
    }
    
    // MARK: - Initialization
    
    private init() {
        // Load cached subscription status
        isProUser = UserDefaults.standard.isProUser
        streakFreezeCount = UserDefaults.standard.streakFreezeCount
        hasStreakFreeze = streakFreezeCount > 0
        subscriptionStatus = isProUser ? .pro : .free
        
        // Configure RevenueCat (in production)
        configureRevenueCat()
    }
    
    // MARK: - RevenueCat Configuration
    
    func configureRevenueCat() {
        // In production, configure RevenueCat:
        // Purchases.configure(withAPIKey: "YOUR_REVENUECAT_API_KEY")
        // Purchases.shared.delegate = self
        
        // For MVP testing, check subscription status
        checkSubscriptionStatus()
    }
    
    // MARK: - Check Subscription Status
    
    func checkSubscriptionStatus() {
        // In production with RevenueCat:
        /*
        Purchases.shared.getCustomerInfo { [weak self] customerInfo, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let error = error {
                    print("RevenueCat error: \(error.localizedDescription)")
                    return
                }
                
                if customerInfo?.entitlements["pro"]?.isActive == true {
                    self.isProUser = true
                    self.subscriptionStatus = .pro
                } else {
                    self.isProUser = false
                    self.subscriptionStatus = .free
                }
                
                UserDefaults.standard.isProUser = self.isProUser
            }
        }
        */
        
        // For MVP: Use cached status
        isProUser = UserDefaults.standard.isProUser
        subscriptionStatus = isProUser ? .pro : .free
    }
    
    // MARK: - Purchase Subscription
    
    func purchaseSubscription() async throws {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        // In production with RevenueCat:
        /*
        do {
            let offerings = try await Purchases.shared.offerings()
            guard let package = offerings.current?.availablePackages.first else {
                throw AppError.purchaseFailed("No packages available")
            }
            
            let (_, customerInfo, _) = try await Purchases.shared.purchase(package: package)
            
            if customerInfo.entitlements["pro"]?.isActive == true {
                isProUser = true
                subscriptionStatus = .pro
                UserDefaults.standard.isProUser = true
            }
        } catch {
            throw AppError.purchaseFailed(error.localizedDescription)
        }
        */
        
        // For MVP testing: Simulate purchase
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        
        // Simulate successful purchase
        isProUser = true
        subscriptionStatus = .pro
        UserDefaults.standard.isProUser = true
    }
    
    // MARK: - Purchase Streak Freeze
    
    func purchaseStreakFreeze() async throws {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        // In production with RevenueCat:
        /*
        do {
            let offerings = try await Purchases.shared.offerings()
            guard let package = offerings.current?.package(identifier: "streak_freeze") else {
                throw AppError.purchaseFailed("Streak freeze not available")
            }
            
            let (_, _, _) = try await Purchases.shared.purchase(package: package)
            
            streakFreezeCount += 1
            hasStreakFreeze = true
            UserDefaults.standard.streakFreezeCount = streakFreezeCount
        } catch {
            throw AppError.purchaseFailed(error.localizedDescription)
        }
        */
        
        // For MVP testing: Simulate purchase
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        
        // Simulate successful purchase
        streakFreezeCount += 1
        hasStreakFreeze = true
        UserDefaults.standard.streakFreezeCount = streakFreezeCount
    }
    
    // MARK: - Restore Purchases
    
    func restorePurchases() async throws {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        // In production with RevenueCat:
        /*
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            
            if customerInfo.entitlements["pro"]?.isActive == true {
                isProUser = true
                subscriptionStatus = .pro
                UserDefaults.standard.isProUser = true
            }
        } catch {
            throw AppError.restoreFailed
        }
        */
        
        // For MVP testing: Check cached status
        try await Task.sleep(nanoseconds: 500_000_000)
        checkSubscriptionStatus()
    }
    
    // MARK: - Helper Methods
    
    func canScanToday() -> Bool {
        UserDefaults.standard.canScanToday(isProUser: isProUser)
    }
    
    func daysUntilNextFreeScan() -> Int {
        isProUser ? 0 : UserDefaults.standard.daysUntilNextFreeScan()
    }
    
    func useStreakFreeze() -> Bool {
        guard streakFreezeCount > 0 else { return false }
        streakFreezeCount -= 1
        hasStreakFreeze = streakFreezeCount > 0
        UserDefaults.standard.streakFreezeCount = streakFreezeCount
        return true
    }
}

// MARK: - RevenueCat Delegate (Production)

/*
extension SubscriptionViewModel: PurchasesDelegate {
    nonisolated func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        Task { @MainActor in
            checkSubscriptionStatus()
        }
    }
}
*/
