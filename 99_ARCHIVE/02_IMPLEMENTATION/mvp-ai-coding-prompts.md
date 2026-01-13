# MVP AI Coding Prompts: Ready-to-Use Implementation Guide

**Date:** January 12, 2026  
**Purpose:** Direct prompts for AI coding agents (Claude Code, Cursor, etc.)  
**Format:** Copy-paste ready prompts for rapid MVP build

---

## QUICK START: Build Order

**Total Time:** 12-18 hours (1-2 days with AI coding)

**Sequence:**
1. Project Setup (Prompt 1) - 30 min
2. Core Data Model (Prompt 2) - 1 hour
3. Onboarding (Prompt 3) - 1 hour
4. Camera + AI (Prompt 4-5) - 3 hours
5. Results + Paywall (Prompt 6-7) - 2 hours
6. Daily Routine + Streak (Prompt 8-9) - 3 hours
7. Home View + Navigation (Prompt 10) - 1 hour
8. Notifications (Prompt 11) - 1 hour
9. RevenueCat Integration (Prompt 12) - 2 hours
10. Polish + Testing (Prompt 13) - 1 hour

---

## PROMPT 1: Project Setup & Structure

**Copy this prompt to your AI coding agent:**

```
Create a new iOS SwiftUI app project called "LooksmaxxingApp" with the following structure:

Project Structure:
LooksmaxxingApp/
├── App/
│   └── LooksmaxxingApp.swift (main app file)
├── Views/
│   ├── OnboardingView.swift
│   ├── CameraView.swift
│   ├── ProcessingView.swift
│   ├── ResultsView.swift
│   ├── DailyRoutineView.swift
│   ├── PaywallView.swift
│   └── HomeView.swift
├── ViewModels/
│   ├── ScanViewModel.swift
│   ├── StreakViewModel.swift
│   └── SubscriptionViewModel.swift
├── Models/
│   ├── FaceAnalysis.swift
│   ├── Streak.swift (Core Data entity)
│   ├── DailyTask.swift (Core Data entity)
│   └── UserPreferences.swift
├── Services/
│   ├── CoreMLService.swift
│   ├── CoreDataManager.swift
│   ├── RevenueCatService.swift
│   └── NotificationService.swift
├── Resources/
│   ├── Assets.xcassets
│   └── CoreData/
│       └── LooksmaxxingApp.xcdatamodeld
└── Utilities/
    └── Extensions/
        ├── UserDefaults+Extensions.swift

Requirements:
- iOS 15.0+ target
- SwiftUI for all UI
- MVVM architecture pattern
- Core Data for local storage
- Swift Package Manager for dependencies

Dependencies to add:
1. RevenueCat SDK: https://github.com/RevenueCat/purchases-ios
2. Firebase iOS SDK (optional): https://github.com/firebase/firebase-ios-sdk

Create the basic file structure with empty implementations. Use @main for app entry point.
```

---

## PROMPT 2: Core Data Model

**Copy this prompt to your AI coding agent:**

```
Create a Core Data model file (LooksmaxxingApp.xcdatamodeld) with the following entities:

Entity 1: Streak
Attributes:
- currentStreak: Int16 (default: 0)
- lastCompletionDate: Date? (optional)
- totalDays: Int16 (default: 0)
- id: UUID (default: generate new)

Entity 2: DailyTask
Attributes:
- taskType: String (water, skincare, posture)
- completedDate: Date
- isCompleted: Bool (default: false)
- id: UUID (default: generate new)

Entity 3: FaceAnalysis
Attributes:
- rating: Double (1.0-10.0)
- strengths: Transformable ([String]) - store as NSSet
- weaknesses: Transformable ([String]) - store as NSSet
- scanDate: Date
- frontImage: Data? (optional, local only)
- sideImage: Data? (optional, local only)
- id: UUID (default: generate new)

Then create CoreDataManager.swift singleton class:

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LooksmaxxingApp")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("Core Data save error: \(nsError)")
            }
        }
    }
    
    // Fetch methods
    func fetchStreak() -> Streak? {
        let request: NSFetchRequest<Streak> = Streak.fetchRequest()
        request.fetchLimit = 1
        return try? viewContext.fetch(request).first
    }
    
    func createOrUpdateStreak(currentStreak: Int, lastCompletion: Date) {
        let streak = fetchStreak() ?? Streak(context: viewContext)
        streak.currentStreak = Int16(currentStreak)
        streak.lastCompletionDate = lastCompletion
        streak.totalDays += 1
        saveContext()
    }
    
    func fetchDailyTasks(for date: Date) -> [DailyTask] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let request: NSFetchRequest<DailyTask> = DailyTask.fetchRequest()
        request.predicate = NSPredicate(format: "completedDate >= %@ AND completedDate < %@", startOfDay as NSDate, endOfDay as NSDate)
        return (try? viewContext.fetch(request)) ?? []
    }
    
    func createDailyTask(type: String, completed: Bool) {
        let task = DailyTask(context: viewContext)
        task.taskType = type
        task.completedDate = Date()
        task.isCompleted = completed
        task.id = UUID()
        saveContext()
    }
    
    func fetchFaceAnalyses() -> [FaceAnalysis] {
        let request: NSFetchRequest<FaceAnalysis> = FaceAnalysis.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "scanDate", ascending: false)]
        return (try? viewContext.fetch(request)) ?? []
    }
    
    func createFaceAnalysis(rating: Double, strengths: [String], weaknesses: [String], frontImage: Data?, sideImage: Data?) {
        let analysis = FaceAnalysis(context: viewContext)
        analysis.rating = rating
        analysis.strengths = NSSet(array: strengths)
        analysis.weaknesses = NSSet(array: weaknesses)
        analysis.scanDate = Date()
        analysis.frontImage = frontImage
        analysis.sideImage = sideImage
        analysis.id = UUID()
        saveContext()
    }
}

All Core Data operations must be thread-safe. Use @MainActor for UI updates.
```

