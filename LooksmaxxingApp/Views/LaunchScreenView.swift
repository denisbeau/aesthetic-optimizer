//
//  LaunchScreenView.swift
//  LooksmaxxingApp
//
//  App launch screen with animated logo
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var isAnimating = false
    @State private var opacity = 1.0
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "0A0A0F")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Logo icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "00D4FF").opacity(0.3), Color(hex: "00D4FF").opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                    
                    Image(systemName: "face.smiling")
                        .font(.system(size: 50))
                        .foregroundColor(Color(hex: "00D4FF"))
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                }
                
                // App name
                VStack(spacing: 4) {
                    Text("AESTHETIC")
                        .font(.caption.bold())
                        .foregroundColor(Color(hex: "00D4FF"))
                        .tracking(4)
                    
                    Text("Optimizer")
                        .font(.title.bold())
                        .foregroundColor(.white)
                }
            }
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
