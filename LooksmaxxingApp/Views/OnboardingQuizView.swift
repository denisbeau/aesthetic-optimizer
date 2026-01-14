//
//  OnboardingQuizView.swift
//  LooksmaxxingApp
//
//  12-Question "Clinical Assessment" onboarding flow
//  Designed to maximize sunk cost and paywall conversion
//  Based on retention research: 30-50% conversion lift
//

import SwiftUI

struct OnboardingQuizView: View {
    @AppStorage("hasVerifiedAge") private var hasVerifiedAge = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    // Stored quiz answers
    @AppStorage("userGoal") private var userGoal = ""
    @AppStorage("userAgeGroup") private var userAgeGroup = ""
    @AppStorage("userPhotoConfidence") private var userPhotoConfidence = ""
    @AppStorage("userStruggles") private var userStruggles = ""
    @AppStorage("userRoutineLevel") private var userRoutineLevel = ""
    @AppStorage("userSleepHours") private var userSleepHours = ""
    @AppStorage("userDailyCommitment") private var userDailyCommitment = ""
    @AppStorage("userTimeframe") private var userTimeframe = ""
    @AppStorage("userBlockers") private var userBlockers = ""
    @AppStorage("userBreathingType") private var userBreathingType = ""
    @AppStorage("userDedicationLevel") private var userDedicationLevel = 5
    
    @State private var currentStep = 0
    @State private var showUnderageAlert = false
    @State private var selectedAnswer: String?
    @State private var sliderValue: Double = 5
    @State private var animateProgress = false
    @State private var showAnalyzing = false
    
    private let totalSteps = 12
    
    // MARK: - Age Groups (COPPA Compliant)
    enum AgeGroup: String, CaseIterable {
        case under13 = "Under 13"
        case teen13to17 = "13-17"
        case young18to21 = "18-21"
        case mid22to25 = "22-25"
        case late26to29 = "26-29"
        case adult30plus = "30+"
        
        var isAllowed: Bool {
            self != .under13
        }
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "0A0A0F")
                .ignoresSafeArea()
            
