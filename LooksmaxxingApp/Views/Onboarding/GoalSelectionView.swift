import SwiftUI

struct GoalSelectionView: View {
    @Binding var currentScreen: Int
    @ObservedObject var onboardingData: OnboardingData
    
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "050914")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("Select your goals")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("What do you want to achieve?")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.top, 60)
                .padding(.bottom, 24)
                .opacity(showContent ? 1 : 0)
                
                // Goals List
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(Array(goalItems.enumerated()), id: \.element.id) { index, goal in
                            GoalRow(
                                goal: goal,
                                isSelected: onboardingData.selectedGoals.contains(goal.id),
                                delay: Double(index) * 0.1
                            ) {
                                toggleGoal(goal.id)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
            
            // Bottom CTA
            VStack {
                Spacer()
                
                ZStack(alignment: .bottom) {
                    LinearGradient(
                        colors: [
                            Color(hex: "050914").opacity(0),
                            Color(hex: "050914")
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 100)
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentScreen = 22
                        }
                    }) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "050914"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(onboardingData.selectedGoals.isEmpty ? Color.white.opacity(0.5) : Color.white)
                            .clipShape(Capsule())
                    }
                    .disabled(onboardingData.selectedGoals.isEmpty)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                showContent = true
            }
        }
    }
    
    private func toggleGoal(_ id: String) {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        if onboardingData.selectedGoals.contains(id) {
            onboardingData.selectedGoals.remove(id)
        } else {
            onboardingData.selectedGoals.insert(id)
        }
    }
}

// MARK: - Goal Row
struct GoalRow: View {
    let goal: GoalItem
    let isSelected: Bool
    let delay: Double
    let action: () -> Void
    
    @State private var appeared = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(goal.accentColor.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: goal.icon)
                        .font(.system(size: 20))
                        .foregroundColor(goal.accentColor)
                }
                
                // Title
                Text(goal.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Checkbox
                ZStack {
                    Circle()
                        .stroke(isSelected ? goal.accentColor : Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 28, height: 28)
                    
                    if isSelected {
                        Circle()
                            .fill(goal.accentColor)
                            .frame(width: 28, height: 28)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(isSelected ? goal.accentColor.opacity(0.1) : Color.white.opacity(0.05))
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? goal.accentColor : Color.white.opacity(0.1), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(delay)) {
                appeared = true
            }
        }
    }
}

#Preview {
    GoalSelectionView(currentScreen: .constant(21), onboardingData: OnboardingData.shared)
}