---

## PROMPT 3: UserDefaults Extension & Device ID

**Copy this prompt to your AI coding agent:**

```
Create UserDefaults+Extensions.swift:

extension UserDefaults {
    private enum Keys {
        static let deviceID = "deviceID"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let lastScanDate = "lastScanDate"
        static let notificationTime = "notificationTime"
        static let isProUser = "isProUser"
    }
    
    var deviceID: String {
        get {
            if let id = string(forKey: Keys.deviceID) {
                return id
            }
            let newID = UUID().uuidString
            set(newID, forKey: Keys.deviceID)
            return newID
        }
    }
    
    var hasCompletedOnboarding: Bool {
        get { bool(forKey: Keys.hasCompletedOnboarding) }
        set { set(newValue, forKey: Keys.hasCompletedOnboarding) }
    }
    
    var lastScanDate: Date? {
        get { object(forKey: Keys.lastScanDate) as? Date }
        set { set(newValue, forKey: Keys.lastScanDate) }
    }
    
    var notificationTime: Date {
        get {
            if let time = object(forKey: Keys.notificationTime) as? Date {
                return time
            }
            // Default: 8 AM
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: Date())
            components.hour = 8
            components.minute = 0
            return calendar.date(from: components) ?? Date()
        }
        set { set(newValue, forKey: Keys.notificationTime) }
    }
    
    func canScanToday() -> Bool {
        guard let lastScan = lastScanDate else { return true }
        let daysSinceLastScan = Calendar.current.dateComponents([.day], from: lastScan, to: Date()).day ?? 0
        return daysSinceLastScan >= 7
    }
}

This provides device ID generation and scan limit checking for free users.
```

---

## PROMPT 4: Onboarding View

**Copy this prompt to your AI coding agent:**

```
Create OnboardingView.swift with two screens:

Screen 1 - Welcome:
- App name "Aesthetic Optimizer" at top (large, bold)
- Subtitle "AI Facial Analysis & Self-Improvement"
- Description text: "Get your AI facial analysis in seconds"
- Large "Continue" button at bottom (primary color, rounded corners)
- On tap: Navigate to Screen 2

Screen 2 - Permissions:
- Title: "Camera Access Required"
- Description: "We need camera access to analyze your face"
- Privacy note: "All processing happens on your device (privacy-first)"
- Privacy note: "Your photos are never uploaded to our servers"
- Large "Allow Camera" button (primary color)
- On tap: Request camera permission using AVCaptureDevice.requestAccess(for: .video)
- If granted: Set UserDefaults.hasCompletedOnboarding = true, navigate to CameraView
- If denied: Show alert with message "Camera access is required. Please enable in Settings." and button to open Settings

Use NavigationStack for navigation. Add smooth transitions. Use @AppStorage for hasCompletedOnboarding state.

Code structure:
struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentScreen = 0
    @State private var showPermissionAlert = false
    
    var body: some View {
        NavigationStack {
            if currentScreen == 0 {
                WelcomeScreen(onContinue: { currentScreen = 1 })
            } else {
                PermissionsScreen(
                    onAllow: requestCameraPermission,
                    showAlert: $showPermissionAlert
                )
            }
        }
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    hasCompletedOnboarding = true
                } else {
                    showPermissionAlert = true
                }
            }
        }
    }
}

Make it visually appealing with proper spacing, colors, and animations.
```

---

## PROMPT 5: Camera View & Face Capture

**Copy this prompt to your AI coding agent:**

