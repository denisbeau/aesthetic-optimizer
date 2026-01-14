//
//  SymptomsSelectionView.swift
//  LooksmaxxingApp
//
//  Multi-select symptom checklist for problem multiplication
//  Adapted from Quittr's onboarding flow
//

import SwiftUI

struct SymptomGroup: Identifiable {
    let id: String
    let label: String
    let items: [SymptomItem]
}

struct SymptomItem: Identifiable {
    let id: String
    let text: String
}

struct SymptomsSelectionView: View {
    @ObservedObject var quizData: OnboardingQuizData
    @State private var selectedSymptoms: Set<String> = []
    @State private var showGoals = false
    
    let symptomGroups = [
        SymptomGroup(
            id: "confidence",
            label: "CONFIDENCE/BEHAVIORAL",
            items: [
                SymptomItem(id: "avoid_photos", text: "I avoid photos because of my jawline"),
                SymptomItem(id: "self_conscious", text: "I feel self-conscious about my side profile"),
                SymptomItem(id: "compare_others", text: "I compare myself to others constantly"),
                SymptomItem(id: "tried_routines", text: "I've tried multiple routines but gave up")
            ]
        ),
        SymptomGroup(
            id: "physical",
            label: "PHYSICAL/APPEARANCE",
            items: [
                SymptomItem(id: "receded_chin", text: "Receded chin or weak jawline"),
                SymptomItem(id: "mouth_breathing", text: "Mouth breathing habits"),
                SymptomItem(id: "poor_posture", text: "Poor posture awareness"),
                SymptomItem(id: "facial_asymmetry", text: "Uneven facial symmetry"),
                SymptomItem(id: "skin_texture", text: "Skin texture issues")
            ]
        ),
        SymptomGroup(
            id: "functional",
            label: "FUNCTIONAL",
            items: [
                SymptomItem(id: "difficulty_breathing", text: "Difficulty breathing through nose"),
                SymptomItem(id: "jaw_tension", text: "Jaw tension or TMJ issues"),
                SymptomItem(id: "sleep_quality", text: "Sleep quality affected by breathing")
            ]
        )
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "0A0A0F")
                .ignoresSafeArea()
            
            if showGoals {
                GoalsSelectionView(quizData: quizData)
            } else {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 12) {
                        Text("Identify Your Areas")
                            .font(.title.bold())
                            .foregroundColor(.white)
                        
                        Text("Select all that apply to you")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "9CA3AF"))
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            ForEach(symptomGroups) { group in
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(group.label)
                                        .font(.caption.bold())
                                        .foregroundColor(Color(hex: "9CA3AF"))
                                        .tracking(1.5)
                                        .padding(.top, 8)
                                    
                                    ForEach(group.items) { item in
                                        symptomRow(item)
                                    }
                                }
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
                            quizData.selectedSymptoms = Array(selectedSymptoms)
                            quizData.saveToUserDefaults()
                            withAnimation {
                                showGoals = true
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
                        .disabled(selectedSymptoms.isEmpty)
                        .opacity(selectedSymptoms.isEmpty ? 0.5 : 1.0)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                    }
                    .background(Color(hex: "0A0A0F"))
                }
            }
        }
        .onAppear {
            // Load existing selections
            selectedSymptoms = Set(quizData.selectedSymptoms)
        }
    }
    
    private func symptomRow(_ item: SymptomItem) -> some View {
        Button(action: {
            if selectedSymptoms.contains(item.id) {
                selectedSymptoms.remove(item.id)
            } else {
                selectedSymptoms.insert(item.id)
                // Haptic feedback
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                        .frame(width: 26, height: 26)
                    
                    if selectedSymptoms.contains(item.id) {
                        Circle()
                            .fill(Color(hex: "#E11D48"))
                            .frame(width: 26, height: 26)
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                Text(item.text)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
            .scaleEffect(selectedSymptoms.contains(item.id) ? 1.05 : 1.0)
            .animation(.easeOut(duration: 0.15), value: selectedSymptoms.contains(item.id))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SymptomsSelectionView(quizData: OnboardingQuizData())
}
