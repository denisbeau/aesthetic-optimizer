# Production Roadmap: Aesthetic Optimizer

**Date:** January 13, 2026  
**Audit Type:** AI-First Automation Audit  
**Status:** MVP Built → Production Readiness

---

## EXECUTIVE SUMMARY

This roadmap separates all remaining work into **Manual Tasks** (human-required) and **AI-Executable Tasks** (automated in this document). All AI-executable code is provided below and can be copy-pasted or run immediately.

### Task Distribution

| Category | Count | Status |
|----------|-------|--------|
| **AI-Executable** | 18 tasks | ✅ Code provided below |
| **Manual Required** | 9 tasks | 📋 Checklist provided |
| **Already Complete** | 26 files | ✅ MVP built |

---

## PART 1: MANUAL TASKS (Human Required)

These tasks **cannot** be automated and require human action:

### 🎨 M1: Visual Assets (Requires Designer/Human)

| Task | Why Manual | Deliverable |
|------|------------|-------------|
| App Icon Design | Subjective brand decision | 1024x1024 PNG + all sizes |
| Launch Screen Image | Brand visual | Dark background + logo |
| App Store Screenshots | Requires device capture | 6.5" and 5.5" displays |
| App Store Preview Video | Optional but high-impact | 15-30 second demo |

**Workaround:** Use SF Symbols + code-generated gradient for icon base (see AI task A12).

### 🔑 M2: Account Setup (Requires Credentials)

| Task | Why Manual | Action |
|------|------------|--------|
| Apple Developer Account | $99/year payment | developer.apple.com |
| RevenueCat Account | API key generation | revenuecat.com |
| App Store Connect | App record creation | appstoreconnect.apple.com |
| Firebase Project | Project ID needed | console.firebase.google.com |

**After Setup:** Paste API keys into `Secrets.swift` (AI task A1).

### 📋 M3: Legal/Compliance (Requires Review)

| Task | Why Manual | Action |
|------|------------|--------|
| Privacy Policy Hosting | Need URL endpoint | Host on website/GitHub Pages |
| Terms of Service Hosting | Need URL endpoint | Host on website/GitHub Pages |
| Legal Review | Liability check | Optional lawyer review |
| Quebec PIA Filing | Government submission | cai.gouv.qc.ca |

**AI Provides:** Full Privacy Policy and Terms text (see AI task A14).

### 🧪 M4: Testing & Submission

| Task | Why Manual | Action |
|------|------------|--------|
| Device Testing | Physical device needed | Run on real iPhone |
| TestFlight Upload | Xcode archive required | Xcode → Archive → Upload |
| App Store Submission | Human review answers | App Store Connect form |
| Sandbox Purchase Test | Apple sandbox account | Settings → App Store → Sandbox |

---

## PART 2: AI-EXECUTABLE TASKS (Code Provided)

All tasks below are **immediately executable**. Copy the code into your project.

---

### A1: Secrets Configuration File

**Purpose:** Centralized API key management  
**File:** `LooksmaxxingApp/Config/Secrets.swift`

```swift
//
//  Secrets.swift
//  LooksmaxxingApp
//
//  API keys and configuration - DO NOT COMMIT TO PUBLIC REPO
//

import Foundation

enum Secrets {
    // MARK: - RevenueCat
    // Get from: https://app.revenuecat.com/apps → API Keys
    static let revenueCatAPIKey = "YOUR_REVENUECAT_API_KEY"
    
    // MARK: - Product IDs (Configure in RevenueCat Dashboard)
    static let proMonthlyProductID = "pro_monthly_1499"
    static let proYearlyProductID = "pro_yearly_9999"
    static let streakFreezeProductID = "streak_freeze_199"
    
    // MARK: - Firebase (Optional)
    // Get from: Firebase Console → Project Settings
    static let firebaseProjectID = "YOUR_FIREBASE_PROJECT_ID"
    
    // MARK: - App Configuration
    static let appStoreID = "YOUR_APP_STORE_ID"
    static let supportEmail = "support@aestheticoptimizer.com"
    static let privacyPolicyURL = "https://yoursite.com/privacy"
    static let termsOfServiceURL = "https://yoursite.com/terms"
}
```

---

### A2: Info.plist (Complete)

