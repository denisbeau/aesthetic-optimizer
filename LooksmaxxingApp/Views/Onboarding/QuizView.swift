import SwiftUI

struct QuizView: View {
    @Binding var currentScreen: Int
    @ObservedObject var onboardingData: OnboardingData
    
    @State private var currentQuestionIndex = 0
    @State private var selectedOption: String? = nil
    @State private var isTransitioning = false
    @State private var opacity: Double = 1
    @State private var scale: CGFloat = 1
    
    private var currentQuestion: QuizQuestion {
        quizQuestions[currentQuestionIndex]
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "050914")
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("QUESTION #\(currentQuestionIndex + 1)")
                        .font(.system(size: 12, weight: .semibold))
                        .tracking(2)
                        .foregroundColor(.white.opacity(0.6))
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 2)
                        .frame(maxWidth: 60)
                }
                .padding(.top, 60)
                
                // Question Text
                Text(currentQuestion.question)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                
                Spacer()
                    .frame(height: 20)
                
                // Options
                VStack(spacing: 12) {
                    ForEach(Array(currentQuestion.options.enumerated()), id: \.offset) { index, option in
                        QuizOptionButton(
                            index: index + 1,
                            text: option,
                            isSelected: selectedOption == option,
                            action: {
                                selectOption(option)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .opacity(opacity)
            .scaleEffect(scale)
        }
    }
    
    private func selectOption(_ option: String) {
        guard !isTransitioning else { return }
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        selectedOption = option
        isTransitioning = true
        
        // Store the answer
        storeAnswer(option)
        
        // Auto-advance after 350ms
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            if currentQuestionIndex < quizQuestions.count - 1 {
                // Transition animation
                withAnimation(.easeInOut(duration: 0.3)) {
                    opacity = 0
                    scale = 0.98
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    currentQuestionIndex += 1
                    selectedOption = nil
                    isTransitioning = false
                    
                    withAnimation(.easeInOut(duration: 0.3)) {
                        opacity = 1
                        scale = 1
                    }
                }
            } else {
                // Quiz complete - go to profile input
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentScreen = 13
                }
            }
        }
    }
    
    private func storeAnswer(_ answer: String) {
        switch currentQuestionIndex {
        case 0: onboardingData.primaryGoal = answer
        case 1: onboardingData.checkFrequency = answer
        case 2: onboardingData.comparisonSource = answer
        case 3: onboardingData.hasGottenWorse = (answer == "Yes")
        case 4: onboardingData.concernOnset = answer
        case 5: onboardingData.physicalHabits = answer
        case 6: onboardingData.photoAvoidance = answer
        case 7: onboardingData.stressMirrorCheck = answer
        case 8: onboardingData.socialMediaTrigger = (answer == "Yes")
        case 9: onboardingData.hasSpentMoney = (answer == "Yes")
        default: break
        }
    }
}

// MARK: - Quiz Option Button
struct QuizOptionButton: View {
    let index: Int
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Index indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color(hex: "10B981") : Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 32, height: 32)
                    
                    if isSelected {
                        Circle()
                            .fill(Color(hex: "10B981"))
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        Text("\(index)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(isSelected ? Color(hex: "10B981").opacity(0.1) : Color(hex: "0B1222"))
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color(hex: "10B981") : Color.white.opacity(0.15), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    QuizView(currentScreen: .constant(3), onboardingData: OnboardingData.shared)
}
