//
//  PlanPreviewCardView.swift
//  LooksmaxxingApp
//
//  Virtual ID card showing ownership before paywall
//  Adapted from Quittr's onboarding flow
//

import SwiftUI

struct PlanPreviewCardView: View {
    @ObservedObject var quizData: OnboardingQuizData
    @State private var showPaywall = false
    @State private var cardOffset: CGFloat = 100
    @State private var cardOpacity: Double = 0
    @State private var glintOffset: CGFloat = -200
    @State private var floatOffset: CGFloat = 0
    @State private var glintTimer: Timer?
    
    var userName: String {
        UserDefaults.standard.string(forKey: "userName") ?? "User"
    }
    
    var startDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        ZStack {
            Color(hex: "0A0A0F")
                .ignoresSafeArea()
            
            if showPaywall {
                PersonalizedPaywallView(quizData: quizData)
            } else {
                VStack {
                    Spacer()
                    
                    cardView
                        .offset(y: cardOffset)
                        .opacity(cardOpacity)
                        .offset(y: floatOffset)
                    
                    Spacer()
                }
                .onAppear {
                    startAnimations()
                }
                .onDisappear {
                    glintTimer?.invalidate()
                }
            }
        }
    }
    
    private var cardView: some View {
        ZStack {
            // Animated Mesh Gradient Background
            LinearGradient(
                colors: [
                    Color(hex: "F43F5E"), // Crimson
                    Color(hex: "FB923C"), // Deep Orange
                    Color(hex: "4F46E5")  // Indigo
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .overlay(
                // Gloss effect (glint)
                LinearGradient(
                    colors: [.clear, .white.opacity(0.2), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: glintOffset)
                .frame(width: 200)
            )
            .overlay(
                // Noise/grain texture (optional)
                Color.black.opacity(0.05)
            )
            
            VStack(alignment: .leading, spacing: 0) {
                // Top row
                HStack {
                    // Brand mark
                    ZStack {
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 40, height: 40)
                        Text("LM")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Profile icon
                    Image(systemName: "person.crop.rectangle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                
                Spacer()
                
                // Primary metric
                VStack(alignment: .leading, spacing: 4) {
                    Text("ACTIVE STREAK")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                        .tracking(1.5)
                    
                    Text("0 days")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Personal data row
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("NAME")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                        Text(userName)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("FREE SINCE")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                        Text(startDate)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .frame(width: 340, height: 210)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 15)
    }
    
    private func startAnimations() {
        // Entrance animation
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0)) {
            cardOffset = 0
            cardOpacity = 1
        }
        
        // Glint animation (every 2.5s)
        glintTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 1.0)) {
                glintOffset = 400
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                glintOffset = -200
            }
        }
        
        // Floating animation
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
            floatOffset = 5
        }
        
        // Auto-advance to paywall after 2.2s
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            withAnimation(.easeOut(duration: 0.4)) {
                showPaywall = true
            }
        }
    }
}

#Preview {
    PlanPreviewCardView(quizData: OnboardingQuizData())
}
