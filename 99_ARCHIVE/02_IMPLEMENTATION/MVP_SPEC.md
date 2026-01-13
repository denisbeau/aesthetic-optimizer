# MVP Specification: Aesthetic Optimizer

**Target:** AI coding agent ready  
**Status:** ✅ MVP BUILT, pending validation

---

## 1. GOAL

**Prove:** Users will pay $14.99/month for AI facial analysis AND return daily to maintain streaks.

**Success (7-14 days):**
- Day 7 retention >20%
- Conversion rate >10%
- Streak maintenance >30%
- Zero App Store rejections

**Kill signals:**
- Day 7 retention <10%
- Conversion rate <2%
- App Store rejection
- Legal warning

---

## 2. CORE USER LOOP

```
1. User opens app (push notification or manual)
2. Completes 12-question onboarding (first time only)
3. Takes selfie (front + side profile)
4. AI processes on-device (<1 second)
5. Sees rating (1-10) + strengths (visible) + weaknesses (blurred for free)
6. Option to unlock full analysis ($14.99/month)
7. Directed to Daily Routine (3 micro-tasks)
8. All 3 complete = streak maintained
9. Push notification next day: "Streak at risk"
10. Loop repeats daily
```

---

## 3. FEATURE SET

### Must-Have (✅ Built)
| Feature | Purpose | Status |
|---------|---------|--------|
| 12-question onboarding | Sunk cost, personalization | ✅ OnboardingQuizView.swift |
| "Analyzing" animation | Perceived value | ✅ AnalyzingView.swift |
| Results tease (locked items) | Curiosity gap | ✅ ResultsTeaseView.swift |
| AI Face Scan | Core value prop | ✅ CoreMLService.swift |
| Streak Counter | Retention via loss aversion | ✅ StreakViewModel.swift |
| Daily Routine (3 tasks) | Daily value delivery | ✅ DailyRoutineView.swift |
| Subscription Paywall | Revenue | ✅ PaywallView.swift |
| Push Notifications | Re-engagement | ✅ NotificationService.swift |

### Deferred (❌ Not Built)
- Social features (circles, leaderboards)
- Streak Freeze IAP
- Progress photo comparison
- Real ML model (using Vision framework heuristics)
- Cloud sync
- Advanced analytics

---

## 4. TECHNICAL STACK

```
Platform: iOS 16+ (SwiftUI)
Storage: Core Data (local only, never cloud)
AI: Vision framework (on-device, <1 second)
Payments: RevenueCat (simulated for testing)
Notifications: Local push (no Firebase required for MVP)
```

---

## 5. FILE STRUCTURE

```
LooksmaxxingApp/
├── App/
│   ├── LooksmaxxingApp.swift    # Entry point
│   └── ContentView.swift        # Navigation controller
├── Views/
│   ├── OnboardingQuizView.swift # 12-question flow
│   ├── AnalyzingView.swift      # Loading animation
│   ├── ResultsTeaseView.swift   # Locked results tease
│   ├── PersonalizedPaywallView.swift # Conversion screen
│   ├── HomeViewDark.swift       # Main dashboard
│   ├── CameraView.swift         # Photo capture
│   ├── ResultsView.swift        # Full results
│   ├── DailyRoutineView.swift   # 3 micro-tasks
│   └── PaywallView.swift        # Generic paywall
├── ViewModels/
│   ├── ScanViewModel.swift      # AI processing
│   ├── StreakViewModel.swift    # Streak logic
│   └── SubscriptionViewModel.swift # Payment state
├── Models/
│   ├── FaceAnalysisResult.swift # Rating model
│   ├── CoreDataEntities.swift   # Persistence
│   └── AppError.swift           # Error handling
├── Services/
│   ├── CoreDataManager.swift    # Local storage
│   ├── CoreMLService.swift      # Face analysis
│   └── NotificationService.swift # Push notifications
└── Utilities/
    └── Extensions/
        └── UserDefaults+Extensions.swift # Preferences
```

---

## 6. KEY CODE PATTERNS

### Singleton Services
```swift
CoreDataManager.shared
SubscriptionViewModel.shared
StreakViewModel.shared
```

### Environment Injection
```swift
.environmentObject(subscriptionVM)
.environmentObject(streakVM)
```

### Local-Only Storage
All data in Core Data, images never leave device.

---

## 7. LEGAL REQUIREMENTS

- Camera permission with privacy message
- "All processing on-device" disclaimer
- No medical claims
- Age rating: 17+
- Clear subscription terms
- Easy cancellation via App Store

---

## 8. TESTING

### Unit Tests (✅ 118 tests passing)
- FaceAnalysisResultTests
- UserDefaultsExtensionsTests
- StreakViewModelTests
- SubscriptionViewModelTests
- ScanViewModelTests
- CoreMLServiceTests

### Manual Testing
- Appetize.io for visual verification
- GitHub Actions CI/CD pipeline

---

## 9. WHAT NOT TO BUILD

Do NOT add these hoping to fix retention:
- Social features
- Cloud sync
- Real ML model
- Progress charts
- Email campaigns
- Advanced analytics

The MVP tests the CORE LOOP. If it fails, these won't save it.
