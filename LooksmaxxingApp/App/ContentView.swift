//
//  ContentView.swift
//  LooksmaxxingApp
//
//  Main navigation controller with proper flow:
//  Age Gate → Disclaimer → Onboarding → Home
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasVerifiedAge") private var hasVerifiedAge = false
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @EnvironmentObject var streakVM: StreakViewModel
    
    var body: some View {
        Group {
            if !hasVerifiedAge {
                AgeGateView()
            } else if !hasAcceptedDisclaimer {
                DisclaimerView()
            } else if !hasCompletedOnboarding {
                OnboardingQuizView()
            } else {
                HomeViewDark()
            }
        }
        .animation(.easeInOut, value: hasVerifiedAge)
        .animation(.easeInOut, value: hasAcceptedDisclaimer)
        .animation(.easeInOut, value: hasCompletedOnboarding)
        .preferredColorScheme(.dark)
        .withErrorAlert()
    }
}

#Preview {
    ContentView()
        .environmentObject(SubscriptionViewModel.shared)
        .environmentObject(StreakViewModel.shared)
}
