# Ascend: Clean Project Specification

**Version:** 2.1 (Unified from 25+ source documents)  
**Date:** January 14, 2026  
**Status:** MVP BUILT → Testing Phase

---

## BRANDING

**App Name:** Ascend  
**Tagline:** Face Your Potential  
**Previous Working Title:** Aesthetic Optimizer, Looksmaxxing App

---

## 1. CLEAN UNIFIED PROJECT SUMMARY

An iOS app that provides AI facial analysis with daily streak retention mechanics.

**What it does:**
- User takes front + side selfie
- App analyzes on-device (<1 second)
- Returns rating (1-10) with strengths/weaknesses
- Daily micro-tasks maintain streak
- Subscription unlocks full analysis

**Core hypothesis being tested:**
Users will pay $14.99/month for facial analysis AND return daily for streaks (unlike competitors who failed retention).

**Current status:**
MVP code is built. Xcode project exists. Ready for compilation and testing on real iOS device or cloud Mac.

---

## 2. CANONICAL FEATURE LIST (MVP - BUILT)

### Core Features (Implemented)
| Feature | Status | File Location |
|---------|--------|---------------|
| Face capture (front + side) | ✅ Built | `Views/CameraView.swift` |
| AI analysis (Vision framework, mocked heuristics) | ✅ Built | `Services/CoreMLService.swift` |
| Rating display (1-10) | ✅ Built | `Views/ResultsView.swift` |
| Strengths visible, weaknesses blurred (free) | ✅ Built | `Views/ResultsView.swift` |
| Daily routine (3 micro-tasks) | ✅ Built | `Views/DailyRoutineView.swift` |
| Streak counter | ✅ Built | `ViewModels/StreakViewModel.swift` |
| Streak-at-risk notification | ✅ Built | `Services/NotificationService.swift` |
| Paywall ($14.99/month) | ✅ Built | `Views/PaywallView.swift` |
| Streak freeze IAP ($1.99) | ✅ Built | `ViewModels/SubscriptionViewModel.swift` |
| Onboarding (2 screens) | ✅ Built | `Views/OnboardingView.swift` |
| Local-only data storage | ✅ Built | `Services/CoreDataManager.swift` |

### Free vs Pro
| Capability | Free | Pro ($14.99/mo) |
|------------|------|-----------------|
| Scans per week | 1 | Unlimited |
| Rating | Basic number | Detailed |
| Strengths | Yes | Yes |
| Weaknesses | Blurred | Full |
| Streak freeze | No | Yes |

---

## 3. REMOVED OR DEFERRED ITEMS

### Removed (Duplicate/Premature)
| Item | Reason |
|------|--------|
| Social features (leaderboards, circles) | Premature - validate core loop first |
| Live Activities widget | iOS-specific polish - not MVP |
| Energy system (3 scans/day) | Over-engineered - use weekly limit |
| Weekly leagues | Social feature - deferred |
| Friend challenges | Social feature - deferred |
| Infinite scroll feed | Content feature - deferred |
| Progress charts/graphs | Visualization - deferred |
| AI visualizer (future self) | Premium feature - deferred |
| 90-day roadmap | Over-scoped - use 3 daily tasks |
| Firebase integration | Not needed for MVP testing |
| Real Core ML model | Using Vision framework heuristics |
| Android version | iOS-first validated by research |

### Removed (Conflicting/Unclear)
| Item | Reason |
|------|--------|
| "Validate before building" phase | Conflicts with "build fast" - MVP was built |
| $500M-$1B valuation planning | Premature - validate MVP first |
| 6-pillar scaling strategy | Premature - validate MVP first |
| Marketing/ASO strategy | Post-validation |
| Churn prediction system | Over-engineered for MVP |
| Win-back campaigns | Requires email collection - deferred |

---

## 4. RESOLVED CONFLICTS

