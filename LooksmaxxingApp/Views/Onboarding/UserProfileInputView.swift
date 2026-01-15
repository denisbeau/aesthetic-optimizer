import SwiftUI

struct UserProfileInputView: View {
    @Binding var currentScreen: Int
    @ObservedObject var onboardingData: OnboardingData
    
    @State private var showContent = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, age
    }
    
    private var isFormValid: Bool {
        !onboardingData.userName.isEmpty && !onboardingData.userAge.isEmpty
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "050914")
                .ignoresSafeArea()
                .onTapGesture {
                    focusedField = nil
                }
            
            VStack(spacing: 24) {
                Spacer()
                    .frame(height: 80)
                
                // Header
                VStack(spacing: 12) {
                    Text("Finally")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("A little more about you")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                
                Spacer()
                    .frame(height: 40)
                
                // Input Fields
                VStack(spacing: 16) {
                    // Name Input
                    TextField("", text: $onboardingData.userName)
                        .placeholder(when: onboardingData.userName.isEmpty) {
                            Text("Name")
                                .foregroundColor(Color(hex: "A0A0A0"))
                        }
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(18)
                        .background(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(focusedField == .name ? 0.8 : 0.3), lineWidth: 1)
                        )
                        .cornerRadius(15)
                        .focused($focusedField, equals: .name)
                        .textContentType(.name)
                        .autocapitalization(.words)
                    
                    // Age Input
                    TextField("", text: $onboardingData.userAge)
                        .placeholder(when: onboardingData.userAge.isEmpty) {
                            Text("Age")
                                .foregroundColor(Color(hex: "A0A0A0"))
                        }
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(18)
                        .background(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(focusedField == .age ? 0.8 : 0.3), lineWidth: 1)
                        )
                        .cornerRadius(15)
                        .focused($focusedField, equals: .age)
                        .keyboardType(.numberPad)
                }
                .padding(.horizontal, 24)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                
                Spacer()
                
                // Complete Quiz CTA
                Button(action: {
                    focusedField = nil
                    
                    // Calculate score before transitioning
                    onboardingData.calculateScore()
                    
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentScreen = 14
                    }
                }) {
                    Text("Complete Quiz")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "050914"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(isFormValid ? Color.white : Color.white.opacity(0.5))
                        .clipShape(Capsule())
                }
                .disabled(!isFormValid)
                .padding(.horizontal, 24)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                
                Spacer()
                    .frame(height: 50)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                showContent = true
            }
        }
    }
}

// MARK: - Placeholder Extension
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    UserProfileInputView(currentScreen: .constant(13), onboardingData: OnboardingData.shared)
}