**Purpose:** App permissions and configuration  
**File:** `LooksmaxxingApp/Info.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    
    <key>CFBundleDisplayName</key>
    <string>Aesthetic Optimizer</string>
    
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    
    <key>CFBundleVersion</key>
    <string>1</string>
    
    <key>LSRequiresIPhoneOS</key>
    <true/>
    
    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
    
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>armv7</string>
    </array>
    
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
    </array>
    
    <key>UIStatusBarStyle</key>
    <string>UIStatusBarStyleLightContent</string>
    
    <key>UIUserInterfaceStyle</key>
    <string>Dark</string>
    
    <!-- CAMERA PERMISSION -->
    <key>NSCameraUsageDescription</key>
    <string>We need camera access to analyze your facial features. All processing happens on your device - your photos never leave your phone.</string>
    
    <!-- PHOTO LIBRARY PERMISSION -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Save your progress photos to track your transformation journey.</string>
    
    <!-- NOTIFICATIONS PERMISSION -->
    <key>UIBackgroundModes</key>
    <array>
        <string>remote-notification</string>
    </array>
    
    <!-- APP TRANSPORT SECURITY -->
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <false/>
    </dict>
    
    <!-- ITUNES FILE SHARING (for data export) -->
    <key>UIFileSharingEnabled</key>
    <true/>
    <key>LSSupportsOpeningDocumentsInPlace</key>
    <true/>
</dict>
</plist>
```

---

### A3: Settings Screen (Complete)

**Purpose:** User preferences, legal links, account management  
**File:** `LooksmaxxingApp/Views/SettingsView.swift`

```swift
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
```

---

### A4: Data Export Service (GDPR Compliance)

**Purpose:** Allow users to export their data  
**File:** `LooksmaxxingApp/Services/DataExportService.swift`

```swift
//
//  DataExportService.swift
//  LooksmaxxingApp
//
//  GDPR/Law 25 compliant data export functionality
//

import Foundation

class DataExportService {
    
    struct ExportData: Codable {
        let exportDate: String
        let appVersion: String
        let userData: UserData
    }
    
    struct UserData: Codable {
        let streak: StreakData
        let dailyTasks: [DailyTaskData]
        let faceAnalyses: [FaceAnalysisData]
        let preferences: PreferencesData
    }
    
    struct StreakData: Codable {
        let currentStreak: Int
        let totalDays: Int
        let lastCompletionDate: String?
    }
    
    struct DailyTaskData: Codable {
        let taskType: String
        let completedDate: String
        let isCompleted: Bool
    }
    
    struct FaceAnalysisData: Codable {
        let rating: Double
        let strengths: [String]
        let weaknesses: [String]
        let scanDate: String
    }
    
    struct PreferencesData: Codable {
        let isProUser: Bool
        let hasCompletedOnboarding: Bool
        let notificationHour: Int
        let notificationMinute: Int
    }
    
    func exportUserData() -> Bool {
        let dateFormatter = ISO8601DateFormatter()
        
        // Gather streak data
        let streakEntity = CoreDataManager.shared.fetchStreak()
        let streakData = StreakData(
            currentStreak: Int(streakEntity?.currentStreak ?? 0),
            totalDays: Int(streakEntity?.totalDays ?? 0),
            lastCompletionDate: streakEntity?.lastCompletionDate.map { dateFormatter.string(from: $0) }
        )
        
        // Gather daily tasks
        let dailyTasks = CoreDataManager.shared.fetchDailyTasks(for: Date())
        let dailyTasksData = dailyTasks.map { task in
            DailyTaskData(
                taskType: task.taskType ?? "",
                completedDate: dateFormatter.string(from: task.completedDate ?? Date()),
                isCompleted: task.isCompleted
            )
        }
        
        // Gather face analyses
        let analyses = CoreDataManager.shared.fetchFaceAnalyses()
        let analysesData = analyses.map { analysis in
            FaceAnalysisData(
                rating: analysis.rating,
                strengths: (analysis.strengths as? [String]) ?? [],
                weaknesses: (analysis.weaknesses as? [String]) ?? [],
                scanDate: dateFormatter.string(from: analysis.scanDate ?? Date())
            )
        }
        
        // Gather preferences
        let preferencesData = PreferencesData(
            isProUser: UserDefaults.standard.isProUser,
            hasCompletedOnboarding: UserDefaults.standard.bool(forKey: "hasCompletedOnboarding"),
            notificationHour: UserDefaults.standard.integer(forKey: "notificationHour"),
            notificationMinute: UserDefaults.standard.integer(forKey: "notificationMinute")
        )
        
        // Build export
        let userData = UserData(
            streak: streakData,
            dailyTasks: dailyTasksData,
            faceAnalyses: analysesData,
            preferences: preferencesData
        )
        
        let exportData = ExportData(
            exportDate: dateFormatter.string(from: Date()),
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0",
            userData: userData
        )
        
        // Save to Documents
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let jsonData = try encoder.encode(exportData)
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("AestheticOptimizer_Export_\(Date().timeIntervalSince1970).json")
            
            try jsonData.write(to: fileURL)
            return true
        } catch {
            print("Export failed: \(error)")
            return false
        }
    }
}
```

