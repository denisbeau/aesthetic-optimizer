import SwiftUI

struct PersonalizedWelcomeView: View {
    @Binding var currentScreen: Int
    @ObservedObject var onboardingData: OnboardingData
    
    @State private var showContent = false
    
    private var displayName: String {
        onboardingData.userName.isEmpty ? "Friend" : onboardingData.userName.capitalized
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(hex: "081630"),
                    Color(hex: "050914")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            StarFieldView()
            
            VStack(alignment: .leading, spacing: 12) {
                Spacer()
                
                // Personalized greeting
                Text("Hey \(displayName),")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 10)
                
                // Welcome message
                HStack(spacing: 0) {
                    Text("Welcome to ")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text("ASCEND")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .underline()
                    
                    Text(",")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.white)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 10)
                
                Text("your path to transformation.")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 10)
                
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)
            .padding(.top, 120)
        }
        .onAppear {
            // Entrance animation
            withAnimation(.easeOut(duration: 0.6)) {
                showContent = true
            }
            
            // Auto-transition after 1.8 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    currentScreen = 25
                }
            }
        }
    }
}

#Preview {
    let data = OnboardingData.shared
    data.userName = "Marcus"
    return PersonalizedWelcomeView(currentScreen: .constant(24), onboardingData: data)
}
