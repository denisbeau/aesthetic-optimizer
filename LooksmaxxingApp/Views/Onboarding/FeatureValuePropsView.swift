import SwiftUI

struct FeatureValuePropsView: View {
    @Binding var currentScreen: Int
    
    @State private var currentSlide = 0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(hex: "0F172A"),
                    Color(hex: "125E75")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                // Content Carousel
                TabView(selection: $currentSlide) {
                    ForEach(featureValueProps) { prop in
                        FeatureCardView(prop: prop)
                            .tag(prop.id - 1)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Pagination dots
                HStack(spacing: 8) {
                    ForEach(0..<featureValueProps.count, id: \.self) { index in
                        Circle()
                            .fill(currentSlide == index ? Color.white : Color.white.opacity(0.4))
                            .frame(width: currentSlide == index ? 10 : 8, height: currentSlide == index ? 10 : 8)
                            .animation(.easeInOut(duration: 0.2), value: currentSlide)
                    }
                }
                .padding(.bottom, 20)
                
                // Media logos (Trust bar)
                HStack(spacing: 30) {
                    ForEach(["Forbes", "TechCrunch", "Wired"], id: \.self) { logo in
                        Text(logo)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .overlay(
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 1),
                    alignment: .top
                )
                
                // Continue button (appears on last slide)
                if currentSlide == featureValueProps.count - 1 {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentScreen = 19
                        }
                    }) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "0F172A"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.white)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, 24)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
                
                Spacer()
                    .frame(height: 50)
            }
        }
    }
}

// MARK: - Feature Card View
struct FeatureCardView: View {
    let prop: FeatureValueProp
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Icon with glow
            ZStack {
                Circle()
                    .fill(Color(hex: "FFD700").opacity(0.2))
                    .frame(width: 140, height: 140)
                    .blur(radius: 20)
                
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: prop.icon)
                        .font(.system(size: 44))
                        .foregroundColor(.white)
                }
                .shadow(color: Color(hex: "FFD700").opacity(0.5), radius: 20, x: 0, y: 10)
            }
            
            // Title
            Text(prop.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            // Description
            Text(prop.description)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    FeatureValuePropsView(currentScreen: .constant(18))
}
