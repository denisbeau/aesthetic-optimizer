import SwiftUI

struct SocialProofGridView: View {
    @Binding var currentScreen: Int
    
    @State private var showContent = false
    
    // Extra testimonials for the grid
    private let gridTestimonials: [Testimonial] = [
        Testimonial(name: "Michael S.", handle: "@michaels", text: "ASCEND has been a lifesaver. The progress tracking kept me on track."),
        Testimonial(name: "Tony C.", handle: "@tcoleman", text: "The daily routine feature helped me resist giving up multiple times."),
        Testimonial(name: "David L.", handle: "@davidlee", text: "The AI analysis is incredibly accurate. Real results."),
        Testimonial(name: "Sarah J.", handle: "@sarah_j", text: "My confidence has improved dramatically."),
        Testimonial(name: "Mark P.", handle: "@markp", text: "Solid app. No-nonsense approach that works."),
        Testimonial(name: "James K.", handle: "@jamesk", text: "Finally focused on science rather than just hoping.")
    ]
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "050914")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("Give us a rating")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<5, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(hex: "FACC15"))
                                .font(.system(size: 16))
                        }
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 24)
                .opacity(showContent ? 1 : 0)
                
                // Grid scroll
                ScrollView {
                    // Hero review
                    HeroReviewCard()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)
                    
                    // 2-column grid
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ], spacing: 12) {
                        ForEach(gridTestimonials) { testimonial in
                            MiniTestimonialCard(testimonial: testimonial)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
                .opacity(showContent ? 1 : 0)
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
                            currentScreen = 23
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

// MARK: - Hero Review Card
struct HeroReviewCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 50, height: 50)
                    Text("M")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Michael Stevens")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(hex: "10B981"))
                            .font(.system(size: 14))
                    }
                    HStack(spacing: 2) {
                        ForEach(0..<5, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "FACC15"))
                        }
                    }
                }
                Spacer()
            }
            
            Text("ASCEND has been a lifesaver for me. The progress tracking and motivational notifications have kept me on track. I've seen real improvements in my jawline and overall confidence. Highly recommend to anyone serious about their transformation.")
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "E5E7EB"))
                .lineSpacing(4)
        }
        .padding(20)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Mini Testimonial Card
struct MiniTestimonialCard: View {
    let testimonial: Testimonial
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 32, height: 32)
                    Text(String(testimonial.name.prefix(1)))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(testimonial.name)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                        if testimonial.isVerified {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(hex: "10B981"))
                                .font(.system(size: 10))
                        }
                    }
                    HStack(spacing: 1) {
                        ForEach(0..<testimonial.rating, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.system(size: 8))
                                .foregroundColor(Color(hex: "FACC15"))
                        }
                    }
                }
            }
            
            Text(testimonial.text)
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "D1D5DB"))
                .lineSpacing(2)
                .lineLimit(4)
        }
        .padding(14)
        .background(Color.white.opacity(0.03))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

#Preview {
    SocialProofGridView(currentScreen: .constant(22))
}
