//
//  DisclaimerView.swift
//  LooksmaxxingApp
//
//  Medical disclaimer for App Store compliance
//

import SwiftUI

struct DisclaimerView: View {
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer = false
    @State private var hasScrolledToBottom = false
    
    var body: some View {
        ZStack {
            Color(hex: "0A0A0F")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color(hex: "00D4FF"))
                    
                    Text("Important Information")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                }
                .padding(.top, 30)
                
                // Disclaimer Text
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        disclaimerSection(
                            title: "Not Medical Advice",
                            content: "This app provides general wellness and self-improvement suggestions only. It is not a medical device and does not provide medical advice, diagnosis, or treatment."
                        )
                        
                        disclaimerSection(
                            title: "Consult Professionals",
                            content: "Always consult with qualified healthcare professionals for any medical concerns. Do not disregard professional medical advice or delay seeking it because of information provided by this app."
                        )
                        
                        disclaimerSection(
                            title: "AI Analysis Limitations",
                            content: "The facial analysis feature uses artificial intelligence to provide estimates and suggestions. Results are not scientifically validated and should be considered for entertainment and self-improvement motivation only."
                        )
                        
                        disclaimerSection(
                            title: "Mental Health",
                            content: "If you experience negative thoughts about your appearance or body image concerns, please reach out to a mental health professional. Your wellbeing is more important than any score."
                        )
                        
                        disclaimerSection(
                            title: "Privacy",
                            content: "All facial analysis is performed on your device. Your photos are never uploaded to our servers or shared with third parties."
                        )
                        
                        // Bottom detector
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    hasScrolledToBottom = true
                                }
                        }
                        .frame(height: 1)
                    }
                    .padding()
                }
                .background(Color(hex: "12121A"))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Accept Button
                Button(action: { hasAcceptedDisclaimer = true }) {
                    Text("I Understand and Accept")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(hex: "00D4FF"))
                        )
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
        }
    }
    
    private func disclaimerSection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color(hex: "00D4FF"))
            
            Text(content)
                .font(.subheadline)
                .foregroundColor(Color(hex: "9CA3AF"))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    DisclaimerView()
}
