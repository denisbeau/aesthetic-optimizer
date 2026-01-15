import SwiftUI

struct ProgressTimelineView: View {
    @Binding var currentScreen: Int
    
    @State private var showContent = false
    @State private var animateGraph = false
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "050914")
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                    .frame(height: 60)
                
                // Header
                VStack(spacing: 8) {
                    Text("Rewiring Benefits")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Your transformation journey")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                    .frame(height: 20)
                
                // Graph
                ZStack {
                    // Grid lines
                    VStack(spacing: 40) {
                        ForEach(0..<4, id: \.self) { _ in
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 1)
                        }
                    }
                    .frame(height: 160)
                    
                    // The "Old Way" spiky line
                    GeometryReader { geometry in
                        Path { path in
                            let width = geometry.size.width
                            let height: CGFloat = 160
                            
                            path.move(to: CGPoint(x: 0, y: height * 0.5))
                            path.addLine(to: CGPoint(x: width * 0.15, y: height * 0.3))
                            path.addLine(to: CGPoint(x: width * 0.25, y: height * 0.7))
                            path.addLine(to: CGPoint(x: width * 0.4, y: height * 0.2))
                            path.addLine(to: CGPoint(x: width * 0.55, y: height * 0.8))
                            path.addLine(to: CGPoint(x: width * 0.7, y: height * 0.35))
                            path.addLine(to: CGPoint(x: width * 0.85, y: height * 0.75))
                            path.addLine(to: CGPoint(x: width, y: height * 0.6))
                        }
                        .trim(from: 0, to: animateGraph ? 1 : 0)
                        .stroke(Color(hex: "F13644"), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    }
                    .frame(height: 160)
                    
                    // The "Ascend Way" smooth curve
                    GeometryReader { geometry in
                        Path { path in
                            let width = geometry.size.width
                            let height: CGFloat = 160
                            
                            path.move(to: CGPoint(x: 0, y: height * 0.85))
                            path.addCurve(
                                to: CGPoint(x: width, y: height * 0.1),
                                control1: CGPoint(x: width * 0.3, y: height * 0.8),
                                control2: CGPoint(x: width * 0.6, y: height * 0.15)
                            )
                        }
                        .trim(from: 0, to: animateGraph ? 1 : 0)
                        .stroke(Color(hex: "4ADE80"), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .shadow(color: Color(hex: "4ADE80").opacity(0.5), radius: 8, x: 0, y: 0)
                    }
                    .frame(height: 160)
                }
                .padding(.horizontal, 24)
                .opacity(showContent ? 1 : 0)
                
                // X-axis labels
                HStack {
                    Text("Week 1")
                    Spacer()
                    Text("Week 2")
                    Spacer()
                    Text("Week 3")
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(hex: "9CA3AF"))
                .padding(.horizontal, 32)
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                    .frame(height: 20)
                
                // Legend
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color(hex: "F13644"))
                            .frame(width: 10, height: 10)
                        Text("Same bullshit cycle")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                    }
                    
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color(hex: "4ADE80"))
                            .frame(width: 10, height: 10)
                        Text("With Ascend")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                    }
                }
                .padding(.horizontal, 32)
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                    .frame(height: 20)
                
                // Stat callout
                HStack(spacing: 8) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundColor(Color(hex: "4ADE80"))
                    Text("Ascend helps you transform 76% faster than going alone")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 24)
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // CTA
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentScreen = 21
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
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                    .frame(height: 50)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                showContent = true
            }
            
            withAnimation(.easeInOut(duration: 1.5).delay(0.5)) {
                animateGraph = true
            }
        }
    }
}

#Preview {
    ProgressTimelineView(currentScreen: .constant(20))
}
