import SwiftUI

struct CommitmentSignatureView: View {
    @Binding var currentScreen: Int
    @ObservedObject var onboardingData: OnboardingData
    
    @State private var showContent = false
    @State private var lines: [[CGPoint]] = [[]]
    @State private var hasSignature = false
    @State private var totalStrokeLength: CGFloat = 0
    
    private let minimumStrokeLength: CGFloat = 50
    
    private var isValidSignature: Bool {
        totalStrokeLength >= minimumStrokeLength
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "050914")
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                    .frame(height: 60)
                
                // Header
                VStack(spacing: 12) {
                    Text("Sign your commitment")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Promise yourself that you will commit\nto your transformation journey")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                    .frame(height: 30)
                
                // Signature Canvas
                ZStack {
                    // White canvas with subtle shadow
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .frame(height: 180)
                        .shadow(color: .black.opacity(0.4), radius: 25, x: 0, y: 12)
                    
                    // Drawing canvas with Bezier smoothing
                    Canvas { context, size in
                        for line in lines {
                            if line.count > 1 {
                                var path = Path()
                                path.move(to: line[0])
                                
                                if line.count == 2 {
                                    path.addLine(to: line[1])
                                } else {
                                    // Bezier smoothing for smoother strokes
                                    for i in 1..<line.count {
                                        let mid = CGPoint(
                                            x: (line[i-1].x + line[i].x) / 2,
                                            y: (line[i-1].y + line[i].y) / 2
                                        )
                                        path.addQuadCurve(to: mid, control: line[i-1])
                                    }
                                    path.addLine(to: line.last!)
                                }
                                
                                context.stroke(
                                    path,
                                    with: .color(.black),
                                    style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
                                )
                            }
                        }
                    }
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let point = value.location
                                
                                // Calculate stroke length
                                if let lastPoint = lines.last?.last {
                                    let dx = point.x - lastPoint.x
                                    let dy = point.y - lastPoint.y
                                    totalStrokeLength += sqrt(dx*dx + dy*dy)
                                }
                                
                                lines[lines.count - 1].append(point)
                                hasSignature = true
                            }
                            .onEnded { _ in
                                lines.append([])
                                // Haptic on stroke end
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                            }
                    )
                    
                    // Placeholder text
                    if !hasSignature {
                        VStack(spacing: 8) {
                            Image(systemName: "signature")
                                .font(.system(size: 32))
                                .foregroundColor(.gray.opacity(0.3))
                            Text("Draw your signature here")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray.opacity(0.5))
                        }
                    }
                    
                    // Signature line
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 1)
                            .padding(.horizontal, 40)
                            .padding(.bottom, 40)
                    }
                    .frame(height: 180)
                }
                .padding(.horizontal, 24)
                .opacity(showContent ? 1 : 0)
                
                // Clear button
                Button(action: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        lines = [[]]
                        hasSignature = false
                        totalStrokeLength = 0
                    }
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 12, weight: .medium))
                        Text("Clear")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Capsule())
                }
                .opacity(hasSignature && showContent ? 1 : 0)
                
                // Validation hint
                if hasSignature && !isValidSignature {
                    Text("Keep signing...")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "FACC15"))
                        .opacity(showContent ? 1 : 0)
                } else {
                    Text("Draw on the open space above")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                        .opacity(showContent && !hasSignature ? 1 : 0)
                }
                
                Spacer()
                
                // Continue button
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    onboardingData.hasSignedCommitment = true
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentScreen = 24
                    }
                }) {
                    Text("I Commit")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "050914"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(isValidSignature ? Color.white : Color.white.opacity(0.5))
                        .clipShape(Capsule())
                }
                .disabled(!isValidSignature)
                .padding(.horizontal, 24)
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                    .frame(height: 50)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                showContent = true
            }
        }
    }
}

#Preview {
    CommitmentSignatureView(currentScreen: .constant(23), onboardingData: OnboardingData.shared)
}