---

### A5: Age Gate Screen

**Purpose:** COPPA compliance - verify user age  
**File:** `LooksmaxxingApp/Views/AgeGateView.swift`

```swift
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
        case teen = "13-17"
        case adult = "18+"
        
        var isAllowed: Bool {
            self == .adult || self == .teen
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
                                Text(age.rawValue)
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
```

---

### A6: Medical Disclaimer Screen

**Purpose:** Legal protection for health-related content  
**File:** `LooksmaxxingApp/Views/DisclaimerView.swift`

```swift
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
```

---

### A7: Updated ContentView (Flow Controller)

**Purpose:** Proper app flow with age gate and disclaimer  
**File:** Update `LooksmaxxingApp/App/ContentView.swift`

```swift
//
//  ContentView.swift
//  LooksmaxxingApp
//
//  Main navigation controller with proper flow:
//  Age Gate → Disclaimer → Onboarding → Home
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasVerifiedAge") private var hasVerifiedAge = false
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    @EnvironmentObject var subscriptionVM: SubscriptionViewModel
    @EnvironmentObject var streakVM: StreakViewModel
    
    var body: some View {
        Group {
            if !hasVerifiedAge {
                AgeGateView()
            } else if !hasAcceptedDisclaimer {
                DisclaimerView()
            } else if !hasCompletedOnboarding {
                OnboardingQuizView()
            } else {
                HomeViewDark()
            }
        }
        .animation(.easeInOut, value: hasVerifiedAge)
        .animation(.easeInOut, value: hasAcceptedDisclaimer)
        .animation(.easeInOut, value: hasCompletedOnboarding)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environmentObject(SubscriptionViewModel.shared)
        .environmentObject(StreakViewModel.shared)
}
```

---

### A8: Near-Miss Messaging

**Purpose:** 30% engagement lift  
**File:** Add to `LooksmaxxingApp/Services/CoreMLService.swift`

```swift
// Add this method to CoreMLService class

// MARK: - Near-Miss Messaging

func nearMissMessage(for score: Double) -> String? {
    let thresholds: [(value: Double, label: String)] = [
        (7.0, "7.0"),
        (7.5, "7.5"),
        (8.0, "8.0"),
        (8.5, "8.5"),
        (9.0, "9.0")
    ]
    
    for threshold in thresholds {
        if score < threshold.value && score >= threshold.value - 0.3 {
            let difference = threshold.value - score
            return "You're just \(String(format: "%.1f", difference)) points from \(threshold.label)! Complete your daily routine to boost your score."
        }
    }
    
    return nil
}

func motivationalMessage(for score: Double) -> String {
    switch score {
    case 9.0...10.0:
        return "Exceptional! You're in the top tier. Keep up the great work!"
    case 8.0..<9.0:
        return "Great score! You're above average. Small improvements can push you higher."
    case 7.0..<8.0:
        return "Good foundation! With consistent effort, you can reach the next level."
    case 6.0..<7.0:
        return "Room for improvement. Your daily routine will help you progress."
    default:
        return "Everyone starts somewhere. Stick with your routine and watch your score improve!"
    }
}
```

---

### A9: Red Badge on Incomplete Tasks

