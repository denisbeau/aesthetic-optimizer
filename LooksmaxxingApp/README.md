# Aesthetic Optimizer (LooksmaxxingApp) - iOS MVP

**Version:** 1.0.0  
**Target:** iOS 15.0+  
**Build Time:** 12-18 hours  

## Overview

AI-powered facial analysis app with daily streak retention mechanism.

**Core Loop:**
1. User takes selfie (front + side)
2. AI analyzes face on-device (<1 second)
3. Shows rating (1-10) + strengths/weaknesses
4. User completes 3 daily micro-tasks to maintain streak
5. Streak creates loss aversion → retention

## Features

### MVP Features (Included)
- ✅ Face Scan + AI Rating (Vision framework)
- ✅ Streak Counter (loss aversion retention)
- ✅ Daily Routine (3 micro-tasks)
- ✅ Subscription Paywall ($14.99/month)
- ✅ Streak Freeze IAP ($1.99)
- ✅ Push Notifications (local)

### Excluded from MVP
- ❌ Social features
- ❌ Progress charts
- ❌ Cloud sync
- ❌ Real Core ML model (using heuristics)

## Setup Instructions

### Prerequisites
- macOS with Xcode 15+
- Apple Developer Account ($99/year)
- RevenueCat Account (free tier)

### Step 1: Open Project
1. Open `LooksmaxxingApp.xcodeproj` in Xcode
2. Wait for Swift packages to resolve

### Step 2: Add RevenueCat
1. File > Add Package Dependencies
2. Enter URL: `https://github.com/RevenueCat/purchases-ios`
3. Add to target: LooksmaxxingApp

### Step 3: Configure RevenueCat
1. Create app in RevenueCat dashboard
2. Copy API key
3. Open `SubscriptionViewModel.swift`
4. Replace `"YOUR_REVENUECAT_API_KEY"` with your key
5. Uncomment RevenueCat implementation code

### Step 4: Configure App Store Connect
1. Create app in App Store Connect
2. Configure In-App Purchases:
   - `pro_monthly`: $14.99/month subscription
   - `streak_freeze`: $1.99 non-consumable
3. Link products in RevenueCat

### Step 5: Update Bundle ID
1. Open project settings
2. Change `com.yourcompany.LooksmaxxingApp` to your bundle ID
3. Set your Development Team

### Step 6: Build & Run
1. Select your device/simulator
2. Build and run (⌘R)

## File Structure

```
LooksmaxxingApp/
├── App/
│   ├── LooksmaxxingApp.swift      # Entry point
│   └── ContentView.swift           # Navigation controller
├── Views/
│   ├── OnboardingView.swift        # Welcome + permissions
│   ├── HomeView.swift              # Main screen
│   ├── CameraView.swift            # Face capture
│   ├── ResultsView.swift           # Analysis display
│   ├── DailyRoutineView.swift      # Micro-tasks
│   └── PaywallView.swift           # Subscription offer
├── ViewModels/
│   ├── ScanViewModel.swift         # Camera + processing
│   ├── StreakViewModel.swift       # Streak logic
│   └── SubscriptionViewModel.swift # RevenueCat
├── Models/
│   ├── FaceAnalysisResult.swift    # Analysis model
│   ├── CoreDataEntities.swift      # Core Data models
│   └── AppError.swift              # Error handling
├── Services/
│   ├── CoreDataManager.swift       # Local storage
│   ├── CoreMLService.swift         # AI processing
│   └── NotificationService.swift   # Push notifications
├── Utilities/
│   └── Extensions/
│       └── UserDefaults+Extensions.swift
└── Resources/
    ├── Assets.xcassets
    └── CoreData/
        └── LooksmaxxingApp.xcdatamodeld
```

## Key Metrics to Track

### Success Metrics (7-14 days)
- **Day 7 Retention >20%**: Users return after first scan
- **Conversion Rate >10%**: Free → paid subscription
- **Streak Maintenance >30%**: Users maintain 3+ day streak

### Kill Signals
- Day 7 Retention <10% → Kill or pivot
- Conversion Rate <2% → Kill or pivot pricing
- App Store Rejection → Kill immediately

## Legal Compliance

### Privacy
- All facial analysis on-device
- No cloud storage of images
- No biometric templates stored
- Explicit camera permission

### App Store
- No medical claims
- No dark patterns
- Clear subscription terms
- Easy cancellation

## Testing Checklist

### Before Launch
- [ ] Test on real device (iPhone 12+)
- [ ] Test subscription purchase (sandbox)
- [ ] Test streak logic (24h window)
- [ ] Test offline functionality
- [ ] Verify no crashes
- [ ] Check camera permission text

### Sandbox Testing
1. Create sandbox user in App Store Connect
2. Sign out of App Store on device
3. Sign in with sandbox account
4. Test purchases

## Support

For issues or questions about the MVP implementation, refer to:
- `02_IMPLEMENTATION/mvp-specification.md`
- `02_IMPLEMENTATION/mvp-specification-detailed.md`
- `02_IMPLEMENTATION/mvp-ai-coding-prompts.md`

---

**Remember:** This MVP is a test, not a product. If metrics fail, kill it. Don't build more features hoping it fixes retention.
