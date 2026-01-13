//
//  OnboardingView.swift
//  LooksmaxxingApp
//
//  Welcome and permissions flow
//  Screen 1: Welcome
//  Screen 2: Camera Permission
//

import SwiftUI
import AVFoundation

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentScreen = 0
    @State private var showPermissionAlert = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                if currentScreen == 0 {
                    WelcomeScreen(onContinue: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentScreen = 1
                        }
                    })
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))
                } else {
                    PermissionsScreen(
                        onAllow: requestCameraPermission,
                        showAlert: $showPermissionAlert
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))
                }
            }
        }
        .alert("Camera Access Required", isPresented: $showPermissionAlert) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Camera access is required to analyze your face. Please enable it in Settings.")
        }
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    hasCompletedOnboarding = true
                } else {
                    showPermissionAlert = true
                }
            }
        }
    }
}

// MARK: - Welcome Screen

struct WelcomeScreen: View {
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Logo/Icon
            Image(systemName: "face.smiling")
                .font(.system(size: 80))
                .foregroundColor(.white)
                .shadow(radius: 10)
            
            // App Name
            VStack(spacing: 10) {
                Text("Aesthetic Optimizer")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("AI Facial Analysis & Self-Improvement")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
            }
            
            // Description
            Text("Get your AI facial analysis in seconds")
                .font(.title3)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            // Features preview
            VStack(alignment: .leading, spacing: 15) {
                FeatureItem(icon: "camera.fill", text: "Instant AI facial analysis")
                FeatureItem(icon: "flame.fill", text: "Daily streaks for motivation")
                FeatureItem(icon: "lock.shield.fill", text: "100% on-device privacy")
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            // Continue button
            Button(action: onContinue) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .cornerRadius(14)
                    .shadow(radius: 5)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
}

// MARK: - Feature Item

struct FeatureItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 30)
            
            Text(text)
                .font(.body)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Permissions Screen

struct PermissionsScreen: View {
    let onAllow: () -> Void
    @Binding var showAlert: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Camera Icon
            Image(systemName: "camera.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.white)
                .shadow(radius: 10)
            
            // Title
            Text("Camera Access Required")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            // Description
            VStack(spacing: 20) {
                Text("We need camera access to analyze your face")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                
                Text("All processing happens on your device (privacy-first)")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                
                Text("Your photos are never uploaded to our servers")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            
            Spacer()
            
            // Privacy badge
            HStack(spacing: 10) {
                Image(systemName: "lock.fill")
                    .font(.caption)
                Text("Privacy-First Processing")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.2))
            .cornerRadius(20)
            
            Spacer()
            
            // Allow button
            Button(action: onAllow) {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("Allow Camera")
                }
                .font(.headline)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.white)
                .cornerRadius(14)
                .shadow(radius: 5)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    OnboardingView()
}