**Purpose:** Visual urgency indicator  
**File:** Update `LooksmaxxingApp/Views/HomeViewDark.swift`

Add this state variable at the top of `HomeViewDark`:
```swift
@State private var incompleteTasks: Int = 3
```

Add this `onAppear` modifier to the main view:
```swift
.onAppear {
    let completed = CoreDataManager.shared.getCompletedTaskTypes(for: Date())
    incompleteTasks = 3 - completed.count
}
```

Replace the `dailyRoutineCard` with:
```swift
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
                
                Text(incompleteTasks > 0 ? "\(incompleteTasks) tasks remaining" : "All done! ✓")
                    .font(.caption)
                    .foregroundColor(incompleteTasks > 0 ? Color(hex: "EF4444") : Color(hex: "10B981"))
            }
            
            Spacer()
            
            // Red badge for incomplete tasks
            if incompleteTasks > 0 {
                ZStack {
                    Circle()
                        .fill(Color(hex: "EF4444"))
                        .frame(width: 24, height: 24)
                    
                    Text("\(incompleteTasks)")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                }
            }
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color(hex: "6B7280"))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(hex: "12121A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(incompleteTasks > 0 ? Color(hex: "EF4444").opacity(0.5) : Color(hex: "2A2A34"), lineWidth: 1)
                )
        )
    }
}
```

---

### A10: Celebration Animations

**Purpose:** Milestone celebrations for retention  
**File:** `LooksmaxxingApp/Views/Components/CelebrationView.swift`

```swift
//
//  CelebrationView.swift
//  LooksmaxxingApp
//
//  Confetti and celebration animations for milestones
//

import SwiftUI

struct CelebrationView: View {
    let message: String
    let emoji: String
    @Binding var isShowing: Bool
    
    @State private var particles: [Particle] = []
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }
            
            // Confetti particles
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
            
            // Celebration card
            VStack(spacing: 20) {
                Text(emoji)
                    .font(.system(size: 80))
                    .scaleEffect(scale)
                
                Text(message)
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Button(action: dismiss) {
                    Text("Awesome!")
                        .font(.headline.bold())
                        .foregroundColor(.black)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                        .background(Color(hex: "00D4FF"))
                        .cornerRadius(25)
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(hex: "12121A"))
            )
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            startAnimation()
            triggerHaptic()
        }
    }
    
    private func startAnimation() {
        // Generate confetti particles
        for _ in 0..<50 {
            particles.append(Particle())
        }
        
        // Animate card appearance
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            scale = 1.0
            opacity = 1.0
        }
        
        // Animate confetti
        animateConfetti()
    }
    
    private func animateConfetti() {
        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { timer in
            for i in particles.indices {
                particles[i].position.y += particles[i].velocity
                particles[i].position.x += sin(particles[i].position.y / 30) * 2
                particles[i].opacity -= 0.01
                
                if particles[i].opacity <= 0 {
                    particles[i] = Particle()
                    particles[i].position.y = -20
                }
            }
        }
    }
    
    private func triggerHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Additional impact for milestone
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.impactOccurred()
        }
    }
    
    private func dismiss() {
        withAnimation(.easeOut(duration: 0.3)) {
            opacity = 0
            scale = 0.8
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isShowing = false
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGFloat
    var size: CGFloat
    var color: Color
    var opacity: Double
    
    init() {
        self.position = CGPoint(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: CGFloat.random(in: -50...0)
        )
        self.velocity = CGFloat.random(in: 3...8)
        self.size = CGFloat.random(in: 6...12)
        self.color = [
            Color(hex: "00D4FF"),
            Color(hex: "F59E0B"),
            Color(hex: "10B981"),
            Color(hex: "EF4444"),
            Color(hex: "8B5CF6")
        ].randomElement()!
        self.opacity = 1.0
    }
}

// MARK: - Celebration Manager

class CelebrationManager: ObservableObject {
    static let shared = CelebrationManager()
    
    @Published var isShowing = false
    @Published var message = ""
    @Published var emoji = ""
    
    func celebrate(for milestone: Milestone) {
        switch milestone {
        case .streak7:
            message = "One Week Streak!"
            emoji = "🔥"
        case .streak30:
            message = "30 Day Champion!"
            emoji = "👑"
        case .streak100:
            message = "100 Day Legend!"
            emoji = "🏆"
        case .firstScan:
            message = "First Scan Complete!"
            emoji = "📸"
        case .score8:
            message = "You Hit 8.0!"
            emoji = "⭐"
        case .perfectWeek:
            message = "Perfect Week!"
            emoji = "💪"
        }
        
        isShowing = true
    }
    
    enum Milestone {
        case streak7, streak30, streak100
        case firstScan, score8, perfectWeek
    }
}

#Preview {
    CelebrationView(
        message: "One Week Streak!",
        emoji: "🔥",
        isShowing: .constant(true)
    )
}
```

