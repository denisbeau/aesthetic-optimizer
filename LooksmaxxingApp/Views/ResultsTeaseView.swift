//
//  ResultsTeaseView.swift
//  LooksmaxxingApp
//
//  Shows teased/blurred results before paywall
//  Creates urgency and desire to unlock full analysis
//

import SwiftUI

struct ResultsTeaseView: View {
    @ObservedObject var quizData: OnboardingQuizData
    @State private var showSymptoms = false
    @State private var animateIn = false
    
    // Personalized based on quiz answers
    var potentialScore: String {
        let base = quizData.dedicationLevel >= 8 ? 8.5 : 7.8
        return String(format: "%.1f", base)
    }
    
    var criticalAreas: Int {
        // Based on their struggles and routine level
        if quizData.hasRoutine == "None" { return 4 }
        if quizData.hasRoutine == "Basic" { return 3 }
        return 2
    }
    
    var timeframe: String {
        quizData.timeframe.contains("2 weeks") ? "14 days" : 
        quizData.timeframe.contains("1 month") ? "30 days" : "90 days"
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "0A0A0F")
                .ignoresSafeArea()
            
            if showSymptoms {
                SymptomChecklistView(onboardingData: OnboardingData(), onContinue: {})
            } else {
                ScrollView {
                    VStack(spacing: 24) {
                        // Success header
                        headerSection
                        
                        // Comparison chart
                        comparisonChart
                        
                        // Potential score card
                        potentialScoreCard
                        
                        // Critical areas found
                        criticalAreasCard
                        
                        // Personalized plan preview
                        planPreviewCard
                        
                        // CTA Button
                        ctaButton
                        
                        // Trust indicators
                        trustIndicators
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animateIn = true
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Checkmark animation
            ZStack {
                Circle()
                    .fill(Color(hex: "10B981").opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(Color(hex: "10B981"))
            }
            .scaleEffect(animateIn ? 1 : 0.5)
            .opacity(animateIn ? 1 : 0)
            
            VStack(spacing: 8) {
                Text("Your Profile is Ready")
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                Text("We've analyzed your responses and identified your optimization path.")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "9CA3AF"))
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // MARK: - Potential Score Card
    
    private var potentialScoreCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("YOUR POTENTIAL")
                    .font(.caption.bold())
                    .foregroundColor(Color(hex: "00D4FF"))
                    .tracking(1.5)
                Spacer()
            }
            
            HStack(alignment: .bottom, spacing: 8) {
                Text(potentialScore)
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("/ 10")
                    .font(.title2)
                    .foregroundColor(Color(hex: "6B7280"))
                    .padding(.bottom, 12)
                
                Spacer()
                
                // Improvement indicator
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right")
                            .font(.caption.bold())
                        Text("+2.0")
                            .font(.headline.bold())
                    }
                    .foregroundColor(Color(hex: "10B981"))
                    
                    Text("potential gain")
                        .font(.caption)
                        .foregroundColor(Color(hex: "6B7280"))
                }
            }
            
