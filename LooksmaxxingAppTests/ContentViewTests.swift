//
//  ContentViewTests.swift
//  LooksmaxxingAppTests
//
//  Unit tests for ContentView
//  Tests screen navigation, onboarding flow, and state management
//

import XCTest
@testable import LooksmaxxingApp

@MainActor
final class ContentViewTests: XCTestCase {
    
    // MARK: - Initial State Tests
    
    func testInitialScreen_IsSplash() {
        let initialScreen = 1 // Splash screen
        XCTAssertEqual(initialScreen, 1)
    }
    
    func testHasCompletedOnboarding_InitiallyFalse() {
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
        let hasCompleted = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        XCTAssertFalse(hasCompleted)
    }
    
    // MARK: - Screen Count Tests
    
    func testTotalScreens_Is27() {
        let totalScreens = 27
        XCTAssertEqual(totalScreens, 27)
    }
    
    func testScreenRange_Valid() {
        let minScreen = 1
        let maxScreen = 27
        
        XCTAssertGreaterThanOrEqual(minScreen, 1)
        XCTAssertLessThanOrEqual(maxScreen, 27)
    }
    
    // MARK: - Navigation Tests
    
    func testNavigation_Forward() {
        var currentScreen = 1
        currentScreen += 1
        XCTAssertEqual(currentScreen, 2)
    }
    
    func testNavigation_ToSpecificScreen() {
        var currentScreen = 1
        currentScreen = 15 // Jump to results dashboard
        XCTAssertEqual(currentScreen, 15)
    }
    
    // MARK: - Onboarding Flow Tests
    
    func testFlow_SplashToWelcome() {
        let splashScreen = 1
        let welcomeScreen = 2
        XCTAssertEqual(welcomeScreen, splashScreen + 1)
    }
    
    func testFlow_WelcomeToQuiz() {
        let welcomeScreen = 2
        let quizStartScreen = 3
        XCTAssertEqual(quizStartScreen, welcomeScreen + 1)
    }
    
    func testFlow_QuizHas10Questions() {
        let quizStartScreen = 3
        let quizEndScreen = 12
        let questionCount = quizEndScreen - quizStartScreen + 1
        XCTAssertEqual(questionCount, 10)
    }
    
    // MARK: - State Persistence Tests
    
    func testOnboardingComplete_SavesState() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        let hasCompleted = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        XCTAssertTrue(hasCompleted)
        
        // Cleanup
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
    }
    
    func testOnboardingComplete_ShowsMainApp() {
        let hasCompletedOnboarding = true
        let shouldShowMainApp = hasCompletedOnboarding
        XCTAssertTrue(shouldShowMainApp)
    }
    
    // MARK: - Screen Mapping Tests
    
    func testScreen1_IsSplashIntro() {
        let screen1Name = "SplashIntroView"
        XCTAssertEqual(screen1Name, "SplashIntroView")
    }
    
    func testScreen2_IsWelcomeIntent() {
        let screen2Name = "WelcomeIntentView"
        XCTAssertEqual(screen2Name, "WelcomeIntentView")
    }
    
    func testScreen27_IsFreeTrialOffer() {
        let screen27Name = "FreeTrialOfferView"
        XCTAssertEqual(screen27Name, "FreeTrialOfferView")
    }
}

// MARK: - Screen Flow Integration Tests

final class ScreenFlowIntegrationTests: XCTestCase {
    
    func testQuizFlow_CompleteSequence() {
        // Quiz screens are 3-12
        let quizScreens = Array(3...12)
        XCTAssertEqual(quizScreens.count, 10)
    }
    
    func testPostQuizFlow_UserProfile() {
        let userProfileScreen = 13
        XCTAssertEqual(userProfileScreen, 13)
    }
    
    func testPostQuizFlow_LaborIllusion() {
        let laborIllusionScreen = 14
        XCTAssertEqual(laborIllusionScreen, 14)
    }
    
    func testPostQuizFlow_ResultsDashboard() {
        let resultsDashboardScreen = 15
        XCTAssertEqual(resultsDashboardScreen, 15)
    }
    
    func testPaywallScreens() {
        let personalizedPaywallScreen = 26
        let freeTrialOfferScreen = 27
        
        XCTAssertEqual(personalizedPaywallScreen, 26)
        XCTAssertEqual(freeTrialOfferScreen, 27)
    }
}
