//
//  HomeViewDark.swift
//  LooksmaxxingApp
//
//  Dark masculine home screen design
//  Matches the looksmaxxing aesthetic
//

import SwiftUI

struct HomeViewDark: View {
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @EnvironmentObject var streakVM: StreakViewModel
    @State private var showScan = false
    @State private var showDailyRoutine = false
    @State private var showPaywall = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(hex: "0A0A0F")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        headerSection
                        
                        // Streak card
                        streakCard
                        
                        // Main scan button
                        scanButton
                        
                        // Daily routine card
                        dailyRoutineCard
                        
                        // Progress section
                        progressSection
                        
                        // Pro upgrade card (if not pro)
                        if !subscriptionVM.isProUser {
                            proUpgradeCard
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showScan) {
            CameraView()
                .environmentObject(subscriptionVM)
        }
        .sheet(isPresented: $showDailyRoutine) {
            DailyRoutineView()
                .environmentObject(streakVM)
                .environmentObject(subscriptionVM)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
                .environmentObject(subscriptionVM)
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("AESTHETIC")
                    .font(.caption.bold())
                    .foregroundColor(Color(hex: "00D4FF"))
                    .tracking(2)
                
                Text("Optimizer")
                    .font(.title.bold())
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Settings/Profile button
            Button(action: {}) {
                Image(systemName: "gearshape.fill")
                    .font(.title3)
                    .foregroundColor(Color(hex: "6B7280"))
                    .padding(12)
                    .background(Circle().fill(Color(hex: "12121A")))
            }
        }
    }
    
    // MARK: - Streak Card
    
    private var streakCard: some View {
        HStack(spacing: 16) {
            // Fire emoji with glow
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.2))
                    .frame(width: 56, height: 56)
                
                Text("🔥")
                    .font(.system(size: 28))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(streakVM.currentStreak)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Day Streak")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "6B7280"))
            }
            
            Spacer()
            
            // Streak status
            if streakVM.isStreakAtRisk {
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(streakVM.hoursRemaining)h left")
                        .font(.headline.bold())
                        .foregroundColor(Color(hex: "EF4444"))
                    
                    Text("At Risk!")
                        .font(.caption)
                        .foregroundColor(Color(hex: "EF4444"))
                }
            } else if streakVM.currentStreak > 0 {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundColor(Color(hex: "10B981"))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "12121A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(streakVM.isStreakAtRisk ? Color(hex: "EF4444").opacity(0.5) : Color(hex: "2A2A34"), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Scan Button
    
    private var scanButton: some View {
        Button(action: {
            if subscriptionVM.canScanToday {
                showScan = true
            } else {
                showPaywall = true
            }
        }) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "00D4FF").opacity(0.2), Color(hex: "00D4FF").opacity(0.05)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "faceid")
                        .font(.system(size: 36))
                        .foregroundColor(Color(hex: "00D4FF"))
                }
                
                Text("Scan Face")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                
                if !subscriptionVM.canScanToday {
                    Text("Unlock with Pro")
                        .font(.caption)
                        .foregroundColor(Color(hex: "6B7280"))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "0A1A1F"), Color(hex: "12121A")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "00D4FF").opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Daily Routine Card
    
    private var dailyRoutineCard: some View {
        Button(action: {
            showDailyRoutine = true
        }) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color(hex: "10B981").opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "checkmark.circle")
                        .font(.title2)
                        .foregroundColor(Color(hex: "10B981"))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Routine")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("3 exercises today")
                        .font(.caption)
                        .foregroundColor(Color(hex: "6B7280"))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(hex: "6B7280"))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: "12121A"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "2A2A34"), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Progress Section
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("YOUR PROGRESS")
                .font(.caption.bold())
                .foregroundColor(Color(hex: "6B7280"))
                .tracking(1.5)
            
            HStack(spacing: 12) {
                progressCard("Total\nScans", "\(streakVM.totalDays)", "chart.bar.fill")
                progressCard("Best\nStreak", "\(streakVM.currentStreak)", "flame.fill")
                progressCard("Days\nActive", "\(streakVM.totalDays)", "calendar")
            }
        }
    }
    
    private func progressCard(_ title: String, _ value: String, _ icon: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color(hex: "00D4FF"))
            
            Text(value)
                .font(.title2.bold())
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(Color(hex: "6B7280"))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "12121A"))
        )
    }
    
    // MARK: - Pro Upgrade Card
    
    private var proUpgradeCard: some View {
        Button(action: {
            showPaywall = true
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color(hex: "F59E0B"))
                        
                        Text("Upgrade to Pro")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                    }
                    
                    Text("Unlimited scans & detailed analysis")
                        .font(.caption)
                        .foregroundColor(Color(hex: "6B7280"))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(hex: "F59E0B"))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "F59E0B").opacity(0.1), Color(hex: "12121A")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "F59E0B").opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    HomeViewDark()
        .environmentObject(SubscriptionViewModel.shared)
        .environmentObject(StreakViewModel.shared)
}
