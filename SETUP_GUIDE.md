# 🚀 Looksmaxxing App MVP - Quick Setup Guide

## What You Built

A complete iOS MVP for facial analysis with:
- **AI Face Scan** - Uses Vision framework to analyze faces
- **Streak System** - Daily retention mechanism (loss aversion)
- **Subscription** - $14.99/month via RevenueCat
- **Streak Freeze** - $1.99 IAP to protect streaks
- **Push Notifications** - Local notifications for re-engagement

---

## 📁 Project Structure

```
LooksmaxxingApp/
├── App/                    # App entry point
├── Views/                  # 6 SwiftUI views
├── ViewModels/             # 3 view models
├── Models/                 # Data models
├── Services/               # Core Data, CoreML, Notifications
├── Utilities/              # Extensions
├── Resources/              # Assets, Core Data model
├── Info.plist              # App configuration
└── PrivacyInfo.xcprivacy   # Privacy manifest
```

---

## ⚡ Quick Start (On Mac with Xcode)

### 1. Open Project
```bash
cd path/to/Looksmaxxing_App
open LooksmaxxingApp.xcodeproj
```

### 2. Add RevenueCat Package
1. Xcode → File → Add Package Dependencies
2. URL: `https://github.com/RevenueCat/purchases-ios`
3. Click Add Package

### 3. Configure API Key
Open `LooksmaxxingApp/ViewModels/SubscriptionViewModel.swift`:
- Line 46: Replace `"YOUR_REVENUECAT_API_KEY"` with your key
- Uncomment RevenueCat code blocks

### 4. Set Bundle ID
1. Click project in navigator
2. Select target → Signing & Capabilities
3. Change bundle ID to your identifier
4. Select your team

### 5. Run
- Select device/simulator (iPhone 12+ recommended)
- Press ⌘R

---

## 📱 User Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Onboarding │ --> │   Camera    │ --> │   Results   │
│  (Welcome)  │     │ (Front+Side)│     │  (Rating)   │
└─────────────┘     └─────────────┘     └──────┬──────┘
                                               │
                    ┌──────────────────────────┘
                    ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│    Home     │ <-- │Daily Routine│ --> │   Paywall   │
│ (Streak+CTA)│     │ (3 Tasks)   │     │ ($14.99/mo) │
└─────────────┘     └─────────────┘     └─────────────┘
```

---

## 🎯 Core Features

### 1. Face Scan
- Front + side photo capture
- Vision framework analysis
- Rating 1-10 with strengths/weaknesses
- Processing time <1 second

### 2. Streak System
- Daily streak counter
- 24-hour maintenance window
- Streak freeze protection ($1.99)
- Loss aversion for retention

### 3. Daily Routine
- 3 micro-tasks (water, skincare, posture)
- One-tap completion
- Unlocks daily insight
- Maintains streak

### 4. Monetization
- **Free**: 1 scan/week, basic rating
- **Pro**: Unlimited scans, full analysis
- **Streak Freeze**: $1.99 one-time

---

## 🧪 Running Unit Tests

### In Xcode
1. Press `⌘U` to run all tests
2. Or go to Product → Test
3. View results in Test Navigator (`⌘6`)

### Command Line
```bash
xcodebuild test \
  -project LooksmaxxingApp.xcodeproj \
  -scheme LooksmaxxingApp \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Test Coverage

| Test File | What It Tests |
|-----------|---------------|
| `FaceAnalysisResultTests` | Model, formatting, codable |
| `UserDefaultsExtensionsTests` | All UserDefaults properties |
| `AppErrorTests` | All error cases, recovery |
| `StreakViewModelTests` | Streak logic, freeze |
| `SubscriptionViewModelTests` | Purchase flow, status |
| `ScanViewModelTests` | Capture flow, reset |
| `CoreMLServiceTests` | Rating bounds, processing |
| `IntegrationTests` | End-to-end flows |

---

## ✅ Manual Testing Checklist

### Onboarding
- [ ] Welcome screen displays
- [ ] Camera permission works
- [ ] Permission denial shows alert

### Camera
- [ ] Front photo captures
- [ ] Side photo captures
- [ ] Processing shows progress

### Results
- [ ] Rating displays
- [ ] Strengths shown
- [ ] Weaknesses blurred (free users)
- [ ] Paywall appears

### Streak
- [ ] Streak increments on completion
- [ ] Resets after 24h without completion
- [ ] Freeze option appears when at risk

### Subscription
- [ ] Paywall displays correctly
- [ ] Sandbox purchase works
- [ ] Pro features unlock

---

## 📊 Success Metrics

Track these in first 7-14 days:

| Metric | Target | Kill Signal |
|--------|--------|-------------|
| Day 7 Retention | >20% | <10% |
| Conversion Rate | >10% | <2% |
| Streak Maintenance | >30% | <15% |

---

## 🛠 RevenueCat Setup

### 1. Create RevenueCat Account
- Go to https://app.revenuecat.com
- Create new project

### 2. Configure Products
In App Store Connect:
- `pro_monthly` - $14.99/month subscription
- `streak_freeze` - $1.99 non-consumable

### 3. Link in RevenueCat
- Add App Store app
- Create entitlement: "pro"
- Map products to entitlement

### 4. Get API Key
- Go to API Keys section
- Copy public API key
- Paste in `SubscriptionViewModel.swift`

---

## 🚨 Common Issues

### "No face detected"
- Ensure good lighting
- Position face clearly in frame
- Try different angles

### Subscription not working
- Check RevenueCat API key
- Verify products in App Store Connect
- Use sandbox account for testing

### Camera permission denied
- App will prompt to open Settings
- Enable camera in iOS Settings

---

## 📝 Legal Notes

### Privacy
- ✅ All processing on-device
- ✅ No cloud image storage
- ✅ Explicit consent for camera
- ✅ No biometric templates

### App Store Compliance
- ✅ No medical claims
- ✅ No dark patterns
- ✅ Clear pricing
- ✅ Easy cancellation

---

## 🎬 Next Steps

1. **Build & Test** on real device
2. **Configure RevenueCat** with your API key
3. **Submit to TestFlight** for beta testing
4. **Monitor metrics** for 7-14 days
5. **Decide**: Iterate if passing, kill if failing

---

**Remember: This MVP tests the core loop. If metrics fail, pivot or kill. Don't add features hoping it fixes retention.**

Good luck! 🚀
