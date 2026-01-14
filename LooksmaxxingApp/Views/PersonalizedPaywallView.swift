//
//  PersonalizedPaywallView.swift
//  LooksmaxxingApp
//
//  Personalized paywall that references quiz answers
//  Higher conversion through psychological continuity
//

import SwiftUI

struct PersonalizedPaywallView: View {
    @ObservedObject var quizData: OnboardingQuizData
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var selectedPlan = 1 // 0 = weekly, 1 = monthly, 2 = yearly
    
    var potentialScore: String {
        return quizData.potentialScoreFormatted
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "0A0A0F")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Personalized headline
                    headlineSection
                    
                    // Before/After potential
                    transformationCard
                    
                    // Pricing plans
                    pricingSection
                    
                    // What's included
                    featuresSection
                    
                    // Purchase button
                    purchaseButton
                    
                    // Guarantee & terms
                    guaranteeSection
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
        }
    }
    
    // MARK: - Headline Section
    
    private var headlineSection: some View {
        VStack(spacing: 12) {
            // Dynamic headline based on their goal
            Text("From 6.5 to \(potentialScore)")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Get Your Step-by-Step Roadmap")
                .font(.title3.bold())
                .foregroundColor(Color(hex: "00D4FF"))
            
            // Personalized subhead referencing their answers
            Text("Based on your \(quizData.breathingStatus) and \(quizData.primaryGoal.lowercased()) goals, your \(quizData.improvementTimeframe) plan is ready.")
                .font(.subheadline)
                .foregroundColor(Color(hex: "9CA3AF"))
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Transformation Card
    
    private var transformationCard: some View {
        HStack(spacing: 0) {
            // Before
            VStack(spacing: 8) {
                Text("NOW")
                    .font(.caption.bold())
                    .foregroundColor(Color(hex: "6B7280"))
                
                Text("6.5")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "6B7280"))
                
                Text("Current")
                    .font(.caption)
                    .foregroundColor(Color(hex: "6B7280"))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color(hex: "12121A"))
            
            // Arrow
            ZStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "12121A"), Color(hex: "0A1A1F")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 60)
                
                Image(systemName: "arrow.right")
                    .font(.title2.bold())
                    .foregroundColor(Color(hex: "00D4FF"))
            }
            
            // After
            VStack(spacing: 8) {
                Text("POTENTIAL")
                    .font(.caption.bold())
                    .foregroundColor(Color(hex: "00D4FF"))
                
                Text(potentialScore)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "00D4FF"))
                
                Text("With plan")
                    .font(.caption)
                    .foregroundColor(Color(hex: "10B981"))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color(hex: "0A1A1F"))
        }
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "00D4FF").opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Pricing Section
    
    private var pricingSection: some View {
        VStack(spacing: 12) {
            // Monthly (recommended)
            pricingOption(
                index: 1,
                title: "Monthly",
                price: "$14.99",
                period: "/month",
                savings: nil,
                recommended: true
            )
            
            // Yearly
            pricingOption(
                index: 2,
                title: "Yearly",
                price: "$99.99",
                period: "/year",
                savings: "Save 44%",
                recommended: false
            )
            
            // Weekly trial
            pricingOption(
                index: 0,
                title: "Weekly",
                price: "$4.99",
                period: "/week",
                savings: nil,
                recommended: false
            )
        }
    }
    
    private func pricingOption(index: Int, title: String, price: String, period: String, savings: String?, recommended: Bool) -> some View {
        Button(action: {
            selectedPlan = index
        }) {
            HStack {
                // Radio button
                ZStack {
                    Circle()
                        .stroke(selectedPlan == index ? Color(hex: "00D4FF") : Color(hex: "3A3A44"), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if selectedPlan == index {
                        Circle()
                            .fill(Color(hex: "00D4FF"))
                            .frame(width: 14, height: 14)
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        if recommended {
                            Text("BEST VALUE")
                                .font(.caption2.bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(hex: "00D4FF"))
                                .cornerRadius(4)
                        }
                        
                        if let savings = savings {
                            Text(savings)
                                .font(.caption.bold())
                                .foregroundColor(Color(hex: "10B981"))
                        }
                    }
                }
                
                Spacer()
                
                // Price
                HStack(alignment: .bottom, spacing: 2) {
                    Text(price)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    Text(period)
                        .font(.caption)
                        .foregroundColor(Color(hex: "6B7280"))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(selectedPlan == index ? Color(hex: "00D4FF").opacity(0.1) : Color(hex: "12121A"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(selectedPlan == index ? Color(hex: "00D4FF") : Color(hex: "2A2A34"), lineWidth: selectedPlan == index ? 2 : 1)
                    )
            )
        }
    }
    
    // MARK: - Features Section
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Social proof
            HStack(spacing: 6) {
                Image(systemName: "person.3.fill")
                    .foregroundColor(Color(hex: "00D4FF"))
                Text("Join 12,000+ men optimizing their aesthetics")
                    .font(.caption.bold())
                    .foregroundColor(Color(hex: "00D4FF"))
            }
            .padding(.bottom, 8)
            
            Text("WHAT'S INCLUDED")
                .font(.caption.bold())
                .foregroundColor(Color(hex: "6B7280"))
                .tracking(1.5)
            
            featureRow("Unlimited AI facial scans")
            featureRow("Full analysis with all \(quizData.criticalAreasCount) critical areas")
            featureRow("Personalized \(quizData.improvementTimeframe) transformation plan")
            featureRow("Daily exercises for \(quizData.primaryGoal.lowercased())")
            featureRow("\(quizData.breathingStatus.capitalized) correction protocols")
            featureRow("Progress tracking & streak protection")
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "12121A"))
        )
    }
    
    private func featureRow(_ text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color(hex: "10B981"))
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white)
            
            Spacer()
        }
    }
    
    // MARK: - Purchase Button
    
    private var purchaseButton: some View {
        Button(action: purchase) {
            HStack {
                if isPurchasing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Start My Transformation")
                        .font(.headline.bold())
                }
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
        .disabled(isPurchasing)
    }
    
    // MARK: - Guarantee Section
    
    private var guaranteeSection: some View {
        VStack(spacing: 16) {
            // Money back
            HStack(spacing: 8) {
                Image(systemName: "shield.checkered")
                    .foregroundColor(Color(hex: "10B981"))
                Text("Cancel anytime in App Store settings")
                    .font(.caption)
                    .foregroundColor(Color(hex: "6B7280"))
            }
            
            // Restore purchases
            Button(action: {
                Task {
                    try? await subscriptionVM.restorePurchases()
                }
            }) {
                Text("Restore Purchases")
                    .font(.caption)
                    .foregroundColor(Color(hex: "6B7280"))
                    .underline()
            }
            
            // Legal
            HStack(spacing: 16) {
                Button("Terms") {}
                    .font(.caption2)
                    .foregroundColor(Color(hex: "4B5563"))
                
                Button("Privacy") {}
                    .font(.caption2)
                    .foregroundColor(Color(hex: "4B5563"))
            }
        }
    }
    
    // MARK: - Actions
    
    private func purchase() {
        isPurchasing = true
        Task {
            do {
                try await subscriptionVM.purchaseSubscription()
                // Save that onboarding is complete
                UserDefaults.standard.hasCompletedOnboarding = true
            } catch {
                showError = true
            }
            isPurchasing = false
        }
    }
}

#Preview {
    PersonalizedPaywallView(quizData: OnboardingQuizData())
        .environmentObject(SubscriptionViewModel.shared)
}
