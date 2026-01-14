//
//  GoalsSelectionView.swift
//  LooksmaxxingApp
//
//  Goals selection screen for future-state commitment
//  Adapted from Quittr's onboarding flow
//

import SwiftUI

struct GoalItem: Identifiable {
    let id: String
    let title: String
    let icon: String
    let category: String
    let color: String
}

struct GoalsSelectionView: View {
    @ObservedObject var quizData: OnboardingQuizData
    @State private var selectedGoals: Set<String> = []
    @State private var showSignature = false
    
    let goals = [
        GoalItem(id: "sharper_jawline", title: "Sharper, more defined jawline", icon: "🔥", category: "physical", color: "#F59E0B"),
        GoalItem(id: "better_skin", title: "Better skin texture and glow", icon: "✨", category: "appearance", color: "#3B82F6"),
        GoalItem(id: "improved_symmetry", title: "Improved facial symmetry", icon: "⚖️", category: "appearance", color: "#8B5CF6"),
        GoalItem(id: "increased_confidence", title: "Increased confidence in photos", icon: "💪", category: "confidence", color: "#F43F5E"),
        GoalItem(id: "fix_breathing", title: "Fix mouth breathing habits", icon: "👃", category: "functional", color: "#8B5CF6"),
        GoalItem(id: "better_posture", title: "Better posture and presence", icon: "🧍", category: "functional", color: "#10B981"),
        GoalItem(id: "overall_transformation", title: "Overall aesthetic transformation", icon: "💎", category: "general", color: "#00D4FF")
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "0A0A0F")
                .ignoresSafeArea()
            
            if showSignature {
                CommitmentSignatureView(quizData: quizData)
            } else {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 12) {
                        Text("Select Your Goals")
                            .font(.title.bold())
                            .foregroundColor(.white)
                        
                        Text("Select 1-3 goals that matter most")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "9CA3AF"))
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(goals.enumerated()), id: \.element.id) { index, goal in
                                goalRow(goal)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 100)
                    }
                    
                    // Sticky continue button
                    VStack {
                        LinearGradient(
                            colors: [Color(hex: "0A0A0F").opacity(0), Color(hex: "0A0A0F")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 20)
                        
                        Button(action: {
                            quizData.selectedGoals = Array(selectedGoals)
                            quizData.saveToUserDefaults()
                            withAnimation {
                                showSignature = true
                            }
                        }) {
                            Text("Continue")
                                .font(.headline.bold())
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
                        }
                        .disabled(selectedGoals.isEmpty)
                        .opacity(selectedGoals.isEmpty ? 0.5 : 1.0)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                    }
                    .background(Color(hex: "0A0A0F"))
                }
            }
        }
        .onAppear {
            // Load existing selections
            selectedGoals = Set(quizData.selectedGoals)
        }
    }
    
    private func goalRow(_ goal: GoalItem) -> some View {
        Button(action: {
            if selectedGoals.contains(goal.id) {
                selectedGoals.remove(goal.id)
            } else if selectedGoals.count < 3 {
                selectedGoals.insert(goal.id)
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
            }
        }) {
            HStack(spacing: 16) {
                Text(goal.icon)
                    .font(.system(size: 24))
                
                Text(goal.title)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 28, height: 28)
                    
                    if selectedGoals.contains(goal.id) {
                        Circle()
                            .fill(Color(hex: goal.color))
                            .frame(width: 28, height: 28)
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        Capsule()
                            .stroke(selectedGoals.contains(goal.id) ? Color(hex: goal.color).opacity(0.8) : Color.white.opacity(0.15), lineWidth: selectedGoals.contains(goal.id) ? 2 : 1)
                    )
            )
            .shadow(color: selectedGoals.contains(goal.id) ? Color(hex: goal.color).opacity(0.3) : .clear, radius: 8)
            .scaleEffect(selectedGoals.contains(goal.id) ? 1.02 : 1.0)
            .animation(.easeOut(duration: 0.2), value: selectedGoals.contains(goal.id))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    GoalsSelectionView(quizData: OnboardingQuizData())
}