            if showAnalyzing {
                // Transition to analyzing flow
                AnalyzingView(quizData: createQuizData())
            } else {
                VStack(spacing: 0) {
                    // Progress Bar
                    progressBar
                        .padding(.top, 60)
                        .padding(.horizontal, 30)
                    
                    // Question Content
                    TabView(selection: $currentStep) {
                        question1_Goal.tag(0)
                        question2_Age.tag(1)
                        question3_PhotoConfidence.tag(2)
                        question4_Struggles.tag(3)
                        question5_Routine.tag(4)
                        question6_Sleep.tag(5)
                        question7_DailyCommitment.tag(6)
                        question8_Timeframe.tag(7)
                        question9_Blockers.tag(8)
                        question10_Breathing.tag(9)
                        question11_Dedication.tag(10)
                        question12_StartScan.tag(11)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeInOut, value: currentStep)
                    
                    // Continue Button
                    continueButton
                        .padding(.horizontal, 30)
                        .padding(.bottom, 50)
                }
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
    
    // MARK: - Create Quiz Data for AnalyzingView
    private func createQuizData() -> OnboardingQuizData {
        let data = OnboardingQuizData()
        data.goal = userGoal
        data.ageGroup = userAgeGroup
        data.timeframe = userTimeframe
        data.dedicationLevel = userDedicationLevel
        data.hasRoutine = userRoutineLevel
        return data
    }
    
    // MARK: - Progress Bar
    private var progressBar: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Step \(currentStep + 1) of \(totalSteps)")
                    .font(.caption)
                    .foregroundColor(Color(hex: "6B7280"))
                Spacer()
                
                // Time estimate
                Text("~\(max(1, (totalSteps - currentStep) / 2)) min left")
                    .font(.caption)
                    .foregroundColor(Color(hex: "4B5563"))
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
    
    // MARK: - Question 1: Primary Aesthetic Goal (Commitment/Consistency)
    private var question1_Goal: some View {
        questionTemplate(
            icon: "target",
            title: "What is your primary aesthetic goal?",
            subtitle: "This sets the foundation for your personalized plan",
            options: [
                "🔥 Sharper Jawline",
                "✨ Better Skin",
                "⚖️ Better Facial Symmetry",
                "💎 Overall Glow-up"
            ]
        )
    }
    
    // MARK: - Question 2: Age (Personalization + COPPA)
    private var question2_Age: some View {
        questionTemplate(
            icon: "person.crop.circle",
            title: "How old are you?",
            subtitle: "Our AI adjusts recommendations for your developmental stage",
            options: AgeGroup.allCases.map { $0.rawValue }
        )
    }
    
    // MARK: - Question 3: Photo Confidence (Problem Amplification)
    private var question3_PhotoConfidence: some View {
        questionTemplate(
            icon: "camera.fill",
            title: "How often do you feel confident in photos?",
            subtitle: "Be honest - we're building your baseline",
            options: [
                "😎 Always confident",
                "🙂 Sometimes confident",
                "😕 Rarely confident",
                "🚫 I avoid photos"
            ]
        )
    }
    
    // MARK: - Question 4: Specific Struggles (Specific Identification)
    private var question4_Struggles: some View {
        questionTemplate(
            icon: "exclamationmark.triangle.fill",
            title: "Which of these do you struggle with most?",
            subtitle: "We understand the technical aspects of looksmaxxing",
            options: [
                "👄 Mouth breathing habits",
                "🧍 Poor posture",
                "🔴 Uneven skin texture",
                "📐 Receded chin/weak jaw"
            ]
        )
    }
    
    // MARK: - Question 5: Current Routine (Gap Analysis)
    private var question5_Routine: some View {
        questionTemplate(
            icon: "sparkles",
            title: "Do you currently follow a grooming or skincare routine?",
            subtitle: "We'll fill in what's missing",
            options: [
                "❌ None at all",
                "🌱 Basic (wash face)",
                "📊 Intermediate (multiple products)",
                "💯 Advanced (full regimen)"
            ]
        )
    }
    
    // MARK: - Question 6: Sleep Hours (Variables of Success)
    private var question6_Sleep: some View {
        questionTemplate(
            icon: "moon.fill",
            title: "How many hours of sleep do you average?",
            subtitle: "Sleep directly impacts facial aesthetics",
            options: [
                "😴 Less than 6 hours",
                "🌙 6-7 hours",
                "💤 8+ hours"
            ]
        )
    }
    
    // MARK: - Question 7: Daily Commitment (Micro-Commitment)
    private var question7_DailyCommitment: some View {
        questionTemplate(
            icon: "clock.fill",
            title: "Are you willing to commit 10 mins/day to exercises?",
            subtitle: "Consistency is key to transformation",
            options: [
                "✅ Yes, absolutely",
                "🤷 Maybe, depends",
                "❌ No, too busy"
            ]
        )
    }
    
    // MARK: - Question 8: Timeframe (Urgency)
    private var question8_Timeframe: some View {
        questionTemplate(
            icon: "calendar",
            title: "How soon do you want to see visible results?",
            subtitle: "We'll adjust intensity accordingly",
            options: [
                "⚡ 2 weeks (Intense mode)",
                "📅 1 month (Balanced)",
                "🗓️ 3 months (Sustainable)"
            ]
        )
    }
    
    // MARK: - Question 9: Blockers (Objection Pre-emption)
    private var question9_Blockers: some View {
        questionTemplate(
            icon: "hand.raised.fill",
            title: "What has stopped you from improving before?",
            subtitle: "We've designed solutions for each of these",
            options: [
                "🤔 Lack of knowledge",
                "🔄 Consistency issues",
                "📋 No clear plan to follow",
                "⏰ Not enough time"
            ]
        )
    }
    
    // MARK: - Question 10: Breathing Type (Authority/Mewing)
    private var question10_Breathing: some View {
        questionTemplate(
            icon: "wind",
            title: "Do you typically breathe through your mouth or nose?",
            subtitle: "This significantly impacts facial development",
            options: [
                "👃 Mostly nose",
                "👄 Mostly mouth",
                "🤷 Unsure / Both"
            ]
        )
    }
    
    // MARK: - Question 11: Dedication Scale (Self-Labeling)
    private var question11_Dedication: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Icon
            Image(systemName: "flame.fill")
                .font(.system(size: 60))
                .foregroundColor(Color(hex: "00D4FF"))
                .padding(.bottom, 10)
            
            // Title
            VStack(spacing: 8) {
                Text("On a scale of 1-10, how dedicated are you?")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("High dedication = better results")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "6B7280"))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)
            
            // Slider
            VStack(spacing: 16) {
                // Current value display
                Text("\(Int(sliderValue))")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundColor(sliderValue >= 8 ? Color(hex: "10B981") : sliderValue >= 5 ? Color(hex: "F59E0B") : Color(hex: "EF4444"))
                
                // Labels
                HStack {
                    Text("Casual")
                        .font(.caption)
                        .foregroundColor(Color(hex: "6B7280"))
                    Spacer()
                    Text("Obsessed")
                        .font(.caption)
                        .foregroundColor(Color(hex: "6B7280"))
                }
                
                // Slider
                Slider(value: $sliderValue, in: 1...10, step: 1)
                    .accentColor(Color(hex: "00D4FF"))
                    .onChange(of: sliderValue) { _ in
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                    }
                
                // Motivational text based on value
                Text(dedicationMessage)
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "9CA3AF"))
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
    }
    
    private var dedicationMessage: String {
        switch Int(sliderValue) {
        case 1...3: return "Every journey starts somewhere. Let's build momentum."
        case 4...5: return "Good start. Consistency will get you there."
        case 6...7: return "Solid commitment. You're ready for real progress."
        case 8...9: return "High dedication detected. Expect accelerated results."
        case 10: return "Maximum dedication. You're going to crush this."
        default: return ""
        }
    }
    
    // MARK: - Question 12: Start Scan (Momentum/Action)
    private var question12_StartScan: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Animated icon
            ZStack {
                Circle()
                    .fill(Color(hex: "00D4FF").opacity(0.1))
                    .frame(width: 140, height: 140)
                
                Circle()
                    .fill(Color(hex: "00D4FF").opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "faceid")
                    .font(.system(size: 50))
                    .foregroundColor(Color(hex: "00D4FF"))
            }
            
            // Title
            VStack(spacing: 12) {
                Text("Final Step")
                    .font(.caption.bold())
                    .foregroundColor(Color(hex: "00D4FF"))
                    .tracking(2)
                
                Text("Ready to analyze your facial structure?")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Our AI will scan 50+ aesthetic data points to create your personalized transformation plan.")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "9CA3AF"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .padding(.horizontal, 20)
            
            // Summary of their answers
            VStack(spacing: 12) {
                summaryRow("Goal", userGoal.isEmpty ? "Set" : String(userGoal.dropFirst(2)))
                summaryRow("Timeframe", userTimeframe.isEmpty ? "Set" : String(userTimeframe.dropFirst(2)))
                summaryRow("Dedication", "\(Int(sliderValue))/10")
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "12121A"))
            )
            .padding(.horizontal, 30)
            
            Spacer()
            Spacer()
        }
    }
    
    private func summaryRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(Color(hex: "6B7280"))
            Spacer()
            Text(value)
                .font(.subheadline.bold())
                .foregroundColor(.white)
        }
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
            
            // Options (scrollable for many options)
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(options, id: \.self) { option in
                        optionButton(option)
                    }
                }
                .padding(.horizontal, 30)
            }
            
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
                if currentStep == totalSteps - 1 {
                    Image(systemName: "faceid")
                    Text("Start AI Analysis")
                } else {
                    Text("Continue")
                    Image(systemName: "arrow.right")
                }
            }
            .font(.headline.bold())
            .foregroundColor(canContinue ? .black : .white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(canContinue ? Color(hex: "00D4FF") : Color(hex: "2A2A34"))
            )
        }
        .disabled(!canContinue)
    }
    
    private var canContinue: Bool {
        if currentStep == 10 { // Slider question
            return true // Slider always has a value
        }
        if currentStep == 11 { // Final scan step
            return true // Always can proceed
        }
        return selectedAnswer != nil
    }
    
    // MARK: - Handle Continue
    private func handleContinue() {
        // Save answer based on step
        switch currentStep {
        case 0: // Goal
            userGoal = selectedAnswer ?? ""
            
        case 1: // Age
            guard let answer = selectedAnswer else { return }
            // Check COPPA compliance
            if answer == AgeGroup.under13.rawValue {
                showUnderageAlert = true
                return
            }
            userAgeGroup = answer
            hasVerifiedAge = true
            
        case 2: // Photo confidence
            userPhotoConfidence = selectedAnswer ?? ""
            
        case 3: // Struggles
            userStruggles = selectedAnswer ?? ""
            
        case 4: // Routine level
            userRoutineLevel = selectedAnswer ?? ""
            
        case 5: // Sleep
            userSleepHours = selectedAnswer ?? ""
            
        case 6: // Daily commitment
            userDailyCommitment = selectedAnswer ?? ""
            
        case 7: // Timeframe
            userTimeframe = selectedAnswer ?? ""
            
        case 8: // Blockers
            userBlockers = selectedAnswer ?? ""
            
        case 9: // Breathing
            userBreathingType = selectedAnswer ?? ""
            
        case 10: // Dedication (slider)
            userDedicationLevel = Int(sliderValue)
            
        case 11: // Start scan - transition to analyzing
            withAnimation {
                showAnalyzing = true
            }
            return
            
        default:
            break
        }
        
        // Move to next step
        if currentStep < totalSteps - 1 {
            withAnimation(.easeInOut) {
                selectedAnswer = nil
                currentStep += 1
            }
        }
        
        // Haptic
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
}

#Preview {
    OnboardingQuizView()
}
