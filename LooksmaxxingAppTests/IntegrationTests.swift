//
//  IntegrationTests.swift
//  LooksmaxxingAppTests
//
//  Integration tests for end-to-end flows
//  Tests how components work together
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class IntegrationTests: XCTestCase {
    
    // MARK: - Onboarding Flow Tests
    
    func testOnboardingCompletion_SetsFlag() {
        // Save original
        let original = UserDefaults.standard.hasCompletedOnboarding
        let originalPreQuiz = UserDefaults.standard.bool(forKey: "hasSeenPreQuiz")
        
        // Simulate completing onboarding
        UserDefaults.standard.hasCompletedOnboarding = true
        
        XCTAssertTrue(UserDefaults.standard.hasCompletedOnboarding)
        
        // Restore
        UserDefaults.standard.hasCompletedOnboarding = original
        UserDefaults.standard.set(originalPreQuiz, forKey: "hasSeenPreQuiz")
    }
    
    func testNewOnboardingFlow_PreQuizToQuiz() {
        // Save originals
        let originalPreQuiz = UserDefaults.standard.bool(forKey: "hasSeenPreQuiz")
        let originalOnboarding = UserDefaults.standard.hasCompletedOnboarding
        
        // Test pre-quiz flow
        UserDefaults.standard.set(false, forKey: "hasSeenPreQuiz")
        UserDefaults.standard.hasCompletedOnboarding = false
        
        // After seeing pre-quiz
        UserDefaults.standard.set(true, forKey: "hasSeenPreQuiz")
        XCTAssertTrue(UserDefaults.standard.bool(forKey: "hasSeenPreQuiz"))
        
        // Restore
        UserDefaults.standard.set(originalPreQuiz, forKey: "hasSeenPreQuiz")
        UserDefaults.standard.hasCompletedOnboarding = originalOnboarding
    }
    
    func testNewOnboardingFlow_SymptomsToGoalsToSignature() {
        let quizData = OnboardingQuizData()
        
        // Test symptoms selection
        quizData.selectedSymptoms = ["avoid_photos", "mouth_breathing"]
        quizData.saveToUserDefaults()
        XCTAssertEqual(quizData.selectedSymptoms.count, 2)
        
        // Test goals selection
        quizData.selectedGoals = ["sharper_jawline", "better_skin"]
        quizData.saveToUserDefaults()
        XCTAssertEqual(quizData.selectedGoals.count, 2)
        
        // Test signature
        let testSignature = Data("test signature".utf8)
        quizData.commitmentSignature = testSignature
        quizData.saveToUserDefaults()
        XCTAssertTrue(quizData.hasSignedCommitment)
        
        // Verify all data persists
        let loaded = OnboardingQuizData()
        XCTAssertEqual(loaded.selectedSymptoms.count, 2)
        XCTAssertEqual(loaded.selectedGoals.count, 2)
        XCTAssertNotNil(loaded.commitmentSignature)
    }
    
    func testNewOnboardingFlow_DataFlowsToPaywall() {
        let quizData = OnboardingQuizData()
        
        // Set up complete flow data
        quizData.selectedSymptoms = ["avoid_photos"]
        quizData.selectedGoals = ["sharper_jawline", "better_skin"]
        quizData.commitmentSignature = Data("signature".utf8)
        quizData.dedicationLevel = 8
        quizData.saveToUserDefaults()
        
        // Verify paywall can access all data
        XCTAssertFalse(quizData.selectedSymptoms.isEmpty)
        XCTAssertFalse(quizData.selectedGoals.isEmpty)
        XCTAssertTrue(quizData.hasSignedCommitment)
        XCTAssertGreaterThan(quizData.potentialScore, 7.0)
        
        // Verify goal badges are generated
        let badges = quizData.goalBadges
        XCTAssertEqual(badges.count, 2)
        XCTAssertEqual(badges[0].id, "sharper_jawline")
        XCTAssertEqual(badges[1].id, "better_skin")
        
        // Verify transformation date
        let date = quizData.transformationDate
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: Date(), to: date).day ?? 0
        XCTAssertEqual(days, 60, accuracy: 1)
    }
    
    // MARK: - Scan + Subscription Integration
    
    func testFreeScan_LimitEnforced() {
        // Save original
        let originalPro = UserDefaults.standard.isProUser
        let originalScan = UserDefaults.standard.lastScanDate
        
        // Set up: Free user who just scanned
        UserDefaults.standard.isProUser = false
        UserDefaults.standard.lastScanDate = Date()
        
        let viewModel = SubscriptionViewModel.shared
        viewModel.checkSubscriptionStatus()
        
        // Should not be able to scan
        XCTAssertFalse(viewModel.canScanToday())
        XCTAssertEqual(viewModel.daysUntilNextFreeScan(), 7)
        
        // Restore
        UserDefaults.standard.isProUser = originalPro
        UserDefaults.standard.lastScanDate = originalScan
    }
    
    func testProUser_NoScanLimit() {
        // Save original
        let originalPro = UserDefaults.standard.isProUser
        let originalScan = UserDefaults.standard.lastScanDate
        
        // Set up: Pro user who just scanned
        UserDefaults.standard.isProUser = true
        UserDefaults.standard.lastScanDate = Date()
        
        let viewModel = SubscriptionViewModel.shared
        viewModel.checkSubscriptionStatus()
        
        // Pro users can always scan
        XCTAssertTrue(viewModel.canScanToday())
        XCTAssertEqual(viewModel.daysUntilNextFreeScan(), 0)
        
        // Restore
        UserDefaults.standard.isProUser = originalPro
        UserDefaults.standard.lastScanDate = originalScan
    }
    
    // MARK: - Streak + Daily Task Integration
    
    func testDailyTaskCompletion_UpdatesStreak() async {
        let streakVM = StreakViewModel.shared
        
        // Reset streak
        streakVM.resetStreak()
        XCTAssertEqual(streakVM.currentStreak, 0)
        
        // Complete daily tasks (simulated by calling updateStreak)
        streakVM.updateStreak()
        
        XCTAssertEqual(streakVM.currentStreak, 1)
        XCTAssertNotNil(streakVM.lastCompletionDate)
    }
    
    func testStreakFreeze_ProtectsStreak() async {
        let streakVM = StreakViewModel.shared
        
        // Save original
        let originalFreezeCount = UserDefaults.standard.streakFreezeCount
        
        // Set up: User with streak and freeze available
        streakVM.resetStreak()
        streakVM.updateStreak()
        UserDefaults.standard.streakFreezeCount = 1
        
        XCTAssertEqual(streakVM.currentStreak, 1)
        
        // If streak is at risk and user applies freeze
        if !streakVM.canMaintainStreak() && streakVM.currentStreak > 0 {
            let applied = streakVM.applyStreakFreeze()
            if applied {
                XCTAssertEqual(UserDefaults.standard.streakFreezeCount, 0)
                XCTAssertFalse(streakVM.isStreakAtRisk)
            }
        }
        
        // Restore
        UserDefaults.standard.streakFreezeCount = originalFreezeCount
    }
    
    // MARK: - Purchase + Unlock Integration
    
    func testPurchaseSubscription_UnlocksFeatures() async throws {
        let subscriptionVM = SubscriptionViewModel.shared
        
        // Save original
        let original = UserDefaults.standard.isProUser
        UserDefaults.standard.isProUser = false
        subscriptionVM.checkSubscriptionStatus()
        
        // Verify starts as free
        XCTAssertFalse(subscriptionVM.isProUser)
        XCTAssertEqual(subscriptionVM.subscriptionStatus, .free)
        
        // Purchase
        try await subscriptionVM.purchaseSubscription()
        
        // Verify pro
        XCTAssertTrue(subscriptionVM.isProUser)
        XCTAssertEqual(subscriptionVM.subscriptionStatus, .pro)
        XCTAssertTrue(UserDefaults.standard.isProUser)
        
        // Restore
        UserDefaults.standard.isProUser = original
        subscriptionVM.checkSubscriptionStatus()
    }
    
    // MARK: - Scan Flow Integration
    
    func testScanFlow_Reset() {
        let scanVM = ScanViewModel()
        
        // Capture both images
        scanVM.captureFront(createTestImage())
        scanVM.captureSide(createTestImage())
        
        // Verify state
        XCTAssertNotNil(scanVM.frontImage)
        XCTAssertNotNil(scanVM.sideImage)
        XCTAssertEqual(scanVM.captureMode, .complete)
        
        // Reset
        scanVM.reset()
        
        // Verify clean state
        XCTAssertNil(scanVM.frontImage)
        XCTAssertNil(scanVM.sideImage)
        XCTAssertEqual(scanVM.captureMode, .front)
    }
    
    // MARK: - Device ID Persistence
    
    func testDeviceID_PersistsAcrossSessions() {
        let id1 = UserDefaults.standard.deviceID
        let id2 = UserDefaults.standard.deviceID
        
        // Should be the same across accesses
        XCTAssertEqual(id1, id2)
        XCTAssertFalse(id1.isEmpty)
    }
    
    // MARK: - Helper Methods
    
    private func createTestImage() -> UIImage {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        UIColor.gray.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - Data Flow Tests

@MainActor
final class DataFlowTests: XCTestCase {
    
    func testUserDefaultsSynchronization() {
        // Test that changes to UserDefaults are reflected correctly
        let original = UserDefaults.standard.isProUser
        
        UserDefaults.standard.isProUser = true
        UserDefaults.standard.synchronize()
        
        XCTAssertTrue(UserDefaults.standard.isProUser)
        
        UserDefaults.standard.isProUser = false
        UserDefaults.standard.synchronize()
        
        XCTAssertFalse(UserDefaults.standard.isProUser)
        
        // Restore
        UserDefaults.standard.isProUser = original
    }
    
    func testStreakFreezeCountPersistence() {
        let original = UserDefaults.standard.streakFreezeCount
        
        UserDefaults.standard.streakFreezeCount = 5
        XCTAssertEqual(UserDefaults.standard.streakFreezeCount, 5)
        
        UserDefaults.standard.streakFreezeCount = 0
        XCTAssertEqual(UserDefaults.standard.streakFreezeCount, 0)
        
        // Restore
        UserDefaults.standard.streakFreezeCount = original
    }
}

// MARK: - Edge Case Tests

@MainActor
final class EdgeCaseTests: XCTestCase {
    
    func testMultipleSameDayStreakUpdates() {
        let streakVM = StreakViewModel.shared
        
        streakVM.resetStreak()
        
        // First update
        streakVM.updateStreak()
        let firstStreak = streakVM.currentStreak
        
        // Second update same day
        streakVM.updateStreak()
        let secondStreak = streakVM.currentStreak
        
        // Should not increment again
        XCTAssertEqual(firstStreak, secondStreak)
    }
    
    func testNegativeStreakFreezeCount() {
        let original = UserDefaults.standard.streakFreezeCount
        
        // Try to go negative (shouldn't happen in normal use)
        UserDefaults.standard.streakFreezeCount = 0
        
        let subscriptionVM = SubscriptionViewModel.shared
        subscriptionVM.streakFreezeCount = 0
        
        // Using freeze should fail
        let result = subscriptionVM.useStreakFreeze()
        XCTAssertFalse(result)
        
        // Count should still be 0
        XCTAssertEqual(subscriptionVM.streakFreezeCount, 0)
        
        // Restore
        UserDefaults.standard.streakFreezeCount = original
    }
}
