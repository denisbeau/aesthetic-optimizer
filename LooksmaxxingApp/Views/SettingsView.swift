//
//  SettingsView.swift
//  LooksmaxxingApp
//
//  User settings, preferences, and legal links
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @EnvironmentObject var streakVM: StreakViewModel
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var remoteConfig = RemoteConfigService.shared
    
    @AppStorage("notificationHour") private var notificationHour = 9
    @AppStorage("notificationMinute") private var notificationMinute = 0
    
    @State private var showDeleteConfirmation = false
    @State private var showExportSuccess = false
    @State private var showResetConfirmation = false
    
    var body: some View {
        NavigationView {
            List {
                // MARK: - Subscription Section
                Section {
                    HStack {
                        Image(systemName: subscriptionVM.isProUser ? "star.fill" : "star")
                            .foregroundColor(subscriptionVM.isProUser ? .yellow : .gray)
                        Text(subscriptionVM.isProUser ? "Pro Member" : "Free Plan")
                        Spacer()
                        if !subscriptionVM.isProUser {
                            Text("Upgrade")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    if subscriptionVM.isProUser {
                        Button("Manage Subscription") {
                            openSubscriptionManagement()
                        }
                    }
                } header: {
                    Text("Subscription")
                }
                
                // MARK: - Notifications Section
                Section {
                    DatePicker("Daily Reminder", selection: notificationTimeBinding, displayedComponents: .hourAndMinute)
                        .onChange(of: notificationHour) { _ in updateNotificationTime() }
                        .onChange(of: notificationMinute) { _ in updateNotificationTime() }
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("We'll remind you to complete your daily routine at this time.")
                }
                
                // MARK: - Data Section
                Section {
                    Button(action: exportData) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Export My Data")
                        }
                    }
                    
                    Button(action: { showResetConfirmation = true }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset Progress")
                        }
                        .foregroundColor(.orange)
                    }
                    
                    Button(action: { showDeleteConfirmation = true }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete All Data")
                        }
                        .foregroundColor(.red)
                    }
                } header: {
                    Text("Your Data")
                } footer: {
                    Text("All data is stored locally on your device.")
                }
                
                // MARK: - Legal Section
                Section {
                    Link(destination: URL(string: Secrets.privacyPolicyURL)!) {
                        HStack {
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Link(destination: URL(string: Secrets.termsOfServiceURL)!) {
                        HStack {
                            Text("Terms of Service")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Link(destination: URL(string: "mailto:\(Secrets.supportEmail)")!) {
                        HStack {
                            Text("Contact Support")
                            Spacer()
                            Image(systemName: "envelope")
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Legal")
                }
                
                // MARK: - Remote Config Status (Debug)
                #if DEBUG
                Section {
                    HStack {
                        Image(systemName: remoteConfig.isLoaded ? "checkmark.circle.fill" : "clock.fill")
                            .foregroundColor(remoteConfig.isLoaded ? .green : .orange)
                        Text("Remote Config Status")
                        Spacer()
                        Text(remoteConfig.isLoaded ? "Loaded" : "Loading...")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Monthly Price")
                        Spacer()
                        Text(String(format: "$%.2f", remoteConfig.getMonthlyPrice()))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Messaging Variant")
                        Spacer()
                        Text(remoteConfig.messagingVariant.rawValue)
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                } header: {
                    Text("Remote Config")
                } footer: {
                    Text("Shows values from Firebase. If prices/messages match Firebase Console, Remote Config is working.")
                }
                #endif
                
                // MARK: - About Section
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .alert("Delete All Data?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) { deleteAllData() }
            } message: {
                Text("This will permanently delete all your scans, streaks, and progress. This cannot be undone.")
            }
            .alert("Reset Progress?", isPresented: $showResetConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) { resetProgress() }
            } message: {
                Text("This will reset your streak and daily tasks. Your scan history will be preserved.")
            }
            .alert("Data Exported", isPresented: $showExportSuccess) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your data has been saved to the Files app.")
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var notificationTimeBinding: Binding<Date> {
        Binding(
            get: {
                var components = DateComponents()
                components.hour = notificationHour
                components.minute = notificationMinute
                return Calendar.current.date(from: components) ?? Date()
            },
            set: { newValue in
                let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                notificationHour = components.hour ?? 9
                notificationMinute = components.minute ?? 0
            }
        )
    }
    
    // MARK: - Actions
    
    private func updateNotificationTime() {
        var components = DateComponents()
        components.hour = notificationHour
        components.minute = notificationMinute
        if let date = Calendar.current.date(from: components) {
            NotificationService.shared.updateNotificationTime(date)
        }
    }
    
    private func openSubscriptionManagement() {
        if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
            UIApplication.shared.open(url)
        }
    }
    
    private func exportData() {
        let exportService = DataExportService()
        if exportService.exportUserData() {
            showExportSuccess = true
        }
    }
    
    private func resetProgress() {
        streakVM.resetStreak()
    }
    
    private func deleteAllData() {
        CoreDataManager.shared.deleteAllData()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        streakVM.loadStreak()
    }
}

#Preview {
    SettingsView()
        .environmentObject(SubscriptionViewModel.shared)
        .environmentObject(StreakViewModel.shared)
}
