import SwiftUI

struct PersonalizedPaywallView: View {
    @Binding var currentScreen: Int
    @ObservedObject var onboardingData: OnboardingData
    
    @State private var showContent = false
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "050914")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                        .frame(height: 50)
                    
                    // Transformation date banner
                    VStack(spacing: 8) {
                        Text("You will transform by:")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(onboardingData.formattedTransformationDate)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(hex: "081630"))
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .shadow(color: .white.opacity(0.2), radius: 10, x: 0, y: 0)
                    }
                    .opacity(showContent ? 1 : 0)
                    
                    // Star rating
                    HStack(spacing: 4) {
                        ForEach(0..<5, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(hex: "FACC15"))
                                .font(.system(size: 14))
                        }
                        Text("12,847 reviews")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.leading, 4)
                    }
                    .opacity(showContent ? 1 : 0)
                    
                    // Benefit badges (from selected goals)
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 10) {
                        ForEach(Array(onboardingData.selectedGoals.prefix(4)), id: \.self) { goalId in
                            if let goal = goalItems.first(where: { $0.id == goalId }) {
                                BenefitBadge(goal: goal)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .opacity(showContent ? 1 : 0)
                    
                    Spacer()
                        .frame(height: 10)
                    
                    // Feature list
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureRow(icon: "waveform.path.ecg", text: "AI Facial Analysis")
                        FeatureRow(icon: "flame.fill", text: "Daily Streak Tracking")
                        FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Progress Visualization")
                        FeatureRow(icon: "bell.fill", text: "Smart Reminders")
                        FeatureRow(icon: "person.fill.checkmark", text: "Personalized Routines")
                    }
                    .padding(.horizontal, 24)
                    .opacity(showContent ? 1 : 0)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // CTA Button with pulse and shimmer
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentScreen = 27
                        }
                    }) {
                        Text("Become a Member")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "081630"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .shadow(color: Color.white.opacity(0.3), radius: 15, x: 0, y: 0)
                    }
                    .scaleEffect(pulseScale)
                    .padding(.horizontal, 24)
                    .opacity(showContent ? 1 : 0)
                    .scaleButtonStyle()
                    
                    // Discrete billing note
                    Text("Purchase appears discretely on statement")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(hex: "9CA3AF"))
                        .opacity(showContent ? 1 : 0)
                    
                    Spacer()
                        .frame(height: 40)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                showContent = true
            }
            
            // Pulse animation
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.5)) {
                    pulseScale = 1.03
                }
                withAnimation(.easeInOut(duration: 0.5).delay(0.5)) {
                    pulseScale = 1.0
                }
            }
        }
    }
}

// MARK: - Benefit Badge
struct BenefitBadge: View {
    let goal: GoalItem
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: goal.icon)
                .font(.system(size: 14))
                .foregroundColor(goal.accentColor)
            
            Text(goal.title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(hex: "0F172A"))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(goal.accentColor.opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(20)
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 18))
                .foregroundColor(Color(hex: "10B981"))
            
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}

#Preview {
    let data = OnboardingData.shared
    data.selectedGoals = ["jawline", "skin", "confidence", "routine"]
    return PersonalizedPaywallView(currentScreen: .constant(26), onboardingData: data)
}
