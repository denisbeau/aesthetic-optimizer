//
//  CommitmentSignatureView.swift
//  LooksmaxxingApp
//
//  Signature commitment screen using PencilKit
//  Adapted from Quittr's onboarding flow
//

import SwiftUI
import PencilKit

struct CommitmentSignatureView: View {
    @ObservedObject var quizData: OnboardingQuizData
    @State private var canvasView = PKCanvasView()
    @State private var hasValidSignature = false
    @State private var showPlanCard = false
    
    var body: some View {
        ZStack {
            Color(hex: "0A0A0F")
                .ignoresSafeArea()
            
            if showPlanCard {
                PlanPreviewCardView(quizData: quizData)
            } else {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Sign your commitment")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Finally, promise yourself that you will commit to your transformation plan")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "9CA3AF"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .padding(.top, 20)
                    
                    // Signature canvas
                    signatureCanvas
                    
                    // Clear button
                    HStack {
                        Button(action: {
                            canvasView.drawing = PKDrawing()
                            hasValidSignature = false
                        }) {
                            Text("Clear")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    // Continue button
                    continueButton
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                }
            }
        }
    }
    
    private var signatureCanvas: some View {
        ZStack {
            // White canvas background
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(height: 200)
                .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 4)
            
            // PencilKit canvas
            CanvasView(canvasView: $canvasView, onStrokeEnd: { hasStroke in
                hasValidSignature = hasStroke
            })
            .frame(height: 200)
            .cornerRadius(12)
            
            // Instruction text
            if !hasValidSignature {
                Text("Draw on the open space above")
                    .font(.caption)
                    .foregroundColor(Color(hex: "9CA3AF"))
                    .offset(y: 100)
            }
        }
        .padding(.horizontal, 24)
    }
    
    private var continueButton: some View {
        Button(action: {
            // Save signature
            let image = canvasView.drawing.image(from: canvasView.bounds, scale: 2.0)
            if let data = image.pngData() {
                quizData.commitmentSignature = data
                quizData.saveToUserDefaults()
            }
            
            withAnimation(.easeOut(duration: 0.3)) {
                showPlanCard = true
            }
        }) {
            Text("Continue")
                .font(.headline.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "00D4FF"), Color(hex: "0099CC")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(14)
        }
        .disabled(!hasValidSignature)
        .opacity(hasValidSignature ? 1.0 : 0.5)
    }
}

// PencilKit wrapper
struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    var onStrokeEnd: (Bool) -> Void
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 4)
        canvasView.delegate = context.coordinator
        canvasView.backgroundColor = .clear
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onStrokeEnd: onStrokeEnd)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var onStrokeEnd: (Bool) -> Void
        
        init(onStrokeEnd: @escaping (Bool) -> Void) {
            self.onStrokeEnd = onStrokeEnd
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            // Check if drawing has minimum path length
            let bounds = canvasView.drawing.bounds
            let hasStroke = bounds.width > 50 || bounds.height > 50
            onStrokeEnd(hasStroke)
        }
    }
}

#Preview {
    CommitmentSignatureView(quizData: OnboardingQuizData())
}