| Conflict | Sources | Resolution |
|----------|---------|------------|
| Day 7 retention target | "25%" vs "20%" vs ">20%" | **>20%** (with <10% as kill signal) |
| Conversion rate target | "34.7%" vs "10%" | **10%** realistic (34.7% is industry ceiling) |
| Build vs validate first | `product-audit.md` vs `mvp-specification.md` | **Build fast, validate with real users** (MVP already built) |
| Firebase required? | `implementation-roadmap.md` vs built code | **Not required** (local notifications work) |
| RevenueCat integration | "Full implementation" vs "simulated" | **Simulated for testing** (add later) |
| Market durability | "TREND" vs "DURABLE MOVEMENT" | **Test will reveal truth** (7-14 days) |
| Core ML vs Vision | "Custom Core ML model" vs "Vision framework" | **Vision framework with heuristics** (simpler, faster) |
| CAI notification timing | "60 days before launch" vs "post-validation" | **Post-validation** (if metrics pass) |

---

## 5. CLEAN MVP-READY SPEC (FOR AI CODING AGENTS)

```
=== ASCEND iOS MVP ===

PLATFORM: iOS 15+, SwiftUI, MVVM architecture
STORAGE: Core Data (local only - no cloud)
PAYMENTS: RevenueCat SDK (simulated for testing)
AI: Vision framework with mocked heuristics (not real ML model)

PROJECT STRUCTURE:
LooksmaxxingApp/
├── App/
│   ├── LooksmaxxingApp.swift     # Entry point, environment setup
│   └── ContentView.swift         # Navigation (onboarding → home)
├── Views/
│   ├── OnboardingView.swift      # Welcome + camera permission
│   ├── HomeView.swift            # Streak, scan button, daily routine button
│   ├── CameraView.swift          # AVFoundation capture, face guide overlay
│   ├── ResultsView.swift         # Rating, strengths, blurred weaknesses
│   ├── DailyRoutineView.swift    # 3 micro-tasks, streak logic
│   └── PaywallView.swift         # $14.99/month offer
├── ViewModels/
│   ├── ScanViewModel.swift       # Camera state, capture flow
│   ├── StreakViewModel.swift     # Streak counter, risk detection
│   └── SubscriptionViewModel.swift # Pro status, IAP handling
├── Services/
│   ├── CoreDataManager.swift     # CRUD for entities
│   ├── CoreMLService.swift       # Vision framework face detection + heuristics
│   └── NotificationService.swift # Local push scheduling
├── Models/
│   ├── FaceAnalysisResult.swift  # Rating, strengths, weaknesses
│   ├── CoreDataEntities.swift    # StreakEntity, DailyTaskEntity, FaceAnalysisEntity
│   └── AppError.swift            # Centralized error handling
├── Utilities/
│   └── Extensions/
│       └── UserDefaults+Extensions.swift
└── Resources/
    ├── CoreData/LooksmaxxingApp.xcdatamodeld
    ├── Assets.xcassets/
    ├── Info.plist
    └── PrivacyInfo.xcprivacy

USER FLOW:
1. Launch → Onboarding (if first time)
2. Onboarding: Welcome screen → Camera permission request → Home
3. Home: Shows streak, "Scan Face" button, "Daily Routine" button
4. Scan: Camera captures front → side → processing → Results
5. Results: Rating displayed, strengths shown, weaknesses blurred (free users)
6. Paywall: Triggered from Results for full analysis
7. Daily Routine: 3 tasks (water, skincare, posture) → all complete = streak +1
8. Next day: Notification reminds user → return to maintain streak

MONETIZATION LOGIC:
- Free: 1 scan/week (tracked via UserDefaults.lastScanDate)
- Free: Sees rating + strengths only
- Pro ($14.99/month): Unlimited scans, full weaknesses
- IAP: Streak freeze ($1.99) - protects streak for 1 missed day

STREAK LOGIC:
- Streak increments when all 3 daily tasks completed
- Streak resets if no completion for 24+ hours (unless frozen)
- Notification sent when streak at risk (no completion by 8pm)
- Loss aversion message: "Your X-day streak is at risk!"

AI RATING LOGIC (MOCKED):
- Vision framework detects face bounding box
- If face detected: generate rating 5.5-8.5 (semi-random for variable reward)
- Strengths: randomly select 2-3 from ["Facial symmetry", "Eye spacing", "Jawline definition", "Skin clarity", "Brow positioning"]
- Weaknesses: randomly select 1-2 from ["Midface ratio", "Canthal tilt", "Lip fullness", "Nose projection", "Skin texture"]
- Processing time: <1 second

DATA STORED LOCALLY:
- StreakEntity: currentStreak, longestStreak, lastCompletionDate
- DailyTaskEntity: taskId, isCompleted, date
- FaceAnalysisEntity: rating, strengths, weaknesses, scanDate
- UserDefaults: hasCompletedOnboarding, deviceID, isProUser, lastScanDate

WHAT IS NOT BUILT:
- Real AI model (using heuristics)
- Cloud storage (local only)
- RevenueCat API calls (simulated)
- Firebase (not needed)
- Social features
- Progress visualization

SUCCESS METRICS (Test for 7-14 days):
- Day 7 retention >20% (kill if <10%)
- Conversion rate >10% (kill if <2%)
- 30%+ users maintain 3+ day streak
- Zero App Store rejection
- Zero legal complaints

KILL CRITERIA:
- Day 7 retention <10%
- Conversion <2%
- App Store rejection
- Legal/regulatory issue
```