            // Progress bar showing current vs potential
            VStack(spacing: 8) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color(hex: "1A1A24"))
                            .frame(height: 12)
                            .cornerRadius(6)
                        
                        // Current (estimated)
                        Rectangle()
                            .fill(Color(hex: "6B7280"))
                            .frame(width: geo.size.width * 0.6, height: 12)
                            .cornerRadius(6)
                        
                        // Potential
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "00D4FF"), Color(hex: "10B981")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * 0.85, height: 12)
                            .cornerRadius(6)
                            .opacity(0.5)
                    }
                }
                .frame(height: 12)
                
                HStack {
                    Text("Current: ~6.5")
                        .font(.caption)
                        .foregroundColor(Color(hex: "6B7280"))
                    Spacer()
                    Text("Potential: \(potentialScore)")
                        .font(.caption.bold())
                        .foregroundColor(Color(hex: "00D4FF"))
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "12121A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "00D4FF").opacity(0.3), lineWidth: 1)
                )
        )
        .offset(y: animateIn ? 0 : 20)
        .opacity(animateIn ? 1 : 0)
    }
    
    // MARK: - Critical Areas Card
    
    private var criticalAreasCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(Color(hex: "F59E0B"))
                Text("\(criticalAreas) Critical Areas Identified")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                Spacer()
            }
            
            // Blurred/locked items
            VStack(spacing: 12) {
                criticalAreaRow("Jaw & Mandible Structure", locked: false)
                criticalAreaRow("Facial Symmetry Analysis", locked: true)
                criticalAreaRow("Skin Quality Assessment", locked: true)
                if criticalAreas >= 4 {
                    criticalAreaRow("Posture Impact Score", locked: true)
                }
            }
            
            // Unlock message
            HStack {
                Image(systemName: "lock.fill")
                    .font(.caption)
                Text("Unlock full analysis to see all details")
                    .font(.caption)
            }
            .foregroundColor(Color(hex: "6B7280"))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "12121A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "2A2A34"), lineWidth: 1)
                )
        )
        .offset(y: animateIn ? 0 : 20)
        .opacity(animateIn ? 1 : 0)
    }
    
    private func criticalAreaRow(_ title: String, locked: Bool) -> some View {
        HStack {
            Circle()
                .fill(locked ? Color(hex: "6B7280") : Color(hex: "00D4FF"))
                .frame(width: 8, height: 8)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(locked ? Color(hex: "6B7280") : .white)
                .blur(radius: locked ? 4 : 0)
            
            Spacer()
            
            if locked {
                Image(systemName: "lock.fill")
                    .font(.caption)
                    .foregroundColor(Color(hex: "6B7280"))
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .font(.caption)
                    .foregroundColor(Color(hex: "10B981"))
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "1A1A24"))
        )
    }
    
    // MARK: - Plan Preview Card
    
    private var planPreviewCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("YOUR \(timeframe.uppercased()) PLAN")
                    .font(.caption.bold())
                    .foregroundColor(Color(hex: "10B981"))
                    .tracking(1.5)
                Spacer()
                Text("Personalized")
                    .font(.caption)
                    .foregroundColor(Color(hex: "6B7280"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color(hex: "1A1A24")))
            }
            
            Text("Based on your \(quizData.breathingStatus) status and \(quizData.primaryGoal.lowercased()) goal, we've built your custom routine.")
                .font(.subheadline)
                .foregroundColor(Color(hex: "9CA3AF"))
            
            // Preview items
            HStack(spacing: 16) {
                planItem("Daily\nExercises", "figure.walk", "12")
                planItem("Tracking\nMetrics", "chart.line.uptrend.xyaxis", "8")
                planItem("Weekly\nCheckins", "calendar", "4")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "12121A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "10B981").opacity(0.3), lineWidth: 1)
                )
        )
        .offset(y: animateIn ? 0 : 20)
        .opacity(animateIn ? 1 : 0)
    }
    
    private func planItem(_ title: String, _ icon: String, _ count: String) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color(hex: "1A1A24"))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(Color(hex: "00D4FF"))
            }
            
            Text(count)
                .font(.headline.bold())
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(Color(hex: "6B7280"))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Comparison Chart
    
    private var comparisonChart: some View {
        ComparisonChart()
            .offset(y: animateIn ? 0 : 20)
            .opacity(animateIn ? 1 : 0)
    }
    
    // MARK: - CTA Button
    
    private var ctaButton: some View {
        Button(action: {
            withAnimation {
                showSymptoms = true
            }
        }) {
            HStack {
                Text("View My Transformation Plan")
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
        .offset(y: animateIn ? 0 : 20)
        .opacity(animateIn ? 1 : 0)
    }
    
    // MARK: - Trust Indicators
    
    private var trustIndicators: some View {
        HStack(spacing: 20) {
            trustBadge("12K+", "Users")
            trustBadge("4.8★", "Rating")
            trustBadge("100%", "Private")
        }
        .padding(.vertical, 8)
    }
    
    private func trustBadge(_ value: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.subheadline.bold())
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .foregroundColor(Color(hex: "6B7280"))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Comparison Chart Component

struct ComparisonChart: View {
    @State private var averageHeight: CGFloat = 0
    @State private var userHeight: CGFloat = 0
    @State private var showGapText = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("INDICATIVE ASSESSMENT")
                .font(.caption.bold())
                .foregroundColor(Color(hex: "9CA3AF"))
                .tracking(1.5)
            
            HStack(alignment: .bottom, spacing: 40) {
                // Average Bar
                VStack(spacing: 8) {
                    Text("65%")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "6B7280"))
                        .frame(width: 80, height: 130) // 65% of 200
                    
                    Text("Average User")
                        .font(.caption)
                        .foregroundColor(Color(hex: "D1D5DB"))
                }
                
                // User Bar
                VStack(spacing: 8) {
                    Text("82%")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "00D4FF"), Color(hex: "10B981")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 80, height: userHeight)
                        .shadow(color: Color(hex: "00D4FF").opacity(0.4), radius: 8)
                        .scaleEffect(showGapText ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: showGapText)
                    
                    Text("Your Potential")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
            
            if showGapText {
                Text("You're 24% above average potential")
                    .font(.subheadline.bold())
                    .foregroundColor(Color(hex: "10B981"))
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
            
            Text("Based on general population data")
                .font(.caption2)
                .foregroundColor(Color(hex: "6B7280"))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "12121A"))
        )
        .onAppear {
            // Average bar appears immediately
            averageHeight = 130
            
            // User bar animates after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeOutBack(duration: 1.5)) {
                    userHeight = 164 // 82% of 200
                }
            }
            
            // Gap text appears after bar animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showGapText = true
                }
            }
        }
    }
}

// Custom easing for ease-out-back
extension Animation {
    static func easeOutBack(duration: Double) -> Animation {
        Animation.timingCurve(0.34, 1.56, 0.64, 1, duration: duration)
    }
}

#Preview {
    ResultsTeaseView(quizData: OnboardingQuizData())
}