```
Create CameraView.swift that:

1. Uses AVFoundation to show live camera preview
2. Has face detection overlay (optional, use VNDetectFaceRectanglesRequest)
3. Two capture buttons:
   - "Take Front Photo" (captures front-facing selfie)
   - "Take Side Photo" (captures side profile)
4. After both photos captured:
   - Show ProcessingView
   - Process images using CoreMLService
   - Navigate to ResultsView with analysis

Implementation details:
- Use AVCaptureSession for camera
- Use AVCapturePhotoOutput for photo capture
- Store captured images temporarily
- Convert to UIImage for processing
- Handle camera permissions (check before showing)
- Handle camera unavailable errors
- Show loading state during capture

Code structure:
class CameraViewModel: ObservableObject {
    @Published var frontImage: UIImage?
    @Published var sideImage: UIImage?
    @Published var isProcessing = false
    @Published var showProcessing = false
    
    func captureFrontPhoto() { /* AVFoundation capture */ }
    func captureSidePhoto() { /* AVFoundation capture */ }
    func processImages() { /* Call CoreMLService */ }
}

struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    @StateObject private var scanViewModel = ScanViewModel()
    
    var body: some View {
        ZStack {
            CameraPreview(session: viewModel.captureSession)
            VStack {
                Spacer()
                HStack {
                    Button("Take Front Photo") { viewModel.captureFrontPhoto() }
                    Button("Take Side Photo") { viewModel.captureSidePhoto() }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showProcessing) {
            ProcessingView()
        }
    }
}

Handle all camera errors gracefully. Show user-friendly error messages.
```

---

## PROMPT 6: Core ML Service (Mocked for MVP)

**Copy this prompt to your AI coding agent:**

```
Create CoreMLService.swift with MOCKED rating algorithm (for MVP speed):

class CoreMLService {
    static let shared = CoreMLService()
    
    // Predefined lists for strengths/weaknesses
    private let strengths = [
        "Strong jawline definition",
        "Symmetrical facial features",
        "Clear, healthy skin",
        "Well-proportioned face",
        "Defined cheekbones",
        "Balanced eye spacing"
    ]
    
    private let weaknesses = [
        "Improve jawline definition",
        "Enhance skin clarity",
        "Balance facial symmetry",
        "Optimize eye spacing",
        "Refine facial proportions",
        "Strengthen cheekbone definition"
    ]
    
    func analyzeFace(frontImage: UIImage, sideImage: UIImage) async throws -> FaceAnalysisResult {
        let startTime = Date()
        
        // Use Vision framework to detect face landmarks
        guard let frontCGImage = frontImage.cgImage else {
            throw CoreMLError.invalidImage
        }
        
        let request = VNDetectFaceLandmarksRequest()
        let handler = VNImageRequestHandler(cgImage: frontCGImage, options: [:])
        
        try handler.perform([request])
        
        guard let observation = request.results?.first else {
            throw CoreMLError.noFaceDetected
        }
        
        // Calculate basic metrics (mocked for MVP)
        let faceWidth = observation.boundingBox.width
        let faceHeight = observation.boundingBox.height
        let aspectRatio = faceWidth / faceHeight
        
        // Simple heuristic-based rating (can replace with real Core ML later)
        var baseRating = 7.0
        
        // Adjust based on face metrics (simplified)
        if aspectRatio > 0.7 && aspectRatio < 0.8 {
            baseRating += 0.5 // Good proportions
        }
        
        // Add variable reward (randomization ±0.2)
        let randomVariation = Double.random(in: -0.2...0.2)
        let finalRating = min(10.0, max(1.0, baseRating + randomVariation))
        
        // Select random strengths/weaknesses
        let selectedStrengths = strengths.shuffled().prefix(3)
        let selectedWeaknesses = weaknesses.shuffled().prefix(3)
        
        let processingTime = Date().timeIntervalSince(startTime)
        
        return FaceAnalysisResult(
            rating: finalRating,
            strengths: Array(selectedStrengths),
            weaknesses: Array(selectedWeaknesses),
            processingTime: processingTime
        )
    }
}

struct FaceAnalysisResult {
    let rating: Double
    let strengths: [String]
    let weaknesses: [String]
    let processingTime: TimeInterval
}

enum CoreMLError: Error {
    case invalidImage
    case noFaceDetected
    case processingTimeout
}

Processing must complete in <1 second. Use async/await for non-blocking execution.
```

---

## PROMPT 7: Processing View (Loading Screen)

**Copy this prompt to your AI coding agent:**

```
Create ProcessingView.swift that shows AI is working:

struct ProcessingView: View {
    @State private var progress: Double = 0.0
    @State private var isComplete = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(width: 200)
                
                Text("Analyzing your face...")
                    .foregroundColor(.white)
                    .font(.headline)
                
                Text("\(Int(progress * 100))%")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .onAppear {
            animateProgress()
        }
    }
    
    private func animateProgress() {
        withAnimation(.linear(duration: 0.8)) {
            progress = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isComplete = true
        }
    }
}

This creates perceived speed (progress bar completes in <1 second even if processing is faster).
```

---

## PROMPT 8: Results View (Free Tier + Paywall Trigger)

**Copy this prompt to your AI coding agent:**