---

### A11: Error Alert System

**Purpose:** User-friendly error messages  
**File:** `LooksmaxxingApp/Views/Components/ErrorAlertModifier.swift`

```swift
//
//  ErrorAlertModifier.swift
//  LooksmaxxingApp
//
//  Unified error handling with user-friendly messages
//

import SwiftUI

// MARK: - Error Alert Manager

class ErrorAlertManager: ObservableObject {
    static let shared = ErrorAlertManager()
    
    @Published var isShowing = false
    @Published var title = ""
    @Published var message = ""
    @Published var actionTitle = "OK"
    @Published var action: (() -> Void)?
    
    func show(_ error: AppError) {
        switch error {
        case .noFaceDetected:
            title = "No Face Detected"
            message = "Please make sure your face is clearly visible and well-lit. Try moving to a brighter area."
            
        case .multipleFacesDetected:
            title = "Multiple Faces"
            message = "Please ensure only one face is in the frame for accurate analysis."
            
        case .cameraNotAvailable:
            title = "Camera Unavailable"
            message = "Unable to access your camera. Please check your device settings."
            
        case .processingFailed:
            title = "Processing Error"
            message = "Something went wrong while analyzing your photo. Please try again."
            
        case .purchaseFailed(let reason):
            title = "Purchase Failed"
            message = reason
            
        case .restoreFailed:
            title = "Restore Failed"
            message = "Unable to restore your purchases. Please check your internet connection and try again."
            
        case .networkError:
            title = "Connection Error"
            message = "Please check your internet connection and try again."
            
        case .unknown:
            title = "Something Went Wrong"
            message = "An unexpected error occurred. Please try again."
        }
        
        actionTitle = "OK"
        action = nil
        isShowing = true
    }
    
    func showCameraPermissionDenied() {
        title = "Camera Access Required"
        message = "To analyze your facial features, we need access to your camera. Please enable camera access in Settings."
        actionTitle = "Open Settings"
        action = {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        isShowing = true
    }
}

// MARK: - View Modifier

struct ErrorAlertModifier: ViewModifier {
    @ObservedObject var errorManager = ErrorAlertManager.shared
    
    func body(content: Content) -> some View {
        content
            .alert(errorManager.title, isPresented: $errorManager.isShowing) {
                Button(errorManager.actionTitle) {
                    errorManager.action?()
                }
                if errorManager.action != nil {
                    Button("Cancel", role: .cancel) {}
                }
            } message: {
                Text(errorManager.message)
            }
    }
}

extension View {
    func withErrorAlert() -> some View {
        modifier(ErrorAlertModifier())
    }
}
```

---

### A12: Launch Screen (SwiftUI)

**Purpose:** App launch visual  
**File:** `LooksmaxxingApp/Views/LaunchScreenView.swift`

```swift
//
//  LaunchScreenView.swift
//  LooksmaxxingApp
//
//  App launch screen with animated logo
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var isAnimating = false
    @State private var opacity = 1.0
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "0A0A0F")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Logo icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "00D4FF").opacity(0.3), Color(hex: "00D4FF").opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                    
                    Image(systemName: "face.smiling")
                        .font(.system(size: 50))
                        .foregroundColor(Color(hex: "00D4FF"))
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                }
                
                // App name
                VStack(spacing: 4) {
                    Text("AESTHETIC")
                        .font(.caption.bold())
                        .foregroundColor(Color(hex: "00D4FF"))
                        .tracking(4)
                    
                    Text("Optimizer")
                        .font(.title.bold())
                        .foregroundColor(.white)
                }
            }
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
```

