//
//  CelebrationView.swift
//  LooksmaxxingApp
//
//  Confetti and celebration animations for milestones
//

import SwiftUI

struct CelebrationView: View {
    let message: String
    let emoji: String
    @Binding var isShowing: Bool
    
    @State private var particles: [Particle] = []
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }
            
            // Confetti particles
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
            
            // Celebration card
            VStack(spacing: 20) {
                Text(emoji)
                    .font(.system(size: 80))
                    .scaleEffect(scale)
                
                Text(message)
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Button(action: dismiss) {
                    Text("Awesome!")
                        .font(.headline.bold())
                        .foregroundColor(.black)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                        .background(Color(hex: "00D4FF"))
                        .cornerRadius(25)
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(hex: "12121A"))
            )
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            startAnimation()
            triggerHaptic()
        }
    }
    
    private func startAnimation() {
        // Generate confetti particles
        for _ in 0..<50 {
            particles.append(Particle())
        }
        
        // Animate card appearance
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            scale = 1.0
            opacity = 1.0
        }
        
        // Animate confetti
        animateConfetti()
    }
    
    private func animateConfetti() {
        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { timer in
            for i in particles.indices {
                particles[i].position.y += particles[i].velocity
                particles[i].position.x += sin(particles[i].position.y / 30) * 2
                particles[i].opacity -= 0.01
                
                if particles[i].opacity <= 0 {
                    particles[i] = Particle()
                    particles[i].position.y = -20
                }
            }
        }
    }
    
    private func triggerHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Additional impact for milestone
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.impactOccurred()
        }
    }
    
    private func dismiss() {
        withAnimation(.easeOut(duration: 0.3)) {
            opacity = 0
            scale = 0.8
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isShowing = false
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGFloat
    var size: CGFloat
    var color: Color
    var opacity: Double
    
    init() {
        self.position = CGPoint(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: CGFloat.random(in: -50...0)
        )
        self.velocity = CGFloat.random(in: 3...8)
        self.size = CGFloat.random(in: 6...12)
        self.color = [
            Color(hex: "00D4FF"),
            Color(hex: "F59E0B"),
            Color(hex: "10B981"),
            Color(hex: "EF4444"),
            Color(hex: "8B5CF6")
        ].randomElement()!
        self.opacity = 1.0
    }
}

// MARK: - Celebration Manager

class CelebrationManager: ObservableObject {
    static let shared = CelebrationManager()
    
    @Published var isShowing = false
    @Published var message = ""
    @Published var emoji = ""
    
    func celebrate(for milestone: Milestone) {
        switch milestone {
        case .streak7:
            message = "One Week Streak!"
            emoji = "🔥"
        case .streak30:
            message = "30 Day Champion!"
            emoji = "👑"
        case .streak100:
            message = "100 Day Legend!"
            emoji = "🏆"
        case .firstScan:
            message = "First Scan Complete!"
            emoji = "📸"
        case .score8:
            message = "You Hit 8.0!"
            emoji = "⭐"
        case .perfectWeek:
            message = "Perfect Week!"
            emoji = "💪"
        }
        
        isShowing = true
    }
    
    enum Milestone {
        case streak7, streak30, streak100
        case firstScan, score8, perfectWeek
    }
}

#Preview {
    CelebrationView(
        message: "One Week Streak!",
        emoji: "🔥",
        isShowing: .constant(true)
    )
}
