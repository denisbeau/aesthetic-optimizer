import SwiftUI

struct ResultsDashboardView: View {
    @Binding var currentScreen: Int
    @ObservedObject var onboardingData: OnboardingData
    @ObservedObject private var remoteConfig = RemoteConfigService.shared
    
    @State private var showContent = false
    @State private var averageBarHeight: CGFloat = 0
    @State private var userBarHeight: CGFloat = 0
    @State private var showAnalysis = false
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "050914")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Spacer()
                        .frame(height: 60)
                    
                    // Status Header
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(hex: "10B981"))
                        Text("Analysis Complete")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "10B981"))
                    }
                    .opacity(showContent ? 1 : 0)
                    
                    // Main Headline
                    VStack(spacing: 8) {
                        Text("We've got some news")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("to break to you...")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .opacity(showContent ? 1 : 0)
                    
                    // Analysis Statement (A/B tested via Remote Config)
                    Text(remoteConfig.getResultsSubheadline())
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .opacity(showAnalysis ? 1 : 0)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Bar Chart
                    HStack(alignment: .bottom, spacing: 50) {
                        // Average Bar
                        VStack(spacing: 8) {
                            Text("\(onboardingData.averageScore)%")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(hex: "2DD4BF"))
                                .frame(width: 80, height: averageBarHeight)
                            
                            Text("Average")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        
                        // User Bar
                        VStack(spacing: 8) {
                            Text("\(onboardingData.userScore)%")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(hex: "F13644"))
                                .frame(width: 80, height: userBarHeight)
                            
                            Text("Your Score")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(height: 280)
                    .padding(.horizontal, 40)
                    
                    // Gap Callout (A/B tested via Remote Config)
                    Text(remoteConfig.getResultsGapCallout(scoreDifference: onboardingData.scoreDifference))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "F13644"))
                        .opacity(showAnalysis ? 1 : 0)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    // CTA Button (A/B tested via Remote Config)
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentScreen = 16
                        }
                    }) {
                        Text(remoteConfig.getString(for: .resultsCTA, fallback: "Check your symptoms"))
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "0F172A"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color(hex: "F3F4F6"))
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, 24)
                    .opacity(showAnalysis ? 1 : 0)
                    
                    // Disclaimer
                    Text("*Based on self-reported responses. Not a clinical diagnosis.")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.white.opacity(0.4))
                        .padding(.top, 8)
                    
                    Spacer()
                        .frame(height: 40)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                showContent = true
            }
            
            // Staggered bar growth animation
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                averageBarHeight = 60
            }
            
            withAnimation(.easeOut(duration: 1.2).delay(0.5)) {
                userBarHeight = CGFloat(onboardingData.userScore) * 2.5
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showAnalysis = true
                }
            }
        }
    }
}

#Preview {
    let data = OnboardingData.shared
    data.userScore = 52
    return ResultsDashboardView(currentScreen: .constant(15), onboardingData: data)
}
