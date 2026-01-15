import SwiftUI

struct WelcomeIntentView: View {
    @Binding var currentScreen: Int
    
    @State private var showHeader = false
    @State private var showSubheader = false
    @State private var showRating = false
    @State private var showButton = false
    
    var body: some View {
        ZStack {
            // Background gradient (continuous from splash)
            LinearGradient(
                colors: [
                    Color(hex: "125E75"),
                    Color(hex: "081630"),
                    Color(hex: "040712")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            StarFieldView()
            
            VStack(spacing: 20) {
                Spacer()
                
                // Header
                Text("Welcome!")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(showHeader ? 1 : 0)
                    .offset(y: showHeader ? 0 : 15)
                
                // Subheader
                Text("Let's find out if you're maximizing your facial potential")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .opacity(showSubheader ? 1 : 0)
                    .offset(y: showSubheader ? 0 : 10)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                // Social proof
                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(Color(hex: "FFD700"))
                            .font(.system(size: 14))
                    }
                }
                .opacity(showRating ? 1 : 0)
                
                Text("12,000+ transformations")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .opacity(showRating ? 1 : 0)
                
                Spacer()
                    .frame(height: 40)
                
                // Start Quiz CTA
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentScreen = 3
                    }
                }) {
                    HStack {
                        Text("Start Quiz")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 32, height: 32)
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .foregroundColor(Color(hex: "081630"))
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 4)
                }
                .padding(.horizontal, 32)
                .opacity(showButton ? 1 : 0)
                .offset(y: showButton ? 0 : 20)
                .scaleButtonStyle()
                
                Spacer()
                    .frame(height: 50)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                showHeader = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.15)) {
                showSubheader = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                showRating = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.45)) {
                showButton = true
            }
        }
    }
}

#Preview {
    WelcomeIntentView(currentScreen: .constant(2))
}
