import SwiftUI

struct ContentView: View {
    @StateObject private var onboardingData = OnboardingData.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    // Current screen in the 27-screen flow
    // 1 = Splash, 2 = Welcome, 3-12 = Quiz Q1-Q10, 13 = Profile, 14 = Processing,
    // 15 = Results, 16 = Symptoms, 17 = Problem Carousel, 18 = Features,
    // 19 = Testimonials, 20 = Timeline, 21 = Goals, 22 = Social Proof Grid,
    // 23 = Signature, 24 = Welcome, 25 = Plan Card, 26 = Paywall, 27 = Trial
    @State private var currentScreen: Int = 1
    
    var body: some View {
        Group {
            if hasCompletedOnboarding {
                // Main app
                MainTabView()
            } else {
                // Onboarding flow
                onboardingFlow
            }
        }
    }
    
    @ViewBuilder
    private var onboardingFlow: some View {
        switch currentScreen {
        case 1:
            SplashIntroView(currentScreen: $currentScreen)
        case 2:
            WelcomeIntentView(currentScreen: $currentScreen)
        case 3...12:
            QuizView(currentScreen: $currentScreen, onboardingData: onboardingData)
        case 13:
            UserProfileInputView(currentScreen: $currentScreen, onboardingData: onboardingData)
        case 14:
            LaborIllusionView(currentScreen: $currentScreen, onboardingData: onboardingData)
        case 15:
            ResultsDashboardView(currentScreen: $currentScreen, onboardingData: onboardingData)
        case 16:
            SymptomChecklistView(currentScreen: $currentScreen, onboardingData: onboardingData)
        case 17:
            ProblemCarouselView(currentScreen: $currentScreen)
        case 18:
            FeatureValuePropsView(currentScreen: $currentScreen)
        case 19:
            TestimonialsView(currentScreen: $currentScreen)
        case 20:
            ProgressTimelineView(currentScreen: $currentScreen)
        case 21:
            GoalSelectionView(currentScreen: $currentScreen, onboardingData: onboardingData)
        case 22:
            SocialProofGridView(currentScreen: $currentScreen)
        case 23:
            CommitmentSignatureView(currentScreen: $currentScreen, onboardingData: onboardingData)
        case 24:
            PersonalizedWelcomeView(currentScreen: $currentScreen, onboardingData: onboardingData)
        case 25:
            PlanPreviewCardView(currentScreen: $currentScreen, onboardingData: onboardingData)
        case 26:
            PersonalizedPaywallView(currentScreen: $currentScreen, onboardingData: onboardingData)
        case 27:
            FreeTrialOfferView(currentScreen: $currentScreen, onboardingData: onboardingData) {
                completeOnboarding()
            }
        default:
            SplashIntroView(currentScreen: $currentScreen)
        }
    }
    
    private func completeOnboarding() {
        hasCompletedOnboarding = true
    }
}

// MARK: - Main Tab View (Post-Onboarding)
struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeViewDark()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            CameraView()
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Scan")
                }
                .tag(1)
            
            DailyRoutineView()
                .tabItem {
                    Image(systemName: "checklist")
                    Text("Routine")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(Color(hex: "4ADE80"))
    }
}

#Preview {
    ContentView()
}
