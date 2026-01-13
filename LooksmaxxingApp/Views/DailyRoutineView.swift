//
//  DailyRoutineView.swift
//  LooksmaxxingApp
//
//  3 micro-tasks to maintain streak
//  - Water intake
//  - Skincare reminder
//  - Posture check
//

import SwiftUI

struct DailyRoutineView: View {
    @EnvironmentObject var streakVM: StreakViewModel
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @State private var completedTasks: Set<String> = []
    @State private var showDailyInsight = false
    @State private var showStreakFreeze = false
    @State private var celebrateAnimation = false
    
    private let tasks = [
        TaskItem(id: "water", name: "Log water intake", icon: "drop.fill", color: .blue),
        TaskItem(id: "skincare", name: "Skincare reminder", icon: "face.smiling", color: .pink),
        TaskItem(id: "posture", name: "Posture check", icon: "figure.stand", color: .green)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Streak Counter
                StreakDisplay(
                    streak: streakVM.currentStreak,
                    isAtRisk: streakVM.isStreakAtRisk,
                    hoursRemaining: streakVM.hoursRemaining,
                    celebrate: celebrateAnimation
                )
                
                // Streak at risk warning
                if streakVM.isStreakAtRisk && streakVM.currentStreak > 0 {
                    StreakAtRiskBanner(
                        hoursRemaining: streakVM.hoursRemaining,
                        onBuyFreeze: { showStreakFreeze = true }
                    )
                }
                
                // Tasks Section
                VStack(spacing: 15) {
                    ForEach(tasks) { task in
                        TaskRow(
                            task: task,
                            isCompleted: completedTasks.contains(task.id),
                            onTap: { toggleTask(task.id) }
                        )
                    }
                }
                
                // Progress indicator
                HStack {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(index < completedTasks.count ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 12, height: 12)
                    }
                }
                .padding(.vertical, 10)
                
                // Completion message
                if completedTasks.count == 3 {
                    CompletionBanner(onViewInsight: { showDailyInsight = true })
                } else {
                    Text("Complete all 3 to maintain your streak")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Daily Routine")
        .sheet(isPresented: $showDailyInsight) {
            DailyInsightView()
        }
        .sheet(isPresented: $showStreakFreeze) {
            StreakFreezeView()
        }
        .onAppear {
            loadTodayTasks()
        }
    }
    
    private func toggleTask(_ taskId: String) {
        if completedTasks.contains(taskId) {
            // Already completed, don't allow un-completing
            return
        }
        
        completedTasks.insert(taskId)
        
        // Haptic feedback
        let impact = UINotificationFeedbackGenerator()
        impact.notificationOccurred(.success)
        
        // Save to Core Data
        CoreDataManager.shared.createDailyTask(type: taskId, completed: true)
        
        // Check if all tasks complete
        if completedTasks.count == 3 {
            streakVM.updateStreak()
            
            // Celebration animation
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                celebrateAnimation = true
            }
            
            // Cancel streak at risk notification
            NotificationService.shared.cancelStreakAtRisk()
            
            // Strong haptic
            let feedback = UINotificationFeedbackGenerator()
            feedback.notificationOccurred(.success)
        }
    }
    
    private func loadTodayTasks() {
        completedTasks = CoreDataManager.shared.getCompletedTaskTypes(for: Date())
    }
}

// MARK: - Task Item Model

struct TaskItem: Identifiable {
    let id: String
    let name: String
    let icon: String
    let color: Color
}

// MARK: - Streak Display

struct StreakDisplay: View {
    let streak: Int
    let isAtRisk: Bool
    let hoursRemaining: Int
    let celebrate: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 15) {
                Text("🔥")
                    .font(.system(size: 60))
                    .scaleEffect(celebrate ? 1.3 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: celebrate)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(streak)")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                    Text("Day Streak")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
            
            if isAtRisk && streak > 0 {
                Text("\(hoursRemaining) hours remaining")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
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

// MARK: - Task Row

struct TaskRow: View {
    let task: TaskItem
    let isCompleted: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(isCompleted ? task.color : task.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: task.icon)
                            .font(.title2)
                            .foregroundColor(task.color)
                    }
                }
                
                Text(task.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .strikethrough(isCompleted, color: .secondary)
                
                Spacer()
                
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isCompleted ? .green : .gray.opacity(0.5))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isCompleted ? task.color.opacity(0.1) : Color.gray.opacity(0.1))
            )
        }
        .disabled(isCompleted)
    }
}

// MARK: - Streak At Risk Banner

struct StreakAtRiskBanner: View {
    let hoursRemaining: Int
    let onBuyFreeze: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text("Your streak is at risk!")
                    .font(.headline)
            }
            
            Text("Complete your routine or use a Streak Freeze")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: onBuyFreeze) {
                HStack {
                    Image(systemName: "snowflake")
                    Text("Use Streak Freeze")
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.blue)
                .cornerRadius(20)
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(14)
    }
}

// MARK: - Completion Banner

struct CompletionBanner: View {
    let onViewInsight: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Text("🎉 All tasks complete!")
                .font(.headline)
            
            Text("You've maintained your streak!")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: onViewInsight) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                    Text("View Daily Insight")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [.green, .mint],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(14)
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(14)
    }
}

// MARK: - Daily Insight View

struct DailyInsightView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let insights = [
        "Drinking 8 glasses of water daily improves skin clarity and elasticity. Hydration is the foundation of healthy skin.",
        "Consistent skincare routine shows visible results in 2-3 weeks. Patience and consistency are key!",
        "Good posture enhances facial definition and jawline appearance. Stand tall, feel confident.",
        "Quality sleep (7-8 hours) is essential for skin cell regeneration and reduces dark circles.",
        "Reducing sodium intake decreases facial bloating and puffiness.",
        "Regular facial exercises can help tone facial muscles over time.",
        "Sun protection (SPF 30+) prevents premature aging and maintains skin health.",
        "Stress management directly impacts skin health - cortisol affects oil production and inflammation."
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.yellow)
                
                Text("Daily Insight")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(insights.randomElement() ?? insights[0])
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Text("Got it!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(14)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
            .padding(.top, 50)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Streak Freeze View

struct StreakFreezeView: View {
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @EnvironmentObject var streakVM: StreakViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isPurchasing = false
    @State private var showError = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Image(systemName: "snowflake")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Streak Freeze")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Protect your \(streakVM.currentStreak) day streak from being lost!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 10) {
                    Text("You have \(subscriptionVM.streakFreezeCount) freeze(s)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if subscriptionVM.streakFreezeCount > 0 {
                        Button(action: useFreeze) {
                            Text("Use Streak Freeze")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(14)
                        }
                    }
                    
                    Button(action: purchaseFreeze) {
                        HStack {
                            Text("Buy Streak Freeze")
                            Text("$1.99")
                                .fontWeight(.bold)
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(14)
                    }
                    .disabled(isPurchasing)
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .padding(.top, 50)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
            .alert("Purchase Failed", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Unable to complete purchase. Please try again.")
            }
        }
    }
    
    private func useFreeze() {
        if streakVM.applyStreakFreeze() {
            dismiss()
        }
    }
    
    private func purchaseFreeze() {
        isPurchasing = true
        Task {
            do {
                try await subscriptionVM.purchaseStreakFreeze()
                dismiss()
            } catch {
                showError = true
            }
            isPurchasing = false
        }
    }
}

#Preview {
    NavigationStack {
        DailyRoutineView()
            .environmentObject(StreakViewModel.shared)
            .environmentObject(SubscriptionViewModel.shared)
    }
}
