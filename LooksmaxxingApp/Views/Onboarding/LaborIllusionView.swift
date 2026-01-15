import SwiftUI

struct LaborIllusionView: View {
    @Binding var currentScreen: Int
    @ObservedObject var onboardingData: OnboardingData
    
    @State private var progress: Double = 0
    @State private var statusText: String = "Analyzing patterns..."
    @State private var showPercentage = false
    
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
            
            StarFieldView()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Header
                Text("Calculating")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                // Circular Progress
                ZStack {
                    // Track
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 4)
                        .frame(width: 180, height: 180)
                    
                    // Progress Arc
                    Circle()
                        .trim(from: 0, to: progress / 100)
                        .stroke(
                            Color(hex: "4ADE80"),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 180, height: 180)
                        .rotationEffect(.degrees(-90))
                        .shadow(color: Color(hex: "4ADE80").opacity(0.8), radius: 8, x: 0, y: 0)
                    
                    // Percentage
                    Text("\(Int(progress))%")
                        .font(.system(size: 48, weight: .heavy))
                        .foregroundColor(.white)
                        .opacity(showPercentage ? 1 : 0)
                }
                
                // Status Text
                Text(statusText)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .animation(.easeInOut(duration: 0.3), value: statusText)
                
                Spacer()
                
                // Processing indicator
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(Color.white.opacity(0.5))
                            .frame(width: 8, height: 8)
                            .scaleEffect(progress > Double(i * 30) ? 1.2 : 0.8)
                            .animation(.easeInOut(duration: 0.5).repeatForever(), value: progress)
                    }
                }
                
                Spacer()
                    .frame(height: 80)
            }
        }
        .onAppear {
            showPercentage = true
            simulateProgress()
        }
    }
    
    private func simulateProgress() {
        // Variable velocity progress simulation
        // 0-25%: Fast (0.8s)
        // 25-65%: Slow (2.5s) - "Heavy lifting"
        // 65-100%: Fast again (1.2s)
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            var increment: Double = 0
            
            if progress < 25 {
                increment = Double.random(in: 1.5...3.0)
            } else if progress < 65 {
                increment = Double.random(in: 0.3...0.8)
            } else {
                increment = Double.random(in: 2.0...4.0)
            }
            
            progress = min(progress + increment, 100)
            
            // Update status text
            if progress >= 5 && progress < 35 {
                statusText = "Analyzing patterns..."
            } else if progress >= 35 && progress < 70 {
                statusText = "Processing your responses..."
            } else if progress >= 70 && progress < 95 {
                statusText = "Comparing to 50,000+ data points..."
            } else if progress >= 95 {
                statusText = "Finalizing analysis..."
            }
            
            if progress >= 100 {
                timer.invalidate()
                
                // Short pause at 100%
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentScreen = 15
                    }
                }
            }
        }
    }
}

#Preview {
    LaborIllusionView(currentScreen: .constant(14), onboardingData: OnboardingData.shared)
}