```
Create ResultsView.swift that displays face analysis results:

struct ResultsView: View {
    let analysis: FaceAnalysisResult
    @StateObject private var subscriptionVM = SubscriptionViewModel.shared
    @State private var showPaywall = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Rating display
                Text(String(format: "%.1f", analysis.rating))
                    .font(.system(size: 72, weight: .bold))
                    .foregroundColor(.primary)
                    .onAppear {
                        // Haptic feedback
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                    }
                
                Text("out of 10")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                // Strengths
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Top Strength")
                        .font(.headline)
                    Text(analysis.strengths.first ?? "")
                        .font(.body)
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
                
                // Weaknesses (blurred for free users)
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Top Weakness")
                        .font(.headline)
                    if subscriptionVM.isProUser {
                        Text(analysis.weaknesses.first ?? "")
                            .font(.body)
                            .foregroundColor(.orange)
                    } else {
                        ZStack {
                            Text(analysis.weaknesses.first ?? "")
                                .font(.body)
                                .foregroundColor(.orange)
                                .blur(radius: 8)
                            Text("Unlock to see")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
                
                // Action buttons
                if !subscriptionVM.isProUser {
                    Button(action: { showPaywall = true }) {
                        Text("Unlock detailed analysis")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                
                NavigationLink(destination: DailyRoutineView()) {
                    Text("See your daily routine")
                        .font(.body)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Your Analysis")
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .onAppear {
            // Save to Core Data
            CoreDataManager.shared.createFaceAnalysis(
                rating: analysis.rating,
                strengths: analysis.strengths,
                weaknesses: analysis.weaknesses,
                frontImage: nil, // Don't save images for MVP
                sideImage: nil
            )
            // Update last scan date
            UserDefaults.standard.lastScanDate = Date()
        }
    }
}

Add smooth animations for rating reveal. Use haptic feedback on appear.
```

---

## PROMPT 9: Daily Routine View (Micro-Commitments)

**Copy this prompt to your AI coding agent:**

```
Create DailyRoutineView.swift with 3 micro-tasks:

struct DailyRoutineView: View {
    @StateObject private var streakVM = StreakViewModel.shared
    @State private var completedTasks: Set<String> = []
    @State private var showDailyInsight = false
    
    private let tasks = ["water", "skincare", "posture"]
    private let taskNames = [
        "water": "Log water intake",
        "skincare": "Skincare reminder",
        "posture": "Posture check"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Streak counter
                HStack {
                    Text("🔥")
                        .font(.system(size: 40))
                    Text("\(streakVM.currentStreak) Day Streak")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
                
                // Tasks
                VStack(spacing: 15) {
                    ForEach(tasks, id: \.self) { task in
                        TaskRow(
                            taskName: taskNames[task] ?? "",
                            isCompleted: completedTasks.contains(task),
                            onTap: { toggleTask(task) }
                        )
                    }
                }
                
                // Completion message
                if completedTasks.count == 3 {
                    VStack(spacing: 10) {
                        Text("🎉 All tasks complete!")
                            .font(.headline)
                        Button("View Daily Insight") {
                            showDailyInsight = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                } else {
                    Text("Complete all 3 to maintain your streak")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Daily Routine")
        .sheet(isPresented: $showDailyInsight) {
            DailyInsightView()
        }
        .onAppear {
            loadTodayTasks()
        }
    }
    
    private func toggleTask(_ task: String) {
        if completedTasks.contains(task) {
            completedTasks.remove(task)
        } else {
            completedTasks.insert(task)
            // Haptic feedback
            let impact = UINotificationFeedbackGenerator()
            impact.notificationOccurred(.success)
            
            // Save to Core Data
            CoreDataManager.shared.createDailyTask(type: task, completed: true)
        }
        
        // Check if all tasks complete
        if completedTasks.count == 3 {
            streakVM.updateStreak()
            // Celebrate
            let impact = UINotificationFeedbackGenerator()
            impact.notificationOccurred(.success)
        }
    }
    
    private func loadTodayTasks() {
        let today = Date()
        let tasks = CoreDataManager.shared.fetchDailyTasks(for: today)
        completedTasks = Set(tasks.filter { $0.isCompleted }.map { $0.taskType })
    }
}

struct TaskRow: View {
    let taskName: String
    let isCompleted: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isCompleted ? .green : .gray)
                .font(.title2)
            Text(taskName)
                .font(.body)
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .onTapGesture {
            onTap()
        }
    }
}

Add animations for task completion. Show celebration when all 3 complete.
```

---

## PROMPT 10: Streak ViewModel (Retention Logic)

**Copy this prompt to your AI coding agent:**