---

## 6. OPEN QUESTIONS / BLOCKERS

### Must Resolve Before Public Launch
| Question | Impact | Status |
|----------|--------|--------|
| Will users return daily for streaks? | Core hypothesis | TESTING |
| Is $14.99/month acceptable? | Revenue model | TESTING |
| Will App Store approve? | Can't launch without | UNKNOWN |
| Does mocked AI feel accurate? | User satisfaction | TESTING |

### Blocked Until Metrics Pass
| Question | Why Blocked |
|----------|-------------|
| Privacy Impact Assessment (PIA) | Don't invest if metrics fail |
| CAI notification (60 days) | Don't invest if metrics fail |
| RevenueCat full integration | Don't invest if metrics fail |
| Real Core ML model | Don't invest if metrics fail |

### [UNSPECIFIED]
- Exact push notification timing (using 8pm default)
- Daily routine task selection logic (hardcoded 3 tasks)
- Rating algorithm weights (mocked, not scientific)

---

## 7. AI-READINESS VERDICT

**Status: IMMEDIATELY BUILDABLE**

The MVP code exists and is complete. An AI coding agent can:

1. **Compile and test** - Xcode project is ready
2. **Fix bugs** - All files are in place
3. **Add features** - Clear architecture to extend

**What's needed to test:**
- Mac with Xcode 15+ OR Cloud Mac service
- Apple Developer account ($99/year) for device testing
- RevenueCat account for payment simulation

**What's NOT needed:**
- Additional research
- Feature additions
- Architecture changes

**Next concrete action:**
Transfer project to Mac → Open in Xcode → Build → Run on device/simulator → Test core flow.

---

## APPENDIX: FILE CLEANUP RECOMMENDATION

### KEEP (Essential)
```
/LooksmaxxingApp/              # All code files (built MVP)
/PROJECT_SPEC.md               # This document
/SETUP_GUIDE.md                # How to compile
```

### ARCHIVE (Reference only - move to /99_ARCHIVE/)
```
/01_RESEARCH/*                 # All research files
/02_IMPLEMENTATION/*           # All planning files
/CANONICAL_PROJECT_BRIEF.md    # Superseded by PROJECT_SPEC.md
/README.md                     # Superseded by PROJECT_SPEC.md
```

### DELETE (True duplicates)
```
# These files contain information now consolidated here:
# - mvp-specification.md + mvp-specification-detailed.md (merged)
# - action-plan.md + implementation-roadmap.md + next-steps-prioritized.md (merged)
# - product-audit.md + business-model-audit.md (merged)
# - research-addictive-features.md + specific-mechanics.md (merged)
# - README.md (root) + CANONICAL_PROJECT_BRIEF.md (superseded)
```

---

**This document is the single source of truth.**  
**All prior specifications are superseded.**  
**Last Updated:** January 14, 2026