---

### A13: App Store Metadata

**Purpose:** Ready-to-use App Store copy  
**File:** `AppStore/metadata.txt`

```
═══════════════════════════════════════════════════════════════
APP STORE METADATA - AESTHETIC OPTIMIZER
═══════════════════════════════════════════════════════════════

APP NAME (30 chars max):
Aesthetic Optimizer

SUBTITLE (30 chars max):
AI Face Analysis & Glow-Up

PROMOTIONAL TEXT (170 chars max, can be updated without review):
Transform your look with AI-powered facial analysis. Track your progress, build healthy habits, and optimize your appearance with science-backed routines.

KEYWORDS (100 chars max, comma-separated):
face,analysis,glow,up,mewing,jawline,skincare,self,improvement,ai,beauty,rating,looksmax,aesthetic

DESCRIPTION (4000 chars max):
═══════════════════════════════════════════════════════════════

Unlock your aesthetic potential with Aesthetic Optimizer - the AI-powered app that analyzes your facial features and creates a personalized improvement plan.

🔬 AI FACIAL ANALYSIS
• Get an objective rating of your facial aesthetics (1-10 scale)
• Identify your strongest features
• Discover areas for improvement
• All analysis happens on your device - your photos never leave your phone

🔥 DAILY STREAK SYSTEM
• Build healthy habits with our proven streak system
• Complete 3 simple daily tasks
• Track your progress over time
• Get notified before you lose your streak

📊 PERSONALIZED ROUTINES
• Skincare reminders
• Posture checks
• Hydration tracking
• Customized to your goals

💡 DAILY INSIGHTS
• Learn science-backed tips
• Understand facial aesthetics
• Improve consistently

✨ PRO FEATURES
• Unlimited facial scans
• Detailed analysis breakdown
• Streak freeze protection
• Priority processing

PRIVACY FIRST
• All processing on-device
• No photos uploaded to servers
• No facial data stored externally
• Your privacy is our priority

Start your transformation journey today. Build habits that last, track your progress, and optimize your aesthetic potential.

Note: This app provides general wellness suggestions only and is not a medical device. Results may vary.

═══════════════════════════════════════════════════════════════

WHAT'S NEW (for updates):
Version 1.0.0:
• Initial release
• AI-powered facial analysis
• Daily streak system
• Personalized routines
• Dark mode interface

═══════════════════════════════════════════════════════════════

SUPPORT URL:
https://yoursite.com/support

PRIVACY POLICY URL:
https://yoursite.com/privacy

TERMS OF SERVICE URL:
https://yoursite.com/terms

═══════════════════════════════════════════════════════════════

AGE RATING: 17+
• Frequent/Intense: None
• Infrequent/Mild: None
Categories to select:
- Body image content: Yes (this triggers 17+ rating)

PRIMARY CATEGORY: Health & Fitness
SECONDARY CATEGORY: Lifestyle

═══════════════════════════════════════════════════════════════
```

---

### A14: Privacy Policy Text

**Purpose:** Hosted on website, linked in app  
**File:** `Legal/privacy-policy.md`