```
Create StreakViewModel.swift that manages streak logic:

class StreakViewModel: ObservableObject {
    static let shared = StreakViewModel()
    
    @Published var currentStreak: Int = 0
    @Published var lastCompletionDate: Date?
    @Published var totalDays: Int = 0
    
    private let coreData = CoreDataManager.shared
    
    init() {
        loadStreak()
    }
    
    func loadStreak() {
        if let streak = coreData.fetchStreak() {
            currentStreak = Int(streak.currentStreak)
            lastCompletionDate = streak.lastCompletionDate
            totalDays = Int(streak.totalDays)
        }
    }
    
    func updateStreak() {
        let today = Date()
        let calendar = Calendar.current
        
        // Check if user completed all 3 tasks today
        let todayTasks = coreData.fetchDailyTasks(for: today)
        let completedCount = todayTasks.filter { $0.isCompleted }.count
        
        guard completedCount >= 3 else {
            // Not all tasks complete, don't update streak
            return
        }
        
        // Check if within 24-hour window
        if let lastCompletion = lastCompletionDate {
            let hoursSinceLastCompletion = calendar.dateComponents([.hour], from: lastCompletion, to: today).hour ?? 0
            
            if hoursSinceLastCompletion <= 24 {
                // Within window, increment streak
                currentStreak += 1
            } else {
                // Outside window, reset streak
                currentStreak = 1
            }
        } else {
            // First completion
            currentStreak = 1
        }
        
        // Update Core Data
        coreData.createOrUpdateStreak(
            currentStreak: currentStreak,
            lastCompletion: today
        )
        
        lastCompletionDate = today
        totalDays += 1
    }
    
    func canMaintainStreak() -> Bool {
        guard let lastCompletion = lastCompletionDate else { return true }
        let hoursSinceLastCompletion = Calendar.current.dateComponents([.hour], from: lastCompletion, to: Date()).hour ?? 0
        return hoursSinceLastCompletion <= 24
    }
    
    func getStreakFreezeAvailable() -> Bool {
        // Streak is at risk if >24h since last completion
        return !canMaintainStreak() && currentStreak > 0
    }
    
    func resetStreak() {
        currentStreak = 0
        lastCompletionDate = nil
        // Update Core Data
        if let streak = coreData.fetchStreak() {
            streak.currentStreak = 0
            streak.lastCompletionDate = nil
            coreData.saveContext()
        }
    }
}

All operations must be thread-safe. Use @MainActor for UI updates.
```

---

## PROMPT 11: Subscription ViewModel & RevenueCat

**Copy this prompt to your AI coding agent:**

```
Create SubscriptionViewModel.swift with RevenueCat integration:

import RevenueCat
import StoreKit

class SubscriptionViewModel: ObservableObject {
    static let shared = SubscriptionViewModel()
    
    @Published var isProUser: Bool = false
    @Published var subscriptionStatus: SubscriptionStatus = .free
    @Published var availableProducts: [StoreProduct] = []
    @Published var isLoading: Bool = false
    
    enum SubscriptionStatus {
        case free
        case pro
        case trial
    }
    
    private init() {
        configureRevenueCat()
    }
    
    func configureRevenueCat() {
        Purchases.configure(withAPIKey: "YOUR_REVENUECAT_API_KEY")
        Purchases.shared.delegate = self
        checkSubscriptionStatus()
        loadProducts()
    }
    
    func checkSubscriptionStatus() {
        Purchases.shared.getCustomerInfo { [weak self] customerInfo, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let error = error {
                    print("RevenueCat error: \(error.localizedDescription)")
                    return
                }
                
                // Check for Pro entitlement
                if customerInfo?.entitlements["pro"]?.isActive == true {
                    self.isProUser = true
                    self.subscriptionStatus = .pro
                } else {
                    self.isProUser = false
                    self.subscriptionStatus = .free
                }
                
                // Update UserDefaults
                UserDefaults.standard.set(self.isProUser, forKey: "isProUser")
            }
        }
    }
    
    func loadProducts() {
        Purchases.shared.getOfferings { [weak self] offerings, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let packages = offerings?.current?.availablePackages {
                    // Store products for display
                    // Implementation depends on RevenueCat structure
                }
            }
        }
    }
    
    func purchaseSubscription(productId: String) {
        isLoading = true
        Purchases.shared.purchase(package: package) { transaction, customerInfo, error, userCancelled in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    print("Purchase error: \(error.localizedDescription)")
                    return
                }
                
                if userCancelled {
                    return
                }
                
                // Check entitlement
                if customerInfo?.entitlements["pro"]?.isActive == true {
                    self.isProUser = true
                    self.subscriptionStatus = .pro
                }
            }
        }
    }
    
    func purchaseStreakFreeze() {
        // Purchase non-consumable IAP
        // Product ID: "streak_freeze"
        // Price: $1.99 CAD
    }
    
    func restorePurchases() {
        isLoading = true
        Purchases.shared.restorePurchases { customerInfo, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    print("Restore error: \(error.localizedDescription)")
                    return
                }
                self.checkSubscriptionStatus()
            }
        }
    }
}

extension SubscriptionViewModel: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        checkSubscriptionStatus()
    }
}

Replace "YOUR_REVENUECAT_API_KEY" with actual API key from RevenueCat dashboard.
```

---

## PROMPT 12: Paywall View

**Copy this prompt to your AI coding agent:**

```
Create PaywallView.swift for subscription offer:

struct PaywallView: View {
    @StateObject private var subscriptionVM = SubscriptionViewModel.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Text("Unlock Pro Features")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Get unlimited scans and detailed analysis")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                // Features list
                VStack(alignment: .leading, spacing: 15) {
                    FeatureRow(icon: "infinity", text: "Unlimited facial scans")
                    FeatureRow(icon: "chart.bar", text: "Detailed analysis with all insights")
                    FeatureRow(icon: "shield", text: "Streak freeze protection")
                    FeatureRow(icon: "sparkles", text: "Priority AI processing")
                }
                .padding()
                
                Spacer()
                
                // Pricing
                VStack(spacing: 10) {
                    Text("$14.99")
                        .font(.system(size: 48, weight: .bold))
                    Text("per month")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Purchase button
                Button(action: {
                    subscriptionVM.purchaseSubscription(productId: "pro_monthly")
                }) {
                    Text("Subscribe to Pro")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .disabled(subscriptionVM.isLoading)
                
                // Cancel button
                Button(action: { dismiss() }) {
                    Text("No thanks")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 20)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .onChange(of: subscriptionVM.isProUser) { isPro in
            if isPro {
                dismiss()
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            Text(text)
                .font(.body)
            Spacer()
        }
    }
}

No dark patterns. Clear pricing. Easy cancellation.
```

