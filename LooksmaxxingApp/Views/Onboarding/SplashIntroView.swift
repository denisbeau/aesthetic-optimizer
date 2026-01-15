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
    // Pre-computed star positions for consistency
    private let stars: [(x: CGFloat, y: CGFloat, opacity: Double, size: CGFloat)] = {
        var result: [(CGFloat, CGFloat, Double, CGFloat)] = []
        for i in 0..<50 {
            // Use deterministic pseudo-random based on index
            let seed = Double(i)
            let x = CGFloat(((seed * 7919) .truncatingRemainder(dividingBy: 100)) / 100)
            let y = CGFloat(((seed * 104729) .truncatingRemainder(dividingBy: 100)) / 100)
            let opacity = 0.1 + (((seed * 15485863) .truncatingRemainder(dividingBy: 100)) / 100) * 0.3
            let size = 1 + CGFloat(((seed * 32452843) .truncatingRemainder(dividingBy: 100)) / 100) * 2
            result.append((x, y, opacity, size))
        }
        return result
    }()
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<stars.count, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(stars[i].opacity))
                    .frame(width: stars[i].size, height: stars[i].size)
                    .position(
                        x: stars[i].x * geometry.size.width,
                        y: stars[i].y * geometry.size.height
                    )
            }
        }
    }
}

#Preview {
    SplashIntroView(currentScreen: .constant(1))
}
