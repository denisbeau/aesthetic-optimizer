//
//  PreQuizOnboardingView.swift
//  LooksmaxxingApp
//
//  Pre-quiz investment screens to build passive commitment
//  Adapted from Quittr's onboarding flow
//

import SwiftUI

struct PreQuizScreen {
    let headline: String
    let subtext: String
    let icon: String
    let visualColor: String
}

struct PreQuizOnboardingView: View {
    @State private var currentPage = 0
    @AppStorage("hasSeenPreQuiz") private var hasSeenPreQuiz = false
    @State private var showQuiz = false
    
    let screens = [
        PreQuizScreen(
            headline: "AI-Powered Facial Analysis",
            subtext: "Identifies 50+ aesthetic data points through advanced computer vision",
            icon: "faceid",
            visualColor: "00D4FF"
        ),
        PreQuizScreen(
            headline: "Join 12,000+ Users",
            subtext: "Optimizing their facial aesthetics with personalized plans",
            icon: "person.3.fill",
            visualColor: "10B981"
        ),
        PreQuizScreen(
            headline: "Your Transformation Journey Starts Here",
            subtext: "From receded chin to defined jawline in 90 days",
            icon: "arrow.up.circle.fill",
            visualColor: "F59E0B"
        ),
        PreQuizScreen(
            headline: "Do You Avoid Photos?",
            subtext: "Because of your jawline, symmetry, or skin concerns?",
            icon: "camera.fill",
            visualColor: "F43F5E"
        ),
        PreQuizScreen(
            headline: "70% Have Facial Asymmetry",
            subtext: "Most don't realize it until they see the data",
            icon: "chart.bar.fill",
            visualColor: "8B5CF6"
        ),
        PreQuizScreen(
            headline: "Facial Structure Responds to Daily Habits",
            subtext: "Mewing, posture, and targeted exercises create lasting change",
            icon: "figure.stand",
            visualColor: "3B82F6"
        ),
        PreQuizScreen(
            headline: "Welcome! Let's Assess Your Potential",
            subtext: "Our AI will analyze your responses and create a personalized plan",
            icon: "star.fill",
            visualColor: "FFD700"
        )
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "0A0A0F")
                .ignoresSafeArea()
            
            if showQuiz {
                OnboardingQuizView()
            } else {
                VStack(spacing: 0) {
                    // Skip button
                    HStack {
                        Spacer()
                        Button(action: {
                            hasSeenPreQuiz = true
                            showQuiz = true
                        }) {
                            Text("Skip")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "6B7280"))
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    }
                    
                    TabView(selection: $currentPage) {
                        ForEach(0..<screens.count, id: \.self) { index in
                            screenView(screens[index], index: index)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                }
            }
        }
    }
    
    private func screenView(_ screen: PreQuizScreen, index: Int) -> some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon/Visual
            ZStack {
                Circle()
                    .fill(Color(hex: screen.visualColor).opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: screen.icon)
                    .font(.system(size: 48))
                    .foregroundColor(Color(hex: screen.visualColor))
            }
            .scaleEffect(currentPage == index ? 1.0 : 0.8)
            .opacity(currentPage == index ? 1.0 : 0.5)
            .animation(.easeOut(duration: 0.5), value: currentPage)
            
            // Text content
            VStack(spacing: 16) {
                Text(screen.headline)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Text(screen.subtext)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(hex: "9CA3AF"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            // CTA on last screen
            if index == screens.count - 1 {
                Button(action: {
                    hasSeenPreQuiz = true
                    showQuiz = true
                }) {
                    HStack {
                        Text("Start Assessment")
                            .font(.headline.bold())
                        Image(systemName: "arrow.right")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "00D4FF"), Color(hex: "0099CC")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(14)
                    .shadow(color: Color(hex: "00D4FF").opacity(0.4), radius: 12, x: 0, y: 6)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            } else {
                Spacer()
                    .frame(height: 40)
            }
        }
        .padding(.vertical, 40)
    }
}

#Preview {
    PreQuizOnboardingView()
}