---

## PROMPT 13: Home View (Daily Entry Point)

**Copy this prompt to your AI coding agent:**

```
Create HomeView.swift as the main daily entry point:

struct HomeView: View {
    @StateObject private var streakVM = StreakViewModel.shared
    @StateObject private var subscriptionVM = SubscriptionViewModel.shared
    @State private var showPaywall = false
    @State private var showCamera = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // Streak counter
                    HStack {
                        Text("🔥")
                            .font(.system(size: 50))
                        VStack(alignment: .leading) {
                            Text("\(streakVM.currentStreak)")
                                .font(.system(size: 48, weight: .bold))
                            Text("Day Streak")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(16)
                    
                    // Main actions
                    VStack(spacing: 15) {
                        // Scan button
                        Button(action: {
                            if subscriptionVM.isProUser || UserDefaults.standard.canScanToday() {
                                showCamera = true
                            } else {
                                showPaywall = true
                            }
                        }) {
                            VStack(spacing: 10) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 40))
                                Text("Scan Face")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(Color.blue)
                            .cornerRadius(16)
                        }
                        
                        // Daily routine button
                        NavigationLink(destination: DailyRoutineView()) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Daily Routine")
                                    .font(.headline)
                            }
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    
                    // Progress section
                    if let lastAnalysis = CoreDataManager.shared.fetchFaceAnalyses().first {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Your Progress")
                                .font(.headline)
                            HStack {
                                Text("Last scan: \(lastAnalysis.rating, specifier: "%.1f")/10")
                                    .font(.body)
                                Spacer()
                                Text(lastAnalysis.scanDate, style: .relative)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    // Pro upgrade banner (if free)
                    if !subscriptionVM.isProUser {
                        Button(action: { showPaywall = true }) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text("Upgrade to Pro for unlimited scans")
                                    .font(.subheadline)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.primary)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
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
            .onAppear {
                streakVM.loadStreak()
                subscriptionVM.checkSubscriptionStatus()
            }
        }
    }
}

Refresh data on appear. Show empty state if no scans yet.
```

---

## PROMPT 14: Notification Service

**Copy this prompt to your AI coding agent:**

```
Create NotificationService.swift for push notifications:

import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Routine Reminder"
        content.body = "Time for your daily routine! Maintain your streak"
        content.sound = .default
        content.categoryIdentifier = "DAILY_ROUTINE"
        
        // Schedule for user's preferred time (default 8 AM)
        let notificationTime = UserDefaults.standard.notificationTime
        let calendar = Calendar.current
        var components = calendar.dateComponents([.hour, .minute], from: notificationTime)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification scheduling error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleStreakAtRisk() {
        // Schedule for 8 PM if tasks not completed
        let content = UNMutableNotificationContent()
        content.title = "Streak at Risk!"
        content.body = "Your streak is at risk! Complete today's routine in 4 hours"
        content.sound = .default
        
        var components = DateComponents()
        components.hour = 20 // 8 PM
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "streak_at_risk", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification scheduling error: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func updateNotificationTime(_ time: Date) {
        UserDefaults.standard.notificationTime = time
        cancelAllNotifications()
        scheduleDailyReminder()
        scheduleStreakAtRisk()
    }
}

Set up UNUserNotificationCenterDelegate in App file to handle notification taps.
```

---

## PROMPT 15: App Entry Point & Navigation

**Copy this prompt to your AI coding agent:**

```
Create LooksmaxxingApp.swift (main app file):

import SwiftUI

@main
struct LooksmaxxingApp: App {
    @StateObject private var coreData = CoreDataManager.shared
    @StateObject private var subscriptionVM = SubscriptionViewModel.shared
    @StateObject private var streakVM = StreakViewModel.shared
    
    init() {
        // Initialize services
        setupApp()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(subscriptionVM)
                .environmentObject(streakVM)
                .environment(\.managedObjectContext, coreData.viewContext)
        }
    }
    
    private func setupApp() {
        // Request notification permission (after first scan, not on launch)
        // NotificationService.shared.requestPermission()
        
        // Configure RevenueCat (handled in SubscriptionViewModel)
        // subscriptionVM.configureRevenueCat()
    }
}

Create ContentView.swift that handles navigation:

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        if hasCompletedOnboarding {
            HomeView()
        } else {
            OnboardingView()
        }
    }
}

Handle deep links and notification taps in App file.
```

---

## PROMPT 16: Error Handling & Edge Cases

