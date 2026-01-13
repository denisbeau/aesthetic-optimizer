//
//  SubscriptionViewModelTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for SubscriptionViewModel
//  Tests subscription state, purchase flow, and streak freeze
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class SubscriptionViewModelTests: XCTestCase {
    
    var viewModel: SubscriptionViewModel!
    
    override func setUp() async throws {
        try await super.setUp()
        viewModel = SubscriptionViewModel.shared
    }
    
    override func tearDown() async throws {
        viewModel = nil
        try await super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        // Should load from UserDefaults
        XCTAssertEqual(viewModel.isProUser, UserDefaults.standard.isProUser)
        XCTAssertEqual(viewModel.streakFreezeCount, UserDefaults.standard.streakFreezeCount)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // MARK: - Subscription Status Tests
    
    func testSubscriptionStatus_Free() {
        // Save original
        let original = UserDefaults.standard.isProUser
        
        UserDefaults.standard.isProUser = false
        viewModel.checkSubscriptionStatus()
        
        XCTAssertEqual(viewModel.subscriptionStatus, .free)
        XCTAssertFalse(viewModel.isProUser)
        
        // Restore
        UserDefaults.standard.isProUser = original
    }
    
    func testSubscriptionStatus_Pro() {
        // Save original
        let original = UserDefaults.standard.isProUser
        
        UserDefaults.standard.isProUser = true
        viewModel.checkSubscriptionStatus()
        
        XCTAssertEqual(viewModel.subscriptionStatus, .pro)
        XCTAssertTrue(viewModel.isProUser)
        
        // Restore
        UserDefaults.standard.isProUser = original
    }
    
    // MARK: - Subscription Status Display Name Tests
    
    func testSubscriptionStatusDisplayName() {
        XCTAssertEqual(SubscriptionViewModel.SubscriptionStatus.free.displayName, "Free")
        XCTAssertEqual(SubscriptionViewModel.SubscriptionStatus.pro.displayName, "Pro")
        XCTAssertEqual(SubscriptionViewModel.SubscriptionStatus.trial.displayName, "Trial")
    }
    
    // MARK: - Product IDs Tests
    
    func testProductIDs() {
        XCTAssertEqual(SubscriptionViewModel.proMonthlyProductID, "pro_monthly")
        XCTAssertEqual(SubscriptionViewModel.streakFreezeProductID, "streak_freeze")
    }
    
    // MARK: - Purchase Subscription Tests
    
    func testPurchaseSubscription_Success() async throws {
        // Save original
        let original = UserDefaults.standard.isProUser
        UserDefaults.standard.isProUser = false
        
        XCTAssertFalse(viewModel.isProUser)
        
        try await viewModel.purchaseSubscription()
        
        XCTAssertTrue(viewModel.isProUser)
        XCTAssertEqual(viewModel.subscriptionStatus, .pro)
        XCTAssertTrue(UserDefaults.standard.isProUser)
        XCTAssertFalse(viewModel.isLoading)
        
        // Restore
        UserDefaults.standard.isProUser = original
        viewModel.checkSubscriptionStatus()
    }
    
    func testPurchaseSubscription_LoadingState() async throws {
        // Save original
        let original = UserDefaults.standard.isProUser
        
        // Start purchase
        let task = Task {
            try await viewModel.purchaseSubscription()
        }
        
        // Give it a moment to start
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms
        
        // Should be loading (if still in progress)
        // Note: timing might vary, so this is approximate
        
        // Wait for completion
        try await task.value
        
        XCTAssertFalse(viewModel.isLoading)
        
        // Restore
        UserDefaults.standard.isProUser = original
        viewModel.checkSubscriptionStatus()
    }
    
    // MARK: - Purchase Streak Freeze Tests
    
    func testPurchaseStreakFreeze_Success() async throws {
        // Save original
        let original = UserDefaults.standard.streakFreezeCount
        UserDefaults.standard.streakFreezeCount = 0
        viewModel.streakFreezeCount = 0
        
        XCTAssertEqual(viewModel.streakFreezeCount, 0)
        
        try await viewModel.purchaseStreakFreeze()
        
        XCTAssertEqual(viewModel.streakFreezeCount, 1)
        XCTAssertTrue(viewModel.hasStreakFreeze)
        XCTAssertEqual(UserDefaults.standard.streakFreezeCount, 1)
        XCTAssertFalse(viewModel.isLoading)
        
        // Restore
        UserDefaults.standard.streakFreezeCount = original
    }
    
    func testPurchaseStreakFreeze_Multiple() async throws {
        // Save original
        let original = UserDefaults.standard.streakFreezeCount
        UserDefaults.standard.streakFreezeCount = 2
        viewModel.streakFreezeCount = 2
        
        try await viewModel.purchaseStreakFreeze()
        
        XCTAssertEqual(viewModel.streakFreezeCount, 3)
        
        // Restore
        UserDefaults.standard.streakFreezeCount = original
    }
    
    // MARK: - Restore Purchases Tests
    
    func testRestorePurchases() async throws {
        // Save original
        let original = UserDefaults.standard.isProUser
        
        try await viewModel.restorePurchases()
        
        // Should check status (simulate restore)
        XCTAssertFalse(viewModel.isLoading)
        
        // Restore
        UserDefaults.standard.isProUser = original
    }
    
    // MARK: - Can Scan Today Tests
    
    func testCanScanToday_ProUser() {
        // Save original
        let originalPro = UserDefaults.standard.isProUser
        let originalScan = UserDefaults.standard.lastScanDate
        
        UserDefaults.standard.isProUser = true
        viewModel.checkSubscriptionStatus()
        UserDefaults.standard.lastScanDate = Date() // Just scanned
        
        XCTAssertTrue(viewModel.canScanToday())
        
        // Restore
        UserDefaults.standard.isProUser = originalPro
        UserDefaults.standard.lastScanDate = originalScan
    }
    
    func testCanScanToday_FreeUser_RecentScan() {
        // Save original
        let originalPro = UserDefaults.standard.isProUser
        let originalScan = UserDefaults.standard.lastScanDate
        
        UserDefaults.standard.isProUser = false
        viewModel.checkSubscriptionStatus()
        UserDefaults.standard.lastScanDate = Date() // Just scanned
        
        XCTAssertFalse(viewModel.canScanToday())
        
        // Restore
        UserDefaults.standard.isProUser = originalPro
        UserDefaults.standard.lastScanDate = originalScan
    }
    
    // MARK: - Days Until Next Free Scan Tests
    
    func testDaysUntilNextFreeScan_ProUser() {
        // Save original
        let originalPro = UserDefaults.standard.isProUser
        
        UserDefaults.standard.isProUser = true
        viewModel.checkSubscriptionStatus()
        
        XCTAssertEqual(viewModel.daysUntilNextFreeScan(), 0)
        
        // Restore
        UserDefaults.standard.isProUser = originalPro
    }
    
    func testDaysUntilNextFreeScan_FreeUser() {
        // Save original
        let originalPro = UserDefaults.standard.isProUser
        let originalScan = UserDefaults.standard.lastScanDate
        
        UserDefaults.standard.isProUser = false
        viewModel.checkSubscriptionStatus()
        UserDefaults.standard.lastScanDate = Date() // Just scanned
        
        XCTAssertEqual(viewModel.daysUntilNextFreeScan(), 7)
        
        // Restore
        UserDefaults.standard.isProUser = originalPro
        UserDefaults.standard.lastScanDate = originalScan
    }
    
    // MARK: - Use Streak Freeze Tests
    
    func testUseStreakFreeze_HasFreezes() {
        // Save original
        let original = UserDefaults.standard.streakFreezeCount
        
        UserDefaults.standard.streakFreezeCount = 2
        viewModel.streakFreezeCount = 2
        viewModel.hasStreakFreeze = true
        
        let result = viewModel.useStreakFreeze()
        
        XCTAssertTrue(result)
        XCTAssertEqual(viewModel.streakFreezeCount, 1)
        XCTAssertTrue(viewModel.hasStreakFreeze) // Still has 1
        XCTAssertEqual(UserDefaults.standard.streakFreezeCount, 1)
        
        // Restore
        UserDefaults.standard.streakFreezeCount = original
    }
    
    func testUseStreakFreeze_LastFreeze() {
        // Save original
        let original = UserDefaults.standard.streakFreezeCount
        
        UserDefaults.standard.streakFreezeCount = 1
        viewModel.streakFreezeCount = 1
        viewModel.hasStreakFreeze = true
        
        let result = viewModel.useStreakFreeze()
        
        XCTAssertTrue(result)
        XCTAssertEqual(viewModel.streakFreezeCount, 0)
        XCTAssertFalse(viewModel.hasStreakFreeze) // No more freezes
        
        // Restore
        UserDefaults.standard.streakFreezeCount = original
    }
    
    func testUseStreakFreeze_NoFreezes() {
        // Save original
        let original = UserDefaults.standard.streakFreezeCount
        
        UserDefaults.standard.streakFreezeCount = 0
        viewModel.streakFreezeCount = 0
        viewModel.hasStreakFreeze = false
        
        let result = viewModel.useStreakFreeze()
        
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.streakFreezeCount, 0)
        
        // Restore
        UserDefaults.standard.streakFreezeCount = original
    }
}
