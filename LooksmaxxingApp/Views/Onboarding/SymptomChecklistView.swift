import SwiftUI

struct SymptomChecklistView: View {
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
                    Text("Select your symptoms")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Tap all that apply to you")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.top, 60)
                .padding(.bottom, 24)
                .opacity(showContent ? 1 : 0)
                
                // Symptom List
                ScrollView {
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                        ForEach(SymptomCategory.allCases, id: \.self) { category in
                            Section {
                                ForEach(symptoms.filter { $0.category == category }) { symptom in
                                    SymptomRow(
                                        text: symptom.text,
                                        isSelected: onboardingData.selectedSymptoms.contains(symptom.id),
                                        action: {
                                            toggleSymptom(symptom.id)
                                        }
                                    )
                                }
                            } header: {
                                Text(category.rawValue.uppercased())
                                    .font(.system(size: 12, weight: .semibold))
                                    .tracking(1)
                                    .foregroundColor(Color(hex: "9CA3AF"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 20)
                                    .padding(.bottom, 8)
                                    .padding(.horizontal, 20)
                                    .background(Color(hex: "050914"))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
                .opacity(showContent ? 1 : 0)
            }
            
            // Bottom CTA with gradient fade
            VStack {
                Spacer()
                
                ZStack(alignment: .bottom) {
                    // Gradient fade
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
                            currentScreen = 17
                        }
                    }) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "050914"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(onboardingData.selectedSymptoms.isEmpty ? Color.white.opacity(0.5) : Color.white)
                            .clipShape(Capsule())
                    }
                    .disabled(onboardingData.selectedSymptoms.isEmpty)
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
    
    private func toggleSymptom(_ id: String) {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        if onboardingData.selectedSymptoms.contains(id) {
            onboardingData.selectedSymptoms.remove(id)
        } else {
            onboardingData.selectedSymptoms.insert(id)
        }
    }
}

// MARK: - Symptom Row Component
struct SymptomRow: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Checkbox
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                        .frame(width: 26, height: 26)
                    
                    if isSelected {
                        Circle()
                            .fill(Color(hex: "E11D48"))
                            .frame(width: 26, height: 26)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
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
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SymptomChecklistView(currentScreen: .constant(16), onboardingData: OnboardingData.shared)
}
