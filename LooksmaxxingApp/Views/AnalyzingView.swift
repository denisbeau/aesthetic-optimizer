//
//  AnalyzingView.swift
//  LooksmaxxingApp
//
//  "Calculating your plan" loading screen with animated progress
//  Creates perceived value through fake processing steps
//

import SwiftUI

struct AnalyzingView: View {
    @ObservedObject var quizData: OnboardingQuizData
    @State private var currentStep = 0
    @State private var showResults = false
    @State private var progress: CGFloat = 0
    @State private var currentLabelIndex = 0
    @State private var labelTimer: Timer?
    
    let steps = [
        ("Analyzing facial architecture", "faceid"),
        ("Scanning mandible structure", "face.smiling"),
        ("Assessing orbital symmetry", "eye"),
        ("Evaluating skin texture", "sparkles"),
        ("Comparing to 50,000+ data points", "chart.bar.fill"),
        ("Building your personalized plan", "doc.text.fill")
    ]
    
    let processingLabels = [
        "Analyzing facial architecture...",
        "Comparing to 50,000+ data points...",
        "Synthesizing your transformation plan...",
        "Calculating potential improvements..."
    ]
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "0A0A0F")
                .ignoresSafeArea()
            
            if showResults {
                ResultsTeaseView(quizData: quizData)
            } else {
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Animated face scan icon
                    scanAnimation
                    
                    // Title
                    VStack(spacing: 8) {
                        Text("Analyzing Your Profile")
                            .font(.title.bold())
                            .foregroundColor(.white)
                        
                        // Rotating label
                        Text(processingLabels[currentLabelIndex])
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(height: 24)
                            .id(currentLabelIndex)
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .move(edge: .bottom)),
                                removal: .opacity.combined(with: .move(edge: .top))
                            ))
                    }
                    
                    // Progress steps
                    stepsView
                    
                    // Overall progress bar
                    overallProgress
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
        .onAppear {
            startAnalysis()
            startLabelRotation()
        }
        .onDisappear {
            labelTimer?.invalidate()
        }
    }
    
    // MARK: - Scan Animation
    
    private var scanAnimation: some View {
        ZStack {
            // Outer pulse
            Circle()
                .stroke(Color(hex: "00D4FF").opacity(0.2), lineWidth: 2)
                .frame(width: 140, height: 140)
                .scaleEffect(progress > 0.1 ? 1.2 : 1.0)
                .opacity(progress > 0.1 ? 0.5 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: progress)
            
            // Middle ring
            Circle()
                .stroke(Color(hex: "00D4FF").opacity(0.4), lineWidth: 3)
                .frame(width: 110, height: 110)
            
            // Inner circle with icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "00D4FF").opacity(0.2), Color(hex: "00D4FF").opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "faceid")
                    .font(.system(size: 36))
                    .foregroundColor(Color(hex: "00D4FF"))
            }
            
            // Scanning line animation
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.clear, Color(hex: "00D4FF").opacity(0.8), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 100, height: 4)
                .offset(y: progress > 0.5 ? 40 : -40)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: progress)
        }
    }
    
    // MARK: - Steps View
    
    private var stepsView: some View {
        VStack(spacing: 16) {
            ForEach(0..<steps.count, id: \.self) { index in
                HStack(spacing: 16) {
                    // Status icon
                    ZStack {
                        Circle()
                            .fill(index < currentStep ? Color(hex: "10B981") : 
                                  index == currentStep ? Color(hex: "00D4FF").opacity(0.2) : Color(hex: "1A1A24"))
                            .frame(width: 32, height: 32)
                        
                        if index < currentStep {
                            Image(systemName: "checkmark")
                                .font(.caption.bold())
                                .foregroundColor(.white)
                        } else if index == currentStep {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "00D4FF")))
                                .scaleEffect(0.7)
                        } else {
                            Image(systemName: steps[index].1)
                                .font(.caption)
                                .foregroundColor(Color(hex: "6B7280"))
                        }
                    }
                    
                    // Step text
                    Text(steps[index].0)
                        .font(.subheadline)
                        .foregroundColor(index <= currentStep ? .white : Color(hex: "6B7280"))
                    
                    Spacer()
                }
                .opacity(index <= currentStep + 1 ? 1 : 0.3)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "12121A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "1A1A24"), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Overall Progress
    
    private var overallProgress: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Overall Progress")
                    .font(.caption)
                    .foregroundColor(Color(hex: "6B7280"))
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption.bold())
                    .foregroundColor(Color(hex: "00D4FF"))
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(hex: "1A1A24"))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "00D4FF"), Color(hex: "10B981")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * progress, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
    
    // MARK: - Analysis Logic
    
    private func startAnalysis() {
        // Animate through each step
        for i in 0..<steps.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 1.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentStep = i + 1
                    progress = CGFloat(i + 1) / CGFloat(steps.count)
                }
            }
        }
        
        // Show results after all steps
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(steps.count) * 1.5 + 0.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showResults = true
            }
        }
    }
    
    private func startLabelRotation() {
        labelTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentLabelIndex = (currentLabelIndex + 1) % processingLabels.count
            }
            
            // Optional: Light haptic on label change
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
    }
}

#Preview {
    AnalyzingView(quizData: OnboardingQuizData())
}
