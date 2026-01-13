//
//  ContentView.swift
//  LooksmaxxingApp
//
//  Main navigation controller with proper flow:
//  Onboarding Quiz (with age verification) → Disclaimer → Home
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer = false
    
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @EnvironmentObject var streakVM: StreakViewModel
    
    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                // Step 1: Boiler room questions (includes age verification)
                OnboardingQuizView()
            } else if !hasAcceptedDisclaimer {
                // Step 2: Important medical/legal disclaimer
                DisclaimerView()
            } else {
                // Step 3: Main app
                HomeViewDark()
            }
        }
        .animation(.easeInOut, value: hasCompletedOnboarding)
        .animation(.easeInOut, value: hasAcceptedDisclaimer)
        .preferredColorScheme(.dark)
        .withErrorAlert()
    }
}

#Preview {
    ContentView()
        .environmentObject(SubscriptionViewModel.shared)
        .environmentObject(StreakViewModel.shared)
}
