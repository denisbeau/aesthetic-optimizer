//
//  ContentView.swift
//  LooksmaxxingApp
//
//  Main navigation controller - shows onboarding or home based on state
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @EnvironmentObject var streakVM: StreakViewModel
    
    var body: some View {
        Group {
            if hasCompletedOnboarding {
                HomeViewDark()
            } else {
                OnboardingQuizView()
            }
        }
        .animation(.easeInOut, value: hasCompletedOnboarding)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environmentObject(SubscriptionViewModel.shared)
        .environmentObject(StreakViewModel.shared)
}
