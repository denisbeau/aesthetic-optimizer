import SwiftUI

struct ProblemCarouselView: View {
    @Binding var currentScreen: Int
    
    @State private var currentSlide = 0
    
    var body: some View {
        ZStack {
            // Background - transitions from red to teal on last slide
            Group {
                if currentSlide < problemSlides.count - 1 {
                    Color(hex: "7F1D1D")
                } else {
                    Color(hex: "125E75")
                }
            }
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.5), value: currentSlide)
            
            VStack {
                // Content
                TabView(selection: $currentSlide) {
                    ForEach(problemSlides) { slide in
                        ProblemSlideView(slide: slide)
                            .tag(slide.id - 1)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Pagination dots
                HStack(spacing: 8) {
                    ForEach(0..<problemSlides.count, id: \.self) { index in
                        Circle()
                            .fill(currentSlide == index ? Color.white : Color.white.opacity(0.4))
                            .frame(width: currentSlide == index ? 10 : 8, height: currentSlide == index ? 10 : 8)
                            .animation(.easeInOut(duration: 0.2), value: currentSlide)
                    }
                }
                .padding(.bottom, 20)
                
                // Continue button (appears on last slide)
                if currentSlide == problemSlides.count - 1 {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentScreen = 18
                        }
                    }) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "125E75"))
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

// MARK: - Problem Slide View
struct ProblemSlideView: View {
    let slide: ProblemSlide
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 120, height: 120)
                
                Image(systemName: slide.icon)
                    .font(.system(size: 48))
                    .foregroundColor(.white)
            }
            
            // Title
            Text(slide.title)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            // Body
            Text(slide.body)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 32)
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    ProblemCarouselView(currentScreen: .constant(17))
}