**Copy this prompt to your AI coding agent:**

```
Add comprehensive error handling throughout the app:

1. Camera errors:
   - Permission denied: Show alert with Settings link
   - Camera unavailable: Show error message with retry
   - Capture failure: Retry mechanism

2. Core Data errors:
   - Save failures: Log error, show user-friendly message
   - Fetch failures: Return empty results, don't crash
   - Use do-catch for all Core Data operations

3. Network errors (RevenueCat):
   - Purchase failures: Show error message, allow retry
   - Receipt validation failures: Allow restore
   - Network unavailable: Cache subscription status locally

4. Image processing errors:
   - No face detected: Show error, allow retry
   - Processing timeout: Show error, allow retry
   - Invalid image: Show error, allow retry

5. User-friendly error messages:
   - Don't show technical errors to users
   - Provide actionable next steps
   - Allow retry for transient errors

Example error handling pattern:

enum AppError: LocalizedError {
    case cameraPermissionDenied
    case noFaceDetected
    case processingFailed
    case purchaseFailed
    
    var errorDescription: String? {
        switch self {
        case .cameraPermissionDenied:
            return "Camera access is required. Please enable in Settings."
        case .noFaceDetected:
            return "No face detected. Please try again with better lighting."
        case .processingFailed:
            return "Processing failed. Please try again."
        case .purchaseFailed:
            return "Purchase failed. Please try again or contact support."
        }
    }
}

All errors must be logged. App must never crash on errors.
```

---

## PROMPT 17: Info.plist Configuration

**Copy this prompt to your AI coding agent:**

```
Configure Info.plist with required permissions and descriptions:

Required keys:
- NSCameraUsageDescription: "We need camera access to analyze your face. All processing happens on your device (privacy-first). Your photos are never uploaded to our servers."

Optional keys (for future features):
- NSPhotoLibraryUsageDescription: (not needed for MVP)

App capabilities to enable in Xcode:
- Push Notifications (for local notifications)
- In-App Purchase (for RevenueCat)

Background modes (not needed for MVP):
- None

Privacy manifest (iOS 17+):
- Create PrivacyInfo.xcprivacy file
- Declare: Camera usage (required for core functionality)
- Declare: No data collection (local-only processing)

All privacy descriptions must be clear and honest.
```

---

## PROMPT 18: Testing & Validation Checklist

**Copy this prompt to your AI coding agent:**

```
Create a testing checklist for manual validation:

MVP Testing Checklist:

Onboarding:
- [ ] Welcome screen displays
- [ ] Continue button navigates to permissions
- [ ] Camera permission requested
- [ ] Permission granted → navigates to camera
- [ ] Permission denied → shows Settings alert

Camera:
- [ ] Camera preview displays
- [ ] Front photo captures
- [ ] Side photo captures
- [ ] Processing screen shows
- [ ] Results display in <1 second

Results:
- [ ] Rating displays (1-10)
- [ ] Strengths shown
- [ ] Weaknesses blurred (free users)
- [ ] Paywall button works
- [ ] Daily routine button works

Daily Routine:
- [ ] Streak counter displays
- [ ] 3 tasks shown
- [ ] Tasks can be toggled
- [ ] All 3 complete → streak increments
- [ ] Daily insight unlocks

Streak Logic:
- [ ] Streak increments when all tasks complete
- [ ] Streak resets if >24h since last completion
- [ ] Streak freeze option appears when at risk

Subscription:
- [ ] Paywall displays
- [ ] Purchase button works (sandbox)
- [ ] Subscription activates
- [ ] Pro features unlock
- [ ] Free tier limits enforced (1 scan/week)

Notifications:
- [ ] Permission requested
- [ ] Daily reminder scheduled
- [ ] Streak at risk notification scheduled
- [ ] Notifications fire at correct time

Offline:
- [ ] App works without internet
- [ ] Streak updates work offline
- [ ] Core Data saves work offline

Performance:
- [ ] Face scan processing <1 second
- [ ] UI animations smooth (60fps)
- [ ] App launch <2 seconds
- [ ] No memory leaks

Legal:
- [ ] Camera permission text is clear
- [ ] No dark patterns in paywall
- [ ] Privacy messaging accurate
- [ ] No medical claims

Test on real device (iPhone 12+) before submission.
```

---

## PROMPT 19: App Store Connect Configuration

**Copy this prompt to your AI coding agent:**

