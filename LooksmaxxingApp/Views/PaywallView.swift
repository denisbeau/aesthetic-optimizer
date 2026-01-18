//
//  PaywallView.swift
//  LooksmaxxingApp
//
//  Subscription offer screen
//  Pro: $14.99/month - unlimited scans, detailed analysis, streak freeze
//

import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 15) {
                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 70))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("Unlock Pro Features")
                            .font(.largeTitle.bold())
                        
                        Text("Get the most out of your self-improvement journey")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 30)
                    
                    // Features List
                    VStack(spacing: 0) {
                        ProFeatureRow(
                            icon: "infinity",
                            title: "Unlimited Scans",
                            description: "Scan as often as you want"
                        )
                        
                        Divider().padding(.horizontal)
                        
                        ProFeatureRow(
                            icon: "chart.bar.fill",
                            title: "Detailed Analysis",
                            description: "See all strengths and weaknesses"
                        )
                        
                        Divider().padding(.horizontal)
                        
                        ProFeatureRow(
                            icon: "snowflake",
                            title: "Streak Freeze Access",
                            description: "Protect your streak when life happens"
                        )
                        
                        Divider().padding(.horizontal)
                        
                        ProFeatureRow(
                            icon: "bolt.fill",
                            title: "Priority Processing",
                            description: "Faster AI analysis"
                        )
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Comparison
                    ComparisonCard()
                        .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                    
                    // Pricing
                    VStack(spacing: 10) {
                        Text(String(format: "$%.2f", RemoteConfigService.shared.getMonthlyPrice()))
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                        
                        Text("per month")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Cancel anytime in App Store settings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Purchase Button
                    Button(action: purchase) {
                        HStack {
                            if isPurchasing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Subscribe to Pro")
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(14)
                    }
                    .disabled(isPurchasing)
                    .padding(.horizontal)
                    
                    // Restore Purchases
                    Button(action: restore) {
                        Text("Restore Purchases")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Terms
                    VStack(spacing: 5) {
                        Text("By subscribing, you agree to our")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 10) {
                            Button("Terms of Service") {
                                // Open terms
                            }
                            Text("and")
                            Button("Privacy Policy") {
                                // Open privacy
                            }
                        }
                        .font(.caption2)
                        .foregroundColor(.blue)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .onChange(of: subscriptionVM.isProUser) { isPro in
                if isPro {
                    dismiss()
                }
            }
        }
    }
    
    private func purchase() {
        isPurchasing = true
        Task {
            do {
                try await subscriptionVM.purchaseSubscription()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            isPurchasing = false
        }
    }
    
    private func restore() {
        isPurchasing = true
        Task {
            do {
                try await subscriptionVM.restorePurchases()
            } catch {
                errorMessage = "Unable to restore purchases. Please try again."
                showError = true
            }
            isPurchasing = false
        }
    }
}

// MARK: - Pro Feature Row

struct ProFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body.weight(.semibold))
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        }
        .padding()
    }
}

// MARK: - Comparison Card

struct ComparisonCard: View {
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Feature")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Free")
                    .frame(width: 60)
                Text("Pro")
                    .frame(width: 60)
                    .font(.caption.bold())
                    .foregroundColor(.blue)
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .padding()
            .background(Color.gray.opacity(0.2))
            
            // Rows
            ComparisonRow(feature: "Face Scans", free: "1/week", pro: "Unlimited")
            ComparisonRow(feature: "Analysis Detail", free: "Basic", pro: "Full")
            ComparisonRow(feature: "Streak Freeze", free: "❌", pro: "✓")
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ComparisonRow: View {
    let feature: String
    let free: String
    let pro: String
    
    var body: some View {
        HStack {
            Text(feature)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(free)
                .font(.caption)
                .frame(width: 60)
                .foregroundColor(.secondary)
            Text(pro)
                .font(.caption.weight(.semibold))
                .frame(width: 60)
                .foregroundColor(.blue)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

#Preview {
    PaywallView()
        .environmentObject(SubscriptionViewModel.shared)
}
