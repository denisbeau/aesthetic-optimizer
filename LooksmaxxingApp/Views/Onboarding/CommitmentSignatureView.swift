import SwiftUI

struct CommitmentSignatureView: View {
    @Binding var currentScreen: Int
    @ObservedObject var onboardingData: OnboardingData
    
    @State private var showContent = false
    @State private var lines: [[CGPoint]] = [[]]
    @State private var hasSignature = false
    
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
                    // White canvas
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .frame(height: 180)
                        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                    
                    // Drawing canvas
                    Canvas { context, size in
                        for line in lines {
                            var path = Path()
                            if let firstPoint = line.first {
                                path.move(to: firstPoint)
                                for point in line.dropFirst() {
                                    path.addLine(to: point)
                                }
                            }
                            context.stroke(path, with: .color(.black), lineWidth: 4)
                        }
                    }
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let point = value.location
                                if lines.last?.isEmpty ?? true {
                                    lines[lines.count - 1].append(point)
                                } else {
                                    lines[lines.count - 1].append(point)
                                }
                                hasSignature = true
                            }
                            .onEnded { _ in
                                lines.append([])
                            }
                    )
                    
                    // Placeholder text
                    if !hasSignature {
                        Text("Draw your signature here")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray.opacity(0.5))
                    }
                }
                .padding(.horizontal, 24)
                .opacity(showContent ? 1 : 0)
                
                // Clear button
                Button(action: {
                    lines = [[]]
                    hasSignature = false
                }) {
                    Text("Clear")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                .opacity(hasSignature && showContent ? 1 : 0)
                
                // Instruction
                Text("Draw on the open space above")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
                    .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // Continue button
                Button(action: {
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
                        .background(hasSignature ? Color.white : Color.white.opacity(0.5))
                        .clipShape(Capsule())
                }
                .disabled(!hasSignature)
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