```
Configure App Store Connect for MVP submission:

1. App Information:
   - Name: "Aesthetic Optimizer" (or similar, avoid "looksmaxxing" for mainstream appeal)
   - Subtitle: "AI Facial Analysis & Self-Improvement"
   - Category: Health & Fitness (or Lifestyle)
   - Age Rating: 17+ (due to body image content)
   - Privacy Policy URL: (create simple privacy policy, host on GitHub Pages)

2. In-App Purchases:
   - Product 1: "Pro Monthly"
     * Type: Auto-Renewable Subscription
     * Product ID: "pro_monthly"
     * Price: $14.99 CAD/month
     * Subscription Group: "Pro Features"
     * Free Trial: None (for MVP)
   
   - Product 2: "Streak Freeze"
     * Type: Non-Consumable
     * Product ID: "streak_freeze"
     * Price: $1.99 CAD
     * Can purchase multiple times

3. App Privacy:
   - Camera: Used for facial analysis (required for core functionality)
   - No data collection declared (local-only processing)
   - No third-party data sharing

4. Screenshots Required:
   - iPhone 6.7" (iPhone 14 Pro Max)
   - iPhone 6.5" (iPhone 11 Pro Max)
   - iPhone 5.5" (iPhone 8 Plus)
   - Show: Onboarding, Scan, Results, Daily Routine, Streak

5. App Description:
   "Aesthetic Optimizer uses AI to analyze your facial features and provide personalized self-improvement insights. Track your progress daily with streaks and unlock detailed analysis with Pro.

   Features:
   - AI-powered facial analysis (on-device processing)
   - Daily routine tracking with streaks
   - Progress monitoring
   - Privacy-first (all processing happens on your device)

   All facial analysis happens on your device. Your photos are never uploaded to our servers."

6. Keywords (for ASO):
   - facial analysis, self improvement, attractiveness, skincare, grooming, streaks, daily routine

7. Support URL:
   - Create simple support page (can be email for MVP)

8. Marketing URL:
   - Optional for MVP

Submit to TestFlight first for beta testing before App Store submission.
```

---

## PROMPT 20: Final Integration & Polish

**Copy this prompt to your AI coding agent:**

```
Integrate all components and add final polish:

1. Connect all views:
   - OnboardingView → CameraView → ProcessingView → ResultsView
   - ResultsView → PaywallView (if free user)
   - ResultsView → DailyRoutineView
   - HomeView → CameraView (fullScreenCover)
   - HomeView → DailyRoutineView (NavigationLink)
   - HomeView → PaywallView (sheet)

2. Add animations:
   - Rating reveal animation (scale + fade)
   - Task completion animation (checkmark bounce)
   - Streak increment animation (number count up)
   - Screen transitions (smooth)

3. Add haptic feedback:
   - Rating reveal: UIImpactFeedbackGenerator(.medium)
   - Task completion: UINotificationFeedbackGenerator(.success)
   - Streak milestone: UINotificationFeedbackGenerator(.success)
   - Purchase success: UINotificationFeedbackGenerator(.success)

4. Add loading states:
   - Show loading indicator during purchases
   - Show loading during Core Data operations
   - Disable buttons during async operations

5. Add error handling:
   - Wrap all async operations in do-catch
   - Show user-friendly error messages
   - Allow retry for transient errors

6. Add empty states:
   - No scans yet: Show "Get started" message
   - No streak yet: Show "Start your streak" message

7. Add accessibility:
   - VoiceOver labels for all buttons
   - Dynamic type support
   - Color contrast compliance

8. Performance optimization:
   - Lazy loading for images
   - Debounce user interactions
   - Cache Core Data fetches

9. Final testing:
   - Test on real device
   - Test subscription purchase (sandbox)
   - Test offline functionality
   - Test error scenarios

10. Code cleanup:
    - Remove debug print statements
    - Add code comments
    - Organize file structure
    - Remove unused code

App should be production-ready after this step.
```

---

## BUILD SEQUENCE SUMMARY

**Copy these prompts in order to your AI coding agent:**

1. **Prompt 1:** Project setup (30 min)
2. **Prompt 2:** Core Data model (1 hour)
3. **Prompt 3:** UserDefaults extension (15 min)
4. **Prompt 4:** Onboarding view (1 hour)
5. **Prompt 5:** Camera view (1 hour)
6. **Prompt 6:** Core ML service (mocked) (1 hour)
7. **Prompt 7:** Processing view (30 min)
8. **Prompt 8:** Results view (1 hour)
9. **Prompt 9:** Daily routine view (1 hour)
10. **Prompt 10:** Streak ViewModel (1 hour)
11. **Prompt 11:** Subscription ViewModel (1 hour)
12. **Prompt 12:** Paywall view (1 hour)
13. **Prompt 13:** Home view (1 hour)
14. **Prompt 14:** Notification service (1 hour)
15. **Prompt 15:** App entry point (30 min)
16. **Prompt 16:** Error handling (1 hour)
17. **Prompt 17:** Info.plist config (15 min)
18. **Prompt 18:** Testing checklist (manual)
19. **Prompt 19:** App Store Connect setup (manual)
20. **Prompt 20:** Final integration (2 hours)

**Total: 12-18 hours** (can be done in 1-2 days)

---

## CRITICAL REMINDERS

1. **Keep it simple:** MVP tests the loop, not the full product
2. **Mock AI for speed:** Use simple heuristic, replace with Core ML later
3. **Local-only storage:** Never upload facial images to cloud
4. **Test on real device:** Don't rely on simulator for camera
5. **Kill if metrics fail:** Day 7 retention <10% or conversion <2% = kill
6. **No dark patterns:** Transparent pricing, easy cancellation
7. **Legal compliance:** Clear camera permission text, no medical claims

---

**Last Updated:** January 12, 2026
