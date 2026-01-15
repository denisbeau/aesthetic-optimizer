import SwiftUI

struct PlanPreviewCardView: View {
    @Binding var currentScreen: Int
    @ObservedObject var onboardingData: OnboardingData
    
    @State private var showCard = false
    @State private var cardOffset: CGFloat = 100
    @State private var glintOffset: CGFloat = -200
    @State private var floatOffset: CGFloat = 0
    @State private var cardRotation: Double = 0
    
    private var displayName: String {
        onboardingData.userName.isEmpty ? "Member" : onboardingData.userName.uppercased()
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
            
            VStack(spacing: 24) {
                Spacer()
                    .frame(height: 60)
                
                // Header
                Text("Based on your answers...")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .opacity(showCard ? 1 : 0)
                
                Text("Your personalized plan")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(showCard ? 1 : 0)
                
                Spacer()
                    .frame(height: 20)
                
                // Virtual ID Card
                ZStack {
                    // Card background with mesh gradient
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "F43F5E"),
                                    Color(hex: "FB923C"),
                                    Color(hex: "4F46E5")
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 340, height: 210)
                        .overlay(
                            // Noise texture
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.black.opacity(0.1))
                        )
                    
                    // Glint effect
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0),
                                    Color.white.opacity(0.2),
                                    Color.white.opacity(0)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 100, height: 210)
                        .offset(x: glintOffset)
                        .mask(
                            RoundedRectangle(cornerRadius: 24)
                                .frame(width: 340, height: 210)
                        )
                    
                    // Card content
                    VStack(alignment: .leading, spacing: 0) {
                        // Top row - Logos
                        HStack {
                            // QTR Brand Mark
                            ZStack {
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 36, height: 36)
                                
                                Text("A")
                                    .font(.system(size: 16, weight: .heavy))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            // Profile icon
                            Image(systemName: "person.crop.rectangle")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Middle - Streak
                        VStack(alignment: .leading, spacing: 2) {
                            Text("ACTIVE STREAK")
                                .font(.system(size: 10, weight: .semibold))
                                .tracking(1)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("0 days")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Bottom row - User info
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("NAME")
                                    .font(.system(size: 9, weight: .semibold))
                                    .tracking(1)
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(displayName)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("STARTED")
                                    .font(.system(size: 9, weight: .semibold))
                                    .tracking(1)
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(onboardingData.todayFormatted)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(24)
                    .frame(width: 340, height: 210)
                }
                .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 15 + floatOffset/2)
                .offset(y: cardOffset + floatOffset)
                .rotation3DEffect(.degrees(cardRotation), axis: (x: 1, y: 0, z: 0))
                .opacity(showCard ? 1 : 0)
                
                Spacer()
            }
        }
        .onAppear {
            // Card entrance with spring
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showCard = true
                cardOffset = 0
            }
            
            // Glint animation
            withAnimation(.easeInOut(duration: 1.5).delay(0.5)) {
                glintOffset = 200
            }
            
            // Start floating animation after entrance
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    floatOffset = -8 // ±8px float (slightly more than spec for visibility)
                }
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    cardRotation = 1.5 // Subtle 3D tilt
                }
            }
            
            // Repeat glint every 2.5 seconds
            Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
                glintOffset = -200
                withAnimation(.easeInOut(duration: 1.5)) {
                    glintOffset = 200
                }
            }
            
            // Auto-transition after 2.5 seconds (slightly longer to enjoy the card)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    currentScreen = 26
                }
            }
        }
    }
}

#Preview {
    let data = OnboardingData.shared
    data.userName = "Marcus"
    return PlanPreviewCardView(currentScreen: .constant(25), onboardingData: data)
}
