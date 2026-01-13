//
//  ResultsView.swift
//  LooksmaxxingApp
//
//  Displays face analysis results
//  Free tier: Basic rating + blurred weaknesses
//  Pro tier: Full analysis with all details
//

import SwiftUI

struct ResultsView: View {
    let analysis: FaceAnalysisResult
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @State private var showPaywall = false
    @State private var showAnimation = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Rating Display
                    RatingDisplay(rating: analysis.rating, showAnimation: showAnimation)
                    
                    // Strengths Section
                    AnalysisSection(
                        title: "Your Top Strengths",
                        items: analysis.strengths,
                        icon: "arrow.up.circle.fill",
                        color: .green,
                        isBlurred: false
                    )
                    
                    // Weaknesses Section
                    AnalysisSection(
                        title: "Areas for Improvement",
                        items: analysis.weaknesses,
                        icon: "arrow.down.circle.fill",
                        color: .orange,
                        isBlurred: !subscriptionVM.isProUser
                    )
                    
                    // Unlock prompt for free users
                    if !subscriptionVM.isProUser {
                        Button(action: { showPaywall = true }) {
                            HStack {
                                Image(systemName: "lock.fill")
                                Text("Unlock detailed analysis")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(14)
                        }
                    }
                    
                    // Daily Routine CTA
                    NavigationLink(destination: DailyRoutineView()) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Start your daily routine")
                        }
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(14)
                    }
                    
                    // Processing time (subtle)
                    Text("Analysis completed in \(String(format: "%.2f", analysis.processingTime))s")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationTitle("Your Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    showAnimation = true
                }
                
                // Haptic feedback
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                
                // Request notification permission after first scan
                if !UserDefaults.standard.hasRequestedNotifications {
                    NotificationService.shared.requestPermission { granted in
                        if granted {
                            NotificationService.shared.scheduleDailyReminder()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Rating Display

struct RatingDisplay: View {
    let rating: Double
    let showAnimation: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Text(String(format: "%.1f", rating))
                .font(.system(size: 80, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .scaleEffect(showAnimation ? 1.0 : 0.5)
                .opacity(showAnimation ? 1.0 : 0.0)
            
            Text("out of 10")
                .font(.title3)
                .foregroundColor(.secondary)
            
            // Rating bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 12)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(ratingGradient)
                        .frame(width: showAnimation ? geometry.size.width * (rating / 10) : 0, height: 12)
                }
            }
            .frame(height: 12)
            .padding(.horizontal, 40)
        }
        .padding()
    }
    
    private var ratingGradient: LinearGradient {
        if rating >= 8 {
            return LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing)
        } else if rating >= 6 {
            return LinearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing)
        } else if rating >= 4 {
            return LinearGradient(colors: [.orange, .yellow], startPoint: .leading, endPoint: .trailing)
        } else {
            return LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
        }
    }
}

// MARK: - Analysis Section

struct AnalysisSection: View {
    let title: String
    let items: [String]
    let icon: String
    let color: Color
    let isBlurred: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(items.indices, id: \.self) { index in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1).")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(color)
                            .frame(width: 25, alignment: .leading)
                        
                        if isBlurred && index > 0 {
                            ZStack {
                                Text(items[index])
                                    .font(.body)
                                    .blur(radius: 6)
                                
                                HStack {
                                    Image(systemName: "lock.fill")
                                        .font(.caption)
                                    Text("Pro")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.secondary)
                            }
                        } else {
                            Text(items[index])
                                .font(.body)
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding()
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

#Preview {
    ResultsView(analysis: FaceAnalysisResult.mockResult)
        .environmentObject(SubscriptionViewModel.shared)
}
