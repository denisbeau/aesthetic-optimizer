import SwiftUI

struct FreeTrialOfferView: View {
    @Binding var currentScreen: Int
    @ObservedObject var onboardingData: OnboardingData
    var onComplete: () -> Void
    
    @State private var showContent = false
    
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
            
            VStack(spacing: 24) {
                // Close button
                HStack {
                    Spacer()
                    Button(action: {
                        onComplete()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.3))
                            .padding(12)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                Spacer()
                    .frame(height: 10)
                
                // Header
                Text("We want you to try\nAscend for free")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(showContent ? 1 : 0)
                
                // App mockup
                ZStack {
                    // Phone frame
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color(hex: "1A1A2E"))
                        .frame(width: 240, height: 420)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                    
                    // Mockup content
                    VStack(spacing: 16) {
                        // Header area
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Welcome back!")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Day 14 of your journey")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "F43F5E"))
                                    .frame(width: 36, height: 36)
                                Text("14")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Timer
                        VStack(spacing: 4) {
                            Text("14d 4hrs 23m")
                                .font(.system(size: 28, weight: .heavy))
                                .foregroundColor(.white)
                            Text("Transformation streak")
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.vertical, 20)
                        
                        // Action buttons
                        HStack(spacing: 12) {
                            ActionCircle(icon: "hand.raised.fill", label: "Pledge")
                            ActionCircle(icon: "brain.head.profile", label: "Meditate")
                            ActionCircle(icon: "arrow.counterclockwise", label: "Reset")
                            ActionCircle(icon: "ellipsis", label: "More")
                        }
                        
                        // Weekly activity
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Weekly Activity")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.white.opacity(0.6))
                            
                            HStack(spacing: 6) {
                                ForEach(0..<7, id: \.self) { i in
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(i < 5 ? Color(hex: "4ADE80") : Color.white.opacity(0.2))
                                        .frame(width: 20, height: CGFloat.random(in: 20...50))
                                }
                            }
                        }
                    }
                    .padding(24)
                    .frame(width: 220)
                }
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // Safety signal
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "10B981"))
                    
                    Text("No Payment Due Now")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .opacity(showContent ? 1 : 0)
                
                // CTA Button
                Button(action: {
                    onComplete()
                }) {
                    HStack {
                        Text("Try For ")
                            .font(.system(size: 18, weight: .semibold))
                        Text("$0.00")
                            .font(.system(size: 22, weight: .heavy))
                    }
                    .foregroundColor(Color(hex: "081630"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .clipShape(Capsule())
                }
                .padding(.horizontal, 24)
                .opacity(showContent ? 1 : 0)
                
                // Cancel note
                Text("Cancel anytime in Settings")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.4))
                    .opacity(showContent ? 1 : 0)
                
                Spacer()
                    .frame(height: 40)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                showContent = true
            }
        }
    }
}

// MARK: - Action Circle
struct ActionCircle: View {
    let icon: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
            }
            Text(label)
                .font(.system(size: 8))
                .foregroundColor(.white.opacity(0.6))
        }
    }
}

#Preview {
    FreeTrialOfferView(currentScreen: .constant(27), onboardingData: OnboardingData.shared, onComplete: {})
}