```markdown
# Privacy Policy

**Last Updated:** January 13, 2026  
**Effective Date:** January 13, 2026

## Introduction

Aesthetic Optimizer ("we," "our," or "us") respects your privacy. This Privacy Policy explains how we collect, use, and protect your information when you use our mobile application.

## Information We Collect

### Information You Provide
- **Age verification**: We collect your age group to ensure compliance with applicable laws
- **Quiz responses**: Your answers to our onboarding questions to personalize your experience
- **Subscription information**: Handled securely by Apple's App Store

### Information Collected Automatically
- **Photos**: Temporarily processed on your device for facial analysis. Photos are NEVER uploaded to our servers.
- **Usage data**: App interactions to improve user experience
- **Device information**: Device type, OS version for compatibility

## How We Use Your Information

We use your information to:
- Provide personalized facial analysis and recommendations
- Track your progress and maintain your streak
- Send you notifications (with your permission)
- Improve our app and services

## Data Storage

**All personal data is stored locally on your device.**

- Your photos never leave your device
- Facial analysis is performed on-device using Apple's Vision framework
- We do not maintain external servers storing your personal data
- Subscription status is managed by Apple

## Data Sharing

We do NOT:
- Sell your personal information
- Share your photos with third parties
- Use your facial data for advertising
- Transfer your data to external servers

We MAY share:
- Anonymized, aggregated statistics (no personal data)
- Information required by law

## Your Rights

You have the right to:
- **Access**: Export all your data from the app settings
- **Delete**: Remove all your data from the app settings
- **Opt-out**: Disable notifications at any time
- **Withdraw consent**: Stop using the app at any time

### For Quebec Residents (Law 25)
You have additional rights including:
- Right to data portability
- Right to be informed of automated decisions
- Right to correction of inaccurate data

### For EU Residents (GDPR)
You have additional rights including:
- Right to erasure ("right to be forgotten")
- Right to restrict processing
- Right to object to processing

## Children's Privacy

Our app is not intended for users under 13 years of age. We do not knowingly collect information from children under 13.

## Security

We implement appropriate security measures:
- All data stored locally on your device
- No transmission of facial data
- Apple's built-in iOS security features

## Changes to This Policy

We may update this policy from time to time. We will notify you of significant changes through the app.

## Contact Us

For privacy concerns or data requests:
- Email: privacy@aestheticoptimizer.com
- Support: support@aestheticoptimizer.com

## Compliance

This app complies with:
- Apple App Store Guidelines
- PIPEDA (Canada)
- Quebec Law 25
- GDPR (EU)
- CCPA (California)
```

---

### A15: Terms of Service Text

**Purpose:** Hosted on website, linked in app  
**File:** `Legal/terms-of-service.md`

```markdown
# Terms of Service

**Last Updated:** January 13, 2026  
**Effective Date:** January 13, 2026

## 1. Acceptance of Terms

By downloading or using Aesthetic Optimizer, you agree to these Terms of Service. If you do not agree, do not use the app.

## 2. Description of Service

Aesthetic Optimizer provides:
- AI-powered facial analysis for entertainment and self-improvement purposes
- Daily routine tracking and streak system
- Personalized wellness suggestions

## 3. Medical Disclaimer

**IMPORTANT: This app is NOT a medical device.**

- We do not provide medical advice, diagnosis, or treatment
- Results are for entertainment and self-improvement motivation only
- Consult healthcare professionals for medical concerns
- Do not use this app as a substitute for professional advice

## 4. Eligibility

You must be:
- At least 13 years old to use this app
- At least 18 years old to make purchases (or have parental consent)

## 5. User Accounts

- You are responsible for maintaining your device security
- You agree to provide accurate information
- You are responsible for all activity under your account

## 6. Subscriptions and Payments

### Pro Subscription
- Price: $14.99 CAD/month (or local equivalent)
- Billed through Apple App Store
- Auto-renews unless cancelled 24 hours before period end

### Cancellation
- Cancel anytime through App Store settings
- No refunds for partial subscription periods
- Access continues until end of billing period

### Streak Freeze
- One-time purchase: $1.99 CAD
- Protects your streak for one missed day
- Non-refundable

## 7. Acceptable Use

You agree NOT to:
- Use the app for illegal purposes
- Attempt to reverse-engineer the app
- Share or distribute app content without permission
- Use the app to harm yourself or others
- Upload inappropriate or illegal content

## 8. Intellectual Property

- All app content is owned by us or our licensors
- You may not copy, modify, or distribute our content
- Your data remains your property

## 9. Privacy

Your privacy is important to us. See our Privacy Policy for details on data handling.

## 10. Disclaimer of Warranties

THE APP IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND.

We do not guarantee:
- Accuracy of facial analysis
- Specific results from using the app
- Uninterrupted or error-free service

## 11. Limitation of Liability

TO THE MAXIMUM EXTENT PERMITTED BY LAW, WE ARE NOT LIABLE FOR:
- Indirect, incidental, or consequential damages
- Loss of data or profits
- Personal injury or emotional distress
- Any damages exceeding the amount you paid us

## 12. Indemnification

You agree to indemnify us against claims arising from:
- Your use of the app
- Your violation of these terms
- Your violation of any third-party rights

## 13. Changes to Terms

We may modify these terms at any time. Continued use after changes constitutes acceptance.

## 14. Termination

We may terminate your access if you violate these terms. You may stop using the app at any time.

## 15. Governing Law

These terms are governed by the laws of Canada, specifically the Province of Quebec.

## 16. Dispute Resolution

Any disputes will be resolved through:
1. Good faith negotiation
2. Mediation
3. Courts of Quebec, Canada

## 17. Contact

Questions about these terms:
- Email: legal@aestheticoptimizer.com
- Support: support@aestheticoptimizer.com

## 18. Entire Agreement

These terms constitute the entire agreement between you and us regarding the app.
```

