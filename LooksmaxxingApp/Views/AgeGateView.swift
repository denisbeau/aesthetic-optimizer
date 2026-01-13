//
//  AgeGateView.swift
//  LooksmaxxingApp
//
//  Age verification for COPPA compliance
//

import SwiftUI

struct AgeGateView: View {
    @AppStorage("hasVerifiedAge") private var hasVerifiedAge = false
    @AppStorage("userAgeGroup") private var userAgeGroup = ""
    
    @State private var selectedAge: AgeGroup?
    @State private var showUnderageAlert = false
    
    enum AgeGroup: String, CaseIterable {
        case under13 = "Under 13"
        case teen13to16 = "13-16"
        case teen16to18 = "16-18"
        case youngAdult = "18-25"
        case adult = "25+"
        
        var isAllowed: Bool {
            self != .under13
        }
        
        var displayName: String {
            return self.rawValue
        }
    }
    
    var body: some View {
        ZStack {
            Color(hex: "0A0A0F")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Icon
                Image(systemName: "person.crop.circle.badge.checkmark")
                    .font(.system(size: 80))
                    .foregroundColor(Color(hex: "00D4FF"))
                
                // Title
                VStack(spacing: 8) {
                    Text("Age Verification")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    Text("Please confirm your age to continue")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "6B7280"))
                }
                
                // Age Options
                VStack(spacing: 12) {
                    ForEach(AgeGroup.allCases, id: \.self) { age in
                        Button(action: { selectedAge = age }) {
                            HStack {
                                Text(age.displayName)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if selectedAge == age {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(hex: "00D4FF"))
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedAge == age ? Color(hex: "00D4FF").opacity(0.2) : Color(hex: "12121A"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedAge == age ? Color(hex: "00D4FF") : Color(hex: "2A2A34"), lineWidth: 1)
                                    )
                            )
                        }
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                // Continue Button
                Button(action: verifyAge) {
                    Text("Continue")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(selectedAge != nil ? Color(hex: "00D4FF") : Color(hex: "2A2A34"))
                        )
                }
                .disabled(selectedAge == nil)
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
        .alert("Age Requirement", isPresented: $showUnderageAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You must be at least 13 years old to use this app. If you are under 13, please ask a parent or guardian for assistance.")
        }
    }
    
    private func verifyAge() {
        guard let age = selectedAge else { return }
        
        if age == .under13 {
            showUnderageAlert = true
            return
        }
        
        userAgeGroup = age.rawValue
        hasVerifiedAge = true
    }
}

#Preview {
    AgeGateView()
}
