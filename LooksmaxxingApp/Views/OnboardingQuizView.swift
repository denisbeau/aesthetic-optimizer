//
//  OnboardingQuizView.swift
//  LooksmaxxingApp
//
//  Boiler room style onboarding - psychologically primes users
//  Includes age verification (COPPA compliance)
//

import SwiftUI

struct OnboardingQuizView: View {
    @AppStorage("hasVerifiedAge") private var hasVerifiedAge = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("userAgeGroup") private var userAgeGroup = ""
    @AppStorage("userGoal") private var userGoal = ""
    @AppStorage("userCommitmentLevel") private var userCommitmentLevel = ""
    @AppStorage("userTimeframe") private var userTimeframe = ""
    
    @State private var currentStep = 0
    @State private var showUnderageAlert = false
    @State private var selectedAnswer: String?
    @State private var animateProgress = false
    
    private let totalSteps = 5
    
    // MARK: - Age Groups (COPPA Compliant)
    enum AgeGroup: String, CaseIterable {
        case under13 = "Under 13"
        case teen13to16 = "13-16"
        case teen16to18 = "16-18"
        case youngAdult = "18-25"
        case adult = "25+"
        
        var isAllowed: Bool {
            self != .under13
        }
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "0A0A0F")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress Bar
                progressBar
                    .padding(.top, 60)
                    .padding(.horizontal, 30)
                
                // Question Content
                TabView(selection: $currentStep) {
                    ageQuestion.tag(0)
                    goalQuestion.tag(1)
                    currentStateQuestion.tag(2)
                    commitmentQuestion.tag(3)
                    timeframeQuestion.tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentStep)
                
                // Continue Button
                continueButton
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
            }
        }
        .alert("Age Requirement", isPresented: $showUnderageAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You must be at least 13 years old to use this app. If you are under 13, please ask a parent or guardian for assistance.")
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animateProgress = true
            }
        }
    }
    
    // MARK: - Progress Bar
    private var progressBar: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Step \(currentStep + 1) of \(totalSteps)")
                    .font(.caption)
                    .foregroundColor(Color(hex: "6B7280"))
                Spacer()
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "1F1F2E"))
                        .frame(height: 8)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "00D4FF"), Color(hex: "7C3AED")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: animateProgress ? geo.size.width * CGFloat(currentStep + 1) / CGFloat(totalSteps) : 0, height: 8)
                        .animation(.easeInOut(duration: 0.5), value: currentStep)
                }
            }
            .frame(height: 8)
        }
    }
    
    // MARK: - Question 1: Age (COPPA)
    private var ageQuestion: some View {
        questionTemplate(
            icon: "person.crop.circle",
            title: "How old are you?",
            subtitle: "We personalize your experience based on age",
            options: AgeGroup.allCases.map { $0.rawValue }
        )
    }
    
    // MARK: - Question 2: Goal
    private var goalQuestion: some View {
        questionTemplate(
            icon: "target",
            title: "What's your #1 goal?",
            subtitle: "We'll create a personalized plan for you",
            options: [
                "🔥 Sharper Jawline",
                "✨ Clearer Skin",
                "👁️ Better Eye Area",
                "💪 Overall Attractiveness",
                "📸 More Photogenic"
            ]
        )
    }
    
    // MARK: - Question 3: Current State
    private var currentStateQuestion: some View {
        questionTemplate(
            icon: "chart.bar",
            title: "How would you rate yourself now?",
            subtitle: "Be honest - this is your starting point",
            options: [
                "1-3: Need major improvement",
                "4-5: Below average",
                "6-7: Average",
                "8-9: Above average",
                "10: Already peak"
            ]
        )
    }
    
    // MARK: - Question 4: Commitment
    private var commitmentQuestion: some View {
        questionTemplate(
            icon: "flame.fill",
            title: "How committed are you?",
            subtitle: "Real results require real effort",
            options: [
                "🔥 100% - Whatever it takes",
                "💪 High - Ready to work",
                "👍 Medium - Will try my best",
                "🤔 Low - Just exploring"
            ]
        )
    }
    
    // MARK: - Question 5: Timeframe
    private var timeframeQuestion: some View {
        questionTemplate(
            icon: "clock.fill",
            title: "When do you want results?",
            subtitle: "Realistic expectations = sustainable progress",
            options: [
                "⚡ 1-2 weeks",
                "📅 1 month",
                "🗓️ 3 months",
                "📆 6+ months"
            ]
        )
    }
    
    // MARK: - Question Template
    private func questionTemplate(icon: String, title: String, subtitle: String, options: [String]) -> some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Icon
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(Color(hex: "00D4FF"))
                .padding(.bottom, 10)
            
            // Title
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "6B7280"))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)
            
            // Options
            VStack(spacing: 12) {
                ForEach(options, id: \.self) { option in
                    optionButton(option)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
            Spacer()
        }
    }
    
    // MARK: - Option Button
    private func optionButton(_ option: String) -> some View {
        Button(action: { 
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedAnswer = option
            }
            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }) {
            HStack {
                Text(option)
                    .font(.body)
                    .foregroundColor(.white)
                
                Spacer()
                
                if selectedAnswer == option {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "00D4FF"))
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(selectedAnswer == option ? Color(hex: "00D4FF").opacity(0.15) : Color(hex: "12121A"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(selectedAnswer == option ? Color(hex: "00D4FF") : Color(hex: "2A2A34"), lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Continue Button
    private var continueButton: some View {
        Button(action: handleContinue) {
            HStack {
                Text(currentStep == totalSteps - 1 ? "Get Started" : "Continue")
                    .font(.headline.bold())
                
                if currentStep == totalSteps - 1 {
                    Image(systemName: "arrow.right")
                }
            }
            .foregroundColor(selectedAnswer != nil ? .black : .white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(selectedAnswer != nil ? Color(hex: "00D4FF") : Color(hex: "2A2A34"))
            )
        }
        .disabled(selectedAnswer == nil)
    }
    
    // MARK: - Handle Continue
    private func handleContinue() {
        guard let answer = selectedAnswer else { return }
        
        // Save answer based on step
        switch currentStep {
        case 0: // Age
            // Check COPPA compliance
            if answer == AgeGroup.under13.rawValue {
                showUnderageAlert = true
                return
            }
            userAgeGroup = answer
            hasVerifiedAge = true
            
        case 1: // Goal
            userGoal = answer
            
        case 2: // Current state - just informational
            break
            
        case 3: // Commitment
            userCommitmentLevel = answer
            
        case 4: // Timeframe
            userTimeframe = answer
            
        default:
            break
        }
        
        // Move to next step or complete
        if currentStep < totalSteps - 1 {
            withAnimation(.easeInOut) {
                selectedAnswer = nil
                currentStep += 1
            }
        } else {
            // Quiz complete
            hasCompletedOnboarding = true
        }
        
        // Haptic
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
}

#Preview {
    OnboardingQuizView()
}