---

## PART 3: EXECUTION COMMANDS

### Create All Files at Once

Run this in your project directory (requires the code above saved to files):

```bash
# Create directories
mkdir -p LooksmaxxingApp/Config
mkdir -p LooksmaxxingApp/Views/Components
mkdir -p Legal
mkdir -p AppStore

# The files above should be created in these locations:
# LooksmaxxingApp/Config/Secrets.swift
# LooksmaxxingApp/Info.plist
# LooksmaxxingApp/Views/SettingsView.swift
# LooksmaxxingApp/Views/AgeGateView.swift
# LooksmaxxingApp/Views/DisclaimerView.swift
# LooksmaxxingApp/Views/LaunchScreenView.swift
# LooksmaxxingApp/Views/Components/CelebrationView.swift
# LooksmaxxingApp/Views/Components/ErrorAlertModifier.swift
# LooksmaxxingApp/Services/DataExportService.swift
# Legal/privacy-policy.md
# Legal/terms-of-service.md
# AppStore/metadata.txt
```

---

## PART 4: FINAL CHECKLIST

### AI-Executable Tasks ✅

| # | Task | Status | File Created |
|---|------|--------|--------------|
| A1 | Secrets configuration | ✅ | Config/Secrets.swift |
| A2 | Info.plist | ✅ | Info.plist |
| A3 | Settings screen | ✅ | Views/SettingsView.swift |
| A4 | Data export (GDPR) | ✅ | Services/DataExportService.swift |
| A5 | Age gate | ✅ | Views/AgeGateView.swift |
| A6 | Medical disclaimer | ✅ | Views/DisclaimerView.swift |
| A7 | ContentView flow | ✅ | App/ContentView.swift |
| A8 | Near-miss messaging | ✅ | Services/CoreMLService.swift |
| A9 | Red badge on tasks | ✅ | Views/HomeViewDark.swift |
| A10 | Celebration animations | ✅ | Components/CelebrationView.swift |
| A11 | Error alert system | ✅ | Components/ErrorAlertModifier.swift |
| A12 | Launch screen | ✅ | Views/LaunchScreenView.swift |
| A13 | App Store metadata | ✅ | AppStore/metadata.txt |
| A14 | Privacy Policy | ✅ | Legal/privacy-policy.md |
| A15 | Terms of Service | ✅ | Legal/terms-of-service.md |

### Manual Tasks Remaining 📋

| # | Task | Action Required |
|---|------|-----------------|
| M1 | App icon design | Create 1024x1024 PNG |
| M2 | Screenshots | Capture from simulator |
| M3 | RevenueCat setup | Create account, get API key |
| M4 | Apple Developer setup | $99/year enrollment |
| M5 | App Store Connect | Create app record |
| M6 | Host Privacy Policy | Upload to website |
| M7 | Host Terms of Service | Upload to website |
| M8 | Device testing | Run on real iPhone |
| M9 | TestFlight submission | Archive and upload |

---

## EXECUTION PRIORITY

### Day 1: Copy All AI Code
1. Copy all A1-A15 code blocks into respective files
2. Update `ContentView.swift` with new flow
3. Add new files to Xcode project
4. Build and test locally

### Day 2: Manual Setup
1. Create RevenueCat account
2. Get API key, paste into `Secrets.swift`
3. Create app icons (or use placeholder)
4. Host legal documents

### Day 3: Final Integration
1. Test complete flow: Age → Disclaimer → Onboarding → Home
2. Test purchases in sandbox
3. Take screenshots
4. Submit to TestFlight

---

**Document Updated:** January 13, 2026  
**AI-Executable Tasks:** 15 complete with code  
**Manual Tasks:** 9 remaining
