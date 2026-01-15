import SwiftUI

struct SplashIntroView: View {
    @Binding var currentScreen: Int
    
    @State private var showLine1 = false
    @State private var showLine2 = false
    @State private var showRating = false
    
    var body: some View {
        ZStack {
            // Background gradient
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
            
            // Star field overlay
            StarFieldView()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Logo
                Text("ASCEND")
                    .font(.system(size: 42, weight: .heavy, design: .default))
                    .tracking(6)
                    .foregroundColor(.white)
                
                // Caption Line 1
                Text("Embrace this pause.")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .opacity(showLine1 ? 1 : 0)
                    .offset(y: showLine1 ? 0 : 10)
                
                // Caption Line 2
                Text("Face your potential")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .opacity(showLine2 ? 1 : 0)
                    .offset(y: showLine2 ? 0 : 10)
                
                Spacer()
                
                // 5-star rating
                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(Color(hex: "FFD700"))
                            .font(.system(size: 14))
                    }
                }
                .opacity(showRating ? 1 : 0)
                
                Text("Trusted by 12,000+ users")
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(.white.opacity(0.6))
                    .opacity(showRating ? 1 : 0)
                
                Spacer()
                    .frame(height: 60)
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            // Staggered entrance animation
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                showLine1 = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.8)) {
                showLine2 = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(1.4)) {
                showRating = true
            }
            
            // Auto-transition after 2.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentScreen = 2
                }
            }
        }
    }
}

// MARK: - Star Field Background
struct StarFieldView: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<50, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(Double.random(in: 0.1...0.4)))
                    .frame(width: CGFloat.random(in: 1...3))
                    .position(
                        x: CGFloat.random(in: 0...geometry.size.width),
                        y: CGFloat.random(in: 0...geometry.size.height)
                    )
            }
        }
    }
}

#Preview {
    SplashIntroView(currentScreen: .constant(1))
}
