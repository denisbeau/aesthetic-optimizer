import SwiftUI

struct TestimonialsView: View {
    @Binding var currentScreen: Int
    
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "050914")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("Real transformations")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("From our community")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.top, 60)
                .padding(.bottom, 24)
                .opacity(showContent ? 1 : 0)
                
                // Testimonials scroll
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(testimonials) { testimonial in
                            TestimonialCard(testimonial: testimonial)
                                .opacity(showContent ? 1 : 0)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
            
            // Bottom CTA
            VStack {
                Spacer()
                
                ZStack(alignment: .bottom) {
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
                            currentScreen = 20
                        }
                    }) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "050914"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.white)
                            .clipShape(Capsule())
                    }
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
}

// MARK: - Testimonial Card
struct TestimonialCard: View {
    let testimonial: Testimonial
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 12) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                    
                    Text(String(testimonial.name.prefix(1)))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(testimonial.name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        
                        if testimonial.isVerified {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "10B981"))
                        }
                    }
                    
                    // Stars
                    HStack(spacing: 2) {
                        ForEach(0..<testimonial.rating, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "FACC15"))
                        }
                    }
                }
                
                Spacer()
            }
            
            // Body text
            Text(testimonial.text)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Color(hex: "E5E7EB"))
                .lineSpacing(4)
        }
        .padding(20)
        .background(Color.white.opacity(0.03))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    TestimonialsView(currentScreen: .constant(19))
}
