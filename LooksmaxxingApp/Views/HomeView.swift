//
//  HomeView.swift
//  LooksmaxxingApp
//
//  Main daily entry point
//  Shows streak, scan button, daily routine access
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @EnvironmentObject var streakVM: StreakViewModel
    @State private var showPaywall = false
    @State private var showCamera = false
    @State private var showScanLimit = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Streak Counter
                    StreakCard(streak: streakVM.currentStreak, isAtRisk: streakVM.isStreakAtRisk)
                    
                    // Main Actions
                    VStack(spacing: 15) {
                        // Scan Face Button
                        Button(action: handleScanTap) {
                            VStack(spacing: 12) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 40))
                                Text("Scan Face")
                                    .font(.headline)
                                
                                if !subscriptionVM.isProUser {
                                    let daysLeft = subscriptionVM.daysUntilNextFreeScan()
                                    if daysLeft > 0 {
                                        Text("Next free scan in \(daysLeft) days")
                                            .font(.caption)
                                            .opacity(0.8)
                                    }
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 30)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(20)
                            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        
                        // Daily Routine Button
                        NavigationLink(destination: DailyRoutineView()) {
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2)
                                Text("Daily Routine")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.body)
                            }
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(14)
                        }
                    }
                    
                    // Progress Section
                    ProgressSection()
                    
                    // Pro Upgrade Banner (if free)
                    if !subscriptionVM.isProUser {
                        Button(action: { showPaywall = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Upgrade to Pro")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text("Unlimited scans & detailed analysis")
                                        .font(.caption)
                                        .opacity(0.8)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.primary)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.yellow.opacity(0.2), .orange.opacity(0.2)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(14)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Aesthetic Optimizer")
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraView()
            }
            .alert("Scan Limit Reached", isPresented: $showScanLimit) {
                Button("Upgrade to Pro") { showPaywall = true }
                Button("Cancel", role: .cancel) {}
            } message: {
                let days = subscriptionVM.daysUntilNextFreeScan()
                Text("Free users can scan once per week. Your next free scan is available in \(days) days. Upgrade to Pro for unlimited scans!")
            }
            .onAppear {
                streakVM.loadStreak()
                subscriptionVM.checkSubscriptionStatus()
            }
        }
    }
    
    private func handleScanTap() {
        if subscriptionVM.canScanToday() {
            showCamera = true
        } else {
            showScanLimit = true
        }
    }
}

// MARK: - Streak Card

struct StreakCard: View {
    let streak: Int
    let isAtRisk: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Text("🔥")
                .font(.system(size: 50))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(streak)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                Text("Day Streak")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isAtRisk {
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("At Risk!")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.orange.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isAtRisk ? Color.orange : Color.clear, lineWidth: 2)
                )
        )
    }
}

// MARK: - Progress Section

struct ProgressSection: View {
    @State private var lastAnalysis: FaceAnalysisEntity?
    @State private var analysisCount: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Your Progress")
                .font(.headline)
            
            if let analysis = lastAnalysis {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Last scan")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(String(format: "%.1f/10", analysis.rating))
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Total scans")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(analysisCount)")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    if let date = analysis.scanDate {
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Date")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(date, style: .relative)
                                .font(.caption)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            } else {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title)
                        .foregroundColor(.secondary)
                    Text("Complete your first scan to see progress")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .onAppear {
            lastAnalysis = CoreDataManager.shared.fetchLatestAnalysis()
            analysisCount = CoreDataManager.shared.getAnalysisCount()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(SubscriptionViewModel.shared)
        .environmentObject(StreakViewModel.shared)
}
