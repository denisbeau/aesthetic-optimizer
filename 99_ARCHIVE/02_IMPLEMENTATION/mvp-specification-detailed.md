# MVP Specification: Detailed Implementation Guide (AI Coding Agent Ready)

**Date:** January 12, 2026  
**Target:** AI-coding-agent-ready spec for rapid MVP build  
**Timeline:** Build in hours, validate in days  
**Philosophy:** Speed > polish, legally survivable, reversible decisions only

---

## 1. MVP GOAL

**Prove:** Users will pay $14.99/month for AI facial analysis and return daily to maintain a streak. The core addictive loop (scan → rating → streak → loss aversion) works without requiring complex features.

**Success in 7-14 days:**
- 20%+ Day 7 retention (users return after first scan)
- 10%+ conversion to paid (free → $14.99/month subscription)
- 30%+ of users maintain 3+ day streak
- Zero legal complaints or platform warnings

**If these metrics fail:** Pivot or kill. Don't build more features hoping it will fix retention.

---

## 2. CORE USER LOOP (Step-by-Step)

**Entry Trigger:** User opens app (push notification, widget, or manual open)

**Action 1:** User takes selfie (front + side profile)

**Feedback 1:** AI processes on-device (<1 second), shows rating (1-10) + top 3 strengths/weaknesses

**Reward 1:** Variable reward (rating varies slightly each scan, creates curiosity)

**Action 2:** User sees "Daily Streak: 1 day" counter

**Feedback 2:** "Complete your daily routine to maintain your streak" (3 micro-tasks: hydration check, skincare reminder, posture check)

**Reward 2:** Completing all 3 tasks = streak maintained, unlocks "Daily Insight" (personalized tip)

**Re-engagement Trigger:** Push notification next day: "Your streak is at risk! Complete today's routine in 4 hours"

**Loss Aversion Hook:** If user misses a day, streak resets to 0. "Streak Freeze" available for $1.99 (IAP).

**Loop repeats daily.** Streak becomes the primary retention driver.

---

## 3. MVP FEATURE SET

### Must-Have (Day 1)

1. **Face Scan + AI Rating**
   - Camera capture (front + side)
   - Core ML on-device processing
   - Rating (1-10) + 3 strengths/3 weaknesses
   - **Why:** Core value proposition, conversion driver

2. **Streak Counter**
   - Daily streak display (number of consecutive days)
   - Visual indicator (fire emoji, number badge)
   - **Why:** Primary retention mechanism (loss aversion)

3. **Daily Routine (3 Micro-Tasks)**
   - Task 1: "Log water intake" (1-tap)
   - Task 2: "Skincare reminder" (1-tap)
   - Task 3: "Posture check" (1-tap)
   - All 3 complete = streak maintained
   - **Why:** Micro-commitments create daily value, not just one-time scan

4. **Subscription Paywall**
   - Free: 1 scan/week, basic rating
   - Pro: Unlimited scans, detailed analysis, streak freeze access
   - $14.99/month CAD (RevenueCat)
   - **Why:** Revenue signal, tests willingness to pay

5. **Streak Freeze IAP**
   - $1.99 one-time purchase
   - Prevents streak loss for 1 missed day
   - **Why:** Impulse purchase, tests IAP conversion

6. **Push Notifications**
   - Daily reminder (user's chosen time)
   - Streak at risk (if not completed by evening)
   - **Why:** Re-engagement trigger

### Nice-to-Have (Only If Trivial)

1. **Progress Photo Comparison**
   - Side-by-side slider (Day 1 vs. Today)
   - **Only if:** Can use Vision framework alignment (1-2 hours max)

2. **Basic Onboarding**
   - 3 screens: Welcome → Permission → First Scan
   - **Only if:** Can be done in 30 minutes

### Explicitly Excluded

1. **Social Features (Growth Circles, Leaderboards)**
   - **Why:** Complex, requires backend sync, not needed for MVP loop validation

2. **Habit Stacking (Anchor Habits)**
   - **Why:** Requires onboarding questions, adds complexity. Test basic streak first.

3. **Churn Prediction (Firebase Predictions)**
   - **Why:** Requires 100+ days of data. MVP is days, not months.

4. **Win-Back Email/SMS Campaigns**
   - **Why:** Requires CRM setup, CASL compliance. Test in-app retention first.

5. **Daily Roadmap (90-Day Journey)**
   - **Why:** Complex, requires AI generation. Micro-tasks are sufficient for MVP.

6. **Progress Visualization (Charts, Graphs)**
   - **Why:** Nice-to-have, not core loop. Add if retention works.

7. **Multiple Streak Types (Grooming, Posture, Skincare)**
   - **Why:** Adds complexity. One global streak is enough to test loss aversion.

8. **AI Coaching / Personalized Recommendations**
   - **Why:** Requires complex AI. Basic rating + micro-tasks test core loop.

---

## 4. UX FLOW (Text Wireframe)

### Screen 1: Onboarding - Welcome
**Purpose:** Set expectation, request permissions  
**UI:** 
- App name/logo
- "Get your AI facial analysis in seconds"
- "Continue" button
**Why:** Fast entry, no friction

### Screen 2: Onboarding - Permissions
**Purpose:** Request camera permission  
**UI:**
- "We need camera access to analyze your face"
- "All processing happens on your device (privacy-first)"
- "Allow Camera" button
**Why:** Legal compliance (explicit consent, local processing)

### Screen 3: First Scan
**Purpose:** Capture face for analysis  
**UI:**
- Camera viewfinder
- "Position face in frame" overlay
- "Take Photo" button (captures front)
- "Take Side Photo" button (captures side)
**Why:** Core value delivery

### Screen 4: Processing
**Purpose:** Show AI is working  
**UI:**
- Loading spinner
- "Analyzing your face..." text
- Progress bar (0-100%, completes in <1 second)
**Why:** Reduces perceived wait time

### Screen 5: Results (Free Tier)
**Purpose:** Show rating, trigger curiosity gap  
**UI:**
- Large rating number (e.g., "7.2/10")
- "Your Top Strength: [Feature]"
- "Your Top Weakness: [Feature]" (blurred)
- "Unlock detailed analysis" button (paywall)
- "See your daily routine" button (free, goes to Screen 6)
**Why:** Variable reward + curiosity gap = conversion trigger

### Screen 6: Daily Routine
**Purpose:** Create daily value, maintain streak  
**UI:**
- Streak counter at top ("🔥 1 Day Streak")
- 3 checkboxes:
  - ☐ "Log water intake" (1-tap)
  - ☐ "Skincare reminder" (1-tap)
  - ☐ "Posture check" (1-tap)
- "Complete all 3 to maintain your streak"
- "Daily Insight" (unlocked after all 3 complete)
**Why:** Micro-commitments create daily return reason

### Screen 7: Paywall (Subscription)
**Purpose:** Convert free users to paid  
**UI:**
- "Unlock Pro Features"
- "Unlimited scans"
- "Detailed analysis"
- "Streak freeze protection"
- "$14.99/month" button
- "No thanks" button (small, bottom)
**Why:** Revenue signal, tests willingness to pay

### Screen 8: Home Screen (Post-Onboarding)
**Purpose:** Daily entry point  
**UI:**
- Streak counter (top)
- "Scan Face" button (large, center)
- "Daily Routine" button (below scan)
- "Your Progress" (if photos exist, shows comparison)
**Why:** Clear daily actions, streak visibility

---

## 5. DATA COLLECTED (Critical Section)

### Data Point 1: Facial Images
**What:** Front + side profile photos  
**Why needed:** Core feature (AI analysis)  
**Type:** User-provided voluntarily (camera capture)  
**Storage:** Local-only (Core Data, never cloud)  
**Reversible:** Yes (user can delete app, data deleted)  
**Legal risk:** LOW (local-only, explicit consent, no cloud storage)

### Data Point 2: AI Rating + Analysis
**What:** Numerical rating (1-10), strengths/weaknesses  
**Why needed:** Core value proposition  
**Type:** Generated from facial images (on-device)  
**Storage:** Local-only (Core Data)  
**Reversible:** Yes (deleted with app)  
**Legal risk:** LOW (no biometric templates stored, just results)

### Data Point 3: Streak Data
**What:** Current streak count, last completion date  
**Why needed:** Retention mechanism  
**Type:** User behavior (implicit)  
**Storage:** Local (Core Data) + Firebase (optional sync, user consent)  
**Reversible:** Yes (can reset streak, delete data)  
**Legal risk:** LOW (not sensitive, behavioral data)

### Data Point 4: Daily Routine Completion
**What:** Which tasks completed, timestamps  
**Why needed:** Streak maintenance logic  
**Type:** User behavior (implicit)  
**Storage:** Local (Core Data)  
**Reversible:** Yes (can be ignored/deleted)  
**Legal risk:** LOW (not sensitive)

### Data Point 5: Subscription Status
**What:** Is user subscribed? (Pro vs. Free)  
**Why needed:** Feature gating  
**Type:** User-provided (purchase decision)  
**Storage:** RevenueCat (handles App Store)  
**Reversible:** Yes (user can cancel anytime)  
**Legal risk:** LOW (standard subscription data)

### Data Point 6: Push Notification Token
**What:** Device token for notifications  
**Why needed:** Re-engagement  
**Type:** Device identifier  
**Storage:** Firebase Cloud Messaging  
**Reversible:** Yes (user can disable notifications)  
**Legal risk:** LOW (standard notification token, not biometric)

### Data Point 7: Analytics Events (Optional)
**What:** App opens, button clicks, screen views  
**Why needed:** Understand user behavior  
**Type:** Behavioral (implicit)  
**Storage:** Firebase Analytics (anonymized)  
**Reversible:** Yes (can disable analytics)  
**Legal risk:** LOW (anonymized, standard analytics)

### Explicitly NOT Collected:
- ❌ Biometric templates (facial embeddings)
- ❌ Cloud-stored facial images
- ❌ Email addresses (unless user subscribes, then handled by RevenueCat)
- ❌ Phone numbers
- ❌ Location data
- ❌ Third-party ad tracking IDs

**Why:** Minimize legal risk, avoid irreversible data collection, keep MVP clean for potential acquisition.

---

## 6. MONETIZATION (Fast But Clean)

### Primary: Subscription ($14.99/month CAD)

**What users pay for:**
- Unlimited facial scans (vs. 1/week free)
- Detailed analysis (vs. basic rating)
- Streak freeze access (vs. no protection)

**Why not deceptive:**
- Clear value proposition (unlimited vs. limited)
- No fake scarcity ("Only 3 left!")
- No dark patterns (easy cancellation via App Store)
- Transparent pricing (shown upfront)

**Revenue signal:**
- If 10%+ convert = willingness to pay validated
- If <5% convert = pricing or value mismatch

### Secondary: Streak Freeze IAP ($1.99)

**What users pay for:**
- One-time purchase to prevent streak loss
- Available when streak is at risk (missed day)

**Why not deceptive:**
- Clear utility (protect streak)
- Not forced (user chooses)
- One-time purchase (not subscription trap)

**Revenue signal:**
- If 5%+ of users buy = loss aversion works
- If <2% buy = streak not valuable enough

### What This Proves:
- Users will pay for facial analysis (subscription conversion)
- Loss aversion drives purchases (streak freeze IAP)
- Revenue model is viable (if metrics hit targets)

---

## 7. TECHNICAL IMPLEMENTATION OUTLINE

### Frontend: Native iOS (SwiftUI)

**Why:** Fastest to build with AI, native performance, iOS revenue premium

**Structure:**
```
LooksmaxxingApp/
├── Views/
│   ├── OnboardingView.swift
│   ├── CameraView.swift
│   ├── ResultsView.swift
│   ├── DailyRoutineView.swift
│   ├── PaywallView.swift
│   └── HomeView.swift
├── ViewModels/
│   ├── ScanViewModel.swift (handles Core ML)
│   ├── StreakViewModel.swift (manages streak logic)
│   └── SubscriptionViewModel.swift (RevenueCat integration)
├── Models/
│   ├── FaceAnalysis.swift (rating + analysis)
│   ├── Streak.swift (Core Data entity)
│   └── DailyTask.swift (Core Data entity)
├── Services/
│   ├── CoreMLService.swift (AI processing)
│   ├── RevenueCatService.swift (subscriptions)
│   └── NotificationService.swift (push notifications)
└── CoreML/
    └── FaceMesh.mlpackage (converted MediaPipe model)
```

**AI Coding Approach:**
- Use Claude Code / Cursor to generate SwiftUI views
- Provide screen descriptions, get code
- Iterate on UI until functional

### Backend: Firebase (Minimal)

**What's needed:**
- Firebase Auth (optional, can skip for MVP - use device ID)
- Firebase Cloud Messaging (push notifications)
- Firebase Analytics (optional, for metrics)

**What's NOT needed:**
- Custom backend API
- Database (use Core Data local)
- Server-side processing (all on-device)

**Why minimal:** Reduce complexity, faster to build, fewer failure points

### Data Storage: Core Data (Local-First)

**Schema:**
```
Streak (Core Data Entity)
- currentStreak: Int
- lastCompletionDate: Date
- totalDays: Int

DailyTask (Core Data Entity)
- taskType: String (water, skincare, posture)
- completedDate: Date
- isCompleted: Bool

FaceAnalysis (Core Data Entity)
- rating: Double
- strengths: [String]
- weaknesses: [String]
- scanDate: Date
- frontImage: Data (local only)
- sideImage: Data (local only)
```

**Why Core Data:**
- Local-first = privacy compliance
- Works offline = no broken streaks
- Fast = no network delays
- Simple = less to break

### Auth: Device ID (No Account Required)

**Approach:**
- Generate UUID on first launch
- Store in UserDefaults
- Use as user identifier

**Why no account:**
- Faster onboarding (no email/password)
- Less friction = higher conversion
- Can add accounts later if needed

**Trade-off:** Can't sync across devices (acceptable for MVP)

### What Can Be Mocked/Hard-Coded:

1. **AI Rating Algorithm**
   - For MVP: Use simple heuristic (symmetry, features)
   - Can replace with real Core ML later
   - **Why:** Tests loop, not AI accuracy

2. **Streak Logic**
   - Hard-code: 24-hour window for streak maintenance
   - Can refine later based on user behavior
   - **Why:** Simple = less bugs

3. **Push Notification Content**
   - Hard-code: 3-4 notification templates
   - Can personalize later
   - **Why:** Fast to implement, tests re-engagement

---

## 8. LEGAL & PLATFORM SAFETY GUARDRAILS (MVP-Only)

### What Is Explicitly Claimed:

**App Description (App Store):**
- "AI-powered facial analysis for self-improvement"
- "Get your attractiveness rating and personalized insights"
- "Track your progress daily with streaks"
- "All processing happens on your device (privacy-first)"

**Why:** Accurate, not misleading, sets expectations

### What Is Explicitly NOT Claimed:

- ❌ "Medical advice" or "health diagnosis"
- ❌ "Guaranteed results" or "scientific accuracy"
- ❌ "Professional assessment"
- ❌ "Clinical-grade analysis"

**Why:** Avoids medical/health claims that trigger regulations

### Consent Framing (Simple, Non-Deceptive):

**Camera Permission:**
- "We need camera access to analyze your face"
- "All processing happens on your device"
- "Your photos are never uploaded to our servers"

**Why:** Clear, honest, privacy-first messaging

**Subscription Consent:**
- "Unlock Pro for unlimited scans and detailed analysis"
- "Cancel anytime in App Store settings"
- No fake urgency, no dark patterns

**Why:** Transparent, easy cancellation, no manipulation

### App Store / Play Store Safety:

**Avoids:**
- ❌ Dark patterns (fake scarcity, forced subscriptions)
- ❌ Misleading screenshots (shows actual app)
- ❌ Medical/health claims (positioned as self-improvement)
- ❌ Biometric data in cloud (local-only = compliant)

**Why:** Reduces rejection risk, maintains platform access

### Legal Risks Intentionally Postponed:

1. **PIA (Privacy Impact Assessment) - Quebec Law 25**
   - **Postponed:** Can draft after MVP validates product
   - **Why acceptable:** Local-only storage = lower risk, can complete before scale

2. **CAI Notification (60-day requirement)**
   - **Postponed:** Can send 60 days before public launch
   - **Why acceptable:** MVP is test phase, not public launch

3. **Full Legal Review**
   - **Postponed:** Can get legal review before scale
   - **Why acceptable:** MVP tests product, not legal perfection

**Risk mitigation:** Local-only storage + explicit consent = legally survivable for MVP phase.

---

## 9. KILL METRICS (Non-Negotiable)

### 3 Metrics That Prove It Works (Within 7-14 Days):

1. **Day 7 Retention >20%**
   - **Why:** Users return after first scan = loop works
   - **How to measure:** Firebase Analytics cohort retention
   - **If fails:** Core loop doesn't work, don't build more features

2. **Conversion Rate >10%**
   - **Why:** Users pay = value proposition validated
   - **How to measure:** RevenueCat subscription conversion
   - **If fails:** Pricing or value mismatch, need to pivot

3. **Streak Maintenance >30%**
   - **Why:** Users maintain 3+ day streak = retention mechanism works
   - **How to measure:** Core Data query (users with streak >= 3)
   - **If fails:** Streak not motivating, need different retention hook

### 3 Signals That Mean Stop Immediately:

1. **Day 7 Retention <10%**
   - **Why:** Users don't return = core loop broken
   - **Action:** Kill or pivot (don't add features hoping it fixes)

2. **Conversion Rate <2%**
   - **Why:** Users won't pay = revenue model broken
   - **Action:** Kill or pivot pricing/value proposition

3. **App Store Rejection or Legal Warning**
   - **Why:** Platform ban = game over
   - **Action:** Kill immediately, can't recover from platform ban

**Decision rule:** If ANY kill signal appears, stop. Don't build more hoping it fixes the problem.

---

## 10. WHAT NOT TO BUILD YET (Important)

### Excluded Features (And Why):

1. **Social Features (Growth Circles, Leaderboards)**
   - **Why:** Complex backend, requires user accounts, not needed for core loop
   - **When:** After MVP validates retention

2. **Habit Stacking (Anchor Habits)**
   - **Why:** Requires onboarding questions, adds complexity
   - **When:** After basic streak proves retention works

3. **Churn Prediction (Firebase Predictions)**
   - **Why:** Requires 100+ days of data, MVP is days not months
   - **When:** After MVP has enough data to train model

4. **Win-Back Email/SMS Campaigns**
   - **Why:** Requires CRM, CASL compliance, complex setup
   - **When:** After MVP validates in-app retention first

5. **Daily Roadmap (90-Day Journey)**
   - **Why:** Complex AI generation, not needed for core loop
   - **When:** After micro-tasks prove daily value

6. **Progress Visualization (Charts, Graphs)**
   - **Why:** Nice-to-have, not core loop
   - **When:** After retention works, add polish

7. **Multiple Streak Types**
   - **Why:** Adds complexity, one streak tests loss aversion
   - **When:** After single streak proves retention

8. **AI Coaching / Personalized Recommendations**
   - **Why:** Complex AI, not needed for MVP loop
   - **When:** After basic rating proves value

9. **Cloud Sync / Multi-Device**
   - **Why:** Requires backend, user accounts, not needed for MVP
   - **When:** After MVP validates, add for retention

10. **Advanced Analytics Dashboard**
   - **Why:** Nice-to-have, not core loop
   - **When:** After MVP validates, add for optimization

**Principle:** If it doesn't test the core loop or generate revenue, exclude it from MVP.

---

## 11. FINAL MVP VERDICT

**Is this MVP worth building this week?**

**YES, IF:**
- You can build it in hours using AI coding tools
- You're willing to kill it if metrics fail (Day 7 retention <10%, conversion <2%)
- You accept this tests the loop, not the full product vision

**What would make it not worth continuing after initial launch?**

**Kill if:**
- Day 7 retention <10% (core loop broken, don't add features)
- Conversion rate <2% (users won't pay, pricing/value broken)
- App Store rejection (platform ban = game over)
- Legal warning (regulatory risk = not worth continuing)

**The MVP is a test, not a product.** If the test fails, kill it. Don't build more features hoping it fixes retention. The research shows competitors failed retention—if your MVP also fails, that's valuable data. Better to fail fast in days than after months of development.

**Build it this week. Test it for 7-14 days. Kill it if metrics fail. Iterate if metrics pass.**

---

## 12. DETAILED IMPLEMENTATION PROMPTS (AI Coding Agent)

### PROMPT 1: Project Setup & Core Data Model

**Prompt for AI Coding Agent:**

```
Create a new iOS SwiftUI app called "LooksmaxxingApp" with the following structure:

1. Set up Core Data with the following entities:
   - Streak entity:
     * currentStreak: Int16
     * lastCompletionDate: Date
     * totalDays: Int16
   
   - DailyTask entity:
     * taskType: String
     * completedDate: Date
     * isCompleted: Bool
     * id: UUID
   
   - FaceAnalysis entity:
     * rating: Double
     * strengths: [String] (transformable)
     * weaknesses: [String] (transformable)
     * scanDate: Date
     * frontImage: Data (optional)
     * sideImage: Data (optional)
     * id: UUID

2. Create a CoreDataManager singleton class that:
   - Initializes Core Data stack
   - Provides saveContext() method
   - Provides fetch methods for each entity
   - All operations must be thread-safe

3. Create a UserDefaults extension for:
   - deviceID: String (UUID generated on first launch)
   - hasCompletedOnboarding: Bool
   - lastScanDate: Date
   - notificationTime: Date (user's preferred notification time)

4. Set up Info.plist with:
   - NSCameraUsageDescription: "We need camera access to analyze your face. All processing happens on your device."
   - NSPhotoLibraryUsageDescription: (not needed for MVP)

Use SwiftUI with MVVM pattern. All code must be production-ready, handle errors gracefully.
```

---

### PROMPT 2: Onboarding Flow

**Prompt for AI Coding Agent:**

```
Create an OnboardingView.swift that:

1. Screen 1 - Welcome:
   - App name/logo at top
   - Text: "Get your AI facial analysis in seconds"
   - Large "Continue" button at bottom
   - On tap, navigate to Screen 2

2. Screen 2 - Permissions:
   - Text: "We need camera access to analyze your face"
   - Text: "All processing happens on your device (privacy-first)"
   - Text: "Your photos are never uploaded to our servers"
   - Large "Allow Camera" button
   - On tap, request camera permission using AVCaptureDevice.requestAccess(for: .video)
   - If granted, navigate to CameraView
   - If denied, show alert: "Camera access is required. Please enable in Settings."

3. Use NavigationStack for navigation
4. Store hasCompletedOnboarding in UserDefaults after permission granted
5. Use @AppStorage for state management
6. Add smooth transitions between screens
```

---

### PROMPT 3: Camera View & Face Capture

**Prompt for AI Coding Agent:**

```
Create a CameraView.swift that:

1. Uses AVFoundation to show camera preview
2. Has two capture buttons:
   - "Take Front Photo" (captures front-facing selfie)
   - "Take Side Photo" (captures side profile)
   
3. After both photos captured:
   - Show processing screen (Screen 4)
   - Process images using CoreMLService
   - Navigate to ResultsView with analysis results

4. Camera preview must:
   - Fill screen
   - Show face detection overlay (optional, nice-to-have)
   - Handle camera permissions gracefully
   - Work on iPhone 12+ (iOS 15+)

5. Image capture:
   - Save to temporary storage
   - Convert to UIImage
   - Pass to CoreMLService for processing

6. Error handling:
   - Camera unavailable
   - Permission denied
   - Capture failure

Use @StateObject for view model, @Published for state updates.
```

---

### PROMPT 4: Core ML Service (AI Processing)

**Prompt for AI Coding Agent:**

```
Create a CoreMLService.swift that:

1. For MVP, use a MOCKED rating algorithm (not real Core ML):
   - Function: analyzeFace(frontImage: UIImage, sideImage: UIImage) -> FaceAnalysis
   - Calculate rating (1-10) using simple heuristics:
     * Facial symmetry (use Vision framework VNDetectFaceLandmarksRequest)
     * Face width/height ratio
     * Eye spacing ratio
     * Jawline angle (approximate from side image)
   - Add slight randomization (±0.2) for variable reward
   - Generate 3 strengths and 3 weaknesses from predefined lists:
     * Strengths: ["Strong jawline", "Symmetrical features", "Clear skin", "Well-proportioned face", "Defined cheekbones"]
     * Weaknesses: ["Improve jawline definition", "Enhance skin clarity", "Balance facial symmetry", "Optimize eye spacing", "Refine facial proportions"]

2. Processing must complete in <1 second (use async/await)

3. Return FaceAnalysis model:
   - rating: Double (1.0-10.0)
   - strengths: [String] (top 3)
   - weaknesses: [String] (top 3)
   - processingTime: TimeInterval

4. Save results to Core Data (FaceAnalysis entity)

5. Error handling:
   - No face detected
   - Processing timeout
   - Invalid image

Note: This is mocked for MVP speed. Can replace with real Core ML model later.
```

---

### PROMPT 5: Results View (Free Tier with Paywall)

**Prompt for AI Coding Agent:**

```
Create a ResultsView.swift that:

1. Displays FaceAnalysis results:
   - Large rating number (e.g., "7.2/10") at top, animated appearance
   - "Your Top Strength: [Feature]" (unblurred)
   - "Your Top Weakness: [Feature]" (blurred with overlay)
   - Haptic feedback on rating reveal (UIImpactFeedbackGenerator)

2. Two buttons:
   - "Unlock detailed analysis" (large, primary) → triggers PaywallView
   - "See your daily routine" (small, secondary) → navigates to DailyRoutineView

3. Free tier limitations:
   - Check SubscriptionViewModel.isProUser
   - If free: Show blurred weakness, limit to 1 scan/week
   - If pro: Show all details, unlimited scans

4. Check scan limit:
   - Query Core Data for last scan date
   - If <7 days ago and user is free: Show "You've used your weekly scan. Upgrade to Pro for unlimited scans."
   - If pro or >7 days: Allow scan

5. Save scan to Core Data (FaceAnalysis entity) with:
   - Current date
   - Rating and analysis
   - Images (as Data, local only)

6. Use @StateObject for SubscriptionViewModel
7. Add smooth animations for rating reveal
```

---

### PROMPT 6: Daily Routine View (Micro-Commitments)

**Prompt for AI Coding Agent:**

```
Create a DailyRoutineView.swift that:

1. Display streak counter at top:
   - "🔥 [X] Day Streak" (large, prominent)
   - Query StreakViewModel for current streak
   - Animate streak number update

2. Three micro-task checkboxes:
   - ☐ "Log water intake" (1-tap to complete)
   - ☐ "Skincare reminder" (1-tap to complete)
   - ☐ "Posture check" (1-tap to complete)

3. Task completion logic:
   - On tap, mark task as completed (save to Core Data DailyTask entity)
   - Show checkmark animation
   - Haptic feedback (UINotificationFeedbackGenerator)
   - When all 3 complete:
     * Update streak (increment if within 24h window)
     * Show "Daily Insight" (unlock personalized tip)
     * Celebrate with animation + haptic

4. Streak maintenance logic:
   - Check if last completion was within 24 hours
   - If yes: Increment streak
   - If no: Reset streak to 0, show "Streak lost! Buy Streak Freeze for $1.99"

5. Daily Insight (after all tasks complete):
   - Show tip from predefined list:
     * "Drinking 8 glasses of water daily improves skin clarity"
     * "Consistent skincare routine shows results in 2-3 weeks"
     * "Good posture enhances facial definition"
   - Rotate tips daily (don't repeat same day)

6. Use StreakViewModel to manage streak logic
7. Save all task completions to Core Data
8. Update streak counter in real-time
```

---

### PROMPT 7: Streak ViewModel (Retention Logic)

**Prompt for AI Coding Agent:**

```
Create a StreakViewModel.swift (ObservableObject) that:

1. Manages streak state:
   - @Published var currentStreak: Int = 0
   - @Published var lastCompletionDate: Date?
   - @Published var totalDays: Int = 0

2. Methods:
   - loadStreak(): Load from Core Data (Streak entity)
   - updateStreak(): Check if user completed all 3 tasks today
     * If yes and within 24h of last completion: increment streak
     * If no or >24h: reset streak to 0
   - canMaintainStreak(): Check if user can still maintain streak today
   - getStreakFreezeAvailable(): Check if streak is at risk (missed day)

3. Streak logic:
   - 24-hour window: User must complete all 3 tasks within 24h of last completion
   - If user completes tasks on Day 1 at 10 AM, they have until Day 2 at 10 AM
   - After 10 AM Day 2, streak resets unless they use Streak Freeze

4. Streak Freeze logic:
   - If streak is at risk (missed 24h window):
     * Show option to buy Streak Freeze ($1.99 IAP)
     * If purchased: Extend window by 24h, don't reset streak
   - Check SubscriptionViewModel for Streak Freeze purchase

5. Persist to Core Data:
   - Save streak updates immediately
   - Use CoreDataManager singleton

6. Error handling:
   - Core Data save failures
   - Date calculation errors

Use Combine for reactive updates. All operations must be thread-safe.
```

---

### PROMPT 8: Subscription ViewModel & Paywall

**Prompt for AI Coding Agent:**

```
Create a SubscriptionViewModel.swift (ObservableObject) that:

1. Integrates RevenueCat SDK:
   - Import Purchases (RevenueCat)
   - Configure with API key on app launch
   - Set up delegate for purchase updates

2. State management:
   - @Published var isProUser: Bool = false
   - @Published var subscriptionStatus: SubscriptionStatus = .free
   - @Published var availableProducts: [StoreProduct] = []

3. Methods:
   - configureRevenueCat(): Initialize SDK with API key
   - loadProducts(): Fetch available products from App Store
   - purchaseSubscription(productId: String): Purchase Pro subscription
   - restorePurchases(): Restore previous purchases
   - checkSubscriptionStatus(): Check current subscription status

4. Products to configure in RevenueCat dashboard:
   - Pro Monthly: "pro_monthly" - $14.99 CAD/month
   - Streak Freeze: "streak_freeze" - $1.99 CAD (one-time)

5. Subscription entitlements:
   - "pro": Grants unlimited scans, detailed analysis, streak freeze access
   - Check entitlement in app: Purchases.shared.checkTrialOrIntroDiscountEligibility()

6. Free tier limits:
   - 1 scan per week (check lastScanDate in UserDefaults)
   - Basic rating only (blurred weaknesses)
   - No streak freeze access

7. Error handling:
   - Purchase failures
   - Network errors
   - Receipt validation errors

Create PaywallView.swift that:
- Shows subscription benefits
- Displays "$14.99/month" button
- Calls SubscriptionViewModel.purchaseSubscription()
- Shows "No thanks" button (small, bottom)
- Handles purchase success/failure
```

---

### PROMPT 9: Push Notifications Service

**Prompt for AI Coding Agent:**

```
Create a NotificationService.swift that:

1. Requests notification permission:
   - UNUserNotificationCenter.current().requestAuthorization()
   - Show permission request after first scan (not during onboarding)

2. Schedules daily notifications:
   - Daily reminder: User's preferred time (default 8 AM)
   - Streak at risk: If tasks not completed by 8 PM
   - Use UNTimeIntervalNotificationTrigger or UNCalendarNotificationTrigger

3. Notification content:
   - Daily reminder: "Time for your daily routine! Maintain your [X] day streak"
   - Streak at risk: "Your streak is at risk! Complete today's routine in 4 hours"
   - Use UNMutableNotificationContent

4. Firebase Cloud Messaging setup (optional for MVP):
   - Can skip for MVP, use local notifications only
   - If adding: Configure FCM token registration

5. Notification actions:
   - "Open App" action (UNNotificationAction)
   - Deep link to DailyRoutineView when tapped

6. Handle notification taps:
   - In AppDelegate/SceneDelegate: Handle UNUserNotificationCenterDelegate
   - Navigate to appropriate screen based on notification type

7. User preferences:
   - Allow user to set notification time (in Settings view)
   - Store in UserDefaults
   - Update scheduled notifications when time changes

8. Cancel notifications:
   - Cancel all when user disables notifications
   - Cancel daily reminder if user completes tasks early

All notifications must be opt-in (explicit permission request).
```

---

### PROMPT 10: Home View (Daily Entry Point)

**Prompt for AI Coding Agent:**

```
Create a HomeView.swift that:

1. Displays streak counter at top:
   - Large fire emoji + streak number
   - Query StreakViewModel for current streak
   - Animate updates

2. Main actions:
   - "Scan Face" button (large, center, primary color)
     * Check scan limit (1/week for free users)
     * If limit reached: Show paywall
     * If allowed: Navigate to CameraView
   - "Daily Routine" button (below scan button)
     * Navigate to DailyRoutineView

3. Progress section (if photos exist):
   - "Your Progress" header
   - Show last scan date
   - Rating from last scan
   - If 2+ scans: Show "Compare" button (navigate to comparison view)

4. Subscription status indicator:
   - If free: Show "Upgrade to Pro" banner (tappable, goes to PaywallView)
   - If pro: Show "Pro Member" badge

5. Navigation:
   - Use NavigationStack
   - Tab bar (optional for MVP): Home, Routine, Settings

6. State management:
   - @StateObject for SubscriptionViewModel
   - @StateObject for StreakViewModel
   - @StateObject for CoreDataManager

7. Refresh on appear:
   - Load latest streak
   - Check subscription status
   - Update UI accordingly

8. Empty state:
   - If no scans yet: Show "Get started" message
   - Guide user to first scan
```

---

### PROMPT 11: Core Data Manager

**Prompt for AI Coding Agent:**

```
Create a CoreDataManager.swift (Singleton) that:

1. Initializes Core Data stack:
   - Load .xcdatamodeld file
   - Create NSPersistentContainer
   - Load persistent stores
   - Handle migration if needed

2. Main context:
   - viewContext: NSManagedObjectContext (main queue)
   - backgroundContext: NSManagedObjectContext (private queue)

3. CRUD operations:
   - saveContext(): Save main context, handle errors
   - fetchStreak(): Fetch Streak entity (or create if doesn't exist)
   - fetchDailyTasks(for date: Date): Fetch tasks for specific date
   - fetchFaceAnalyses(): Fetch all scans, sorted by date
   - createFaceAnalysis(rating: Double, strengths: [String], weaknesses: [String]): Create new analysis
   - createDailyTask(type: String, completed: Bool): Create new task

4. Thread safety:
   - All Core Data operations on correct queue
   - Use perform() for background context
   - Use performAndWait() when needed

5. Error handling:
   - Log Core Data errors
   - Handle save failures gracefully
   - Don't crash app on Core Data errors

6. Convenience methods:
   - getCurrentStreak(): Returns current streak count
   - getLastScanDate(): Returns date of last scan
   - canScanToday(): Returns true if user can scan (free: 1/week, pro: unlimited)

Use @MainActor for UI updates. All Core Data operations must be thread-safe.
```

---

### PROMPT 12: App Entry Point & Navigation

**Prompt for AI Coding Agent:**

```
Create LooksmaxxingApp.swift (main app file) that:

1. Sets up app lifecycle:
   - @main struct
   - WindowGroup with initial view

2. Navigation logic:
   - Check UserDefaults.hasCompletedOnboarding
   - If false: Show OnboardingView
   - If true: Show HomeView

3. Initialize services on launch:
   - CoreDataManager.shared (initialize Core Data)
   - SubscriptionViewModel.configureRevenueCat() (setup RevenueCat)
   - NotificationService.requestPermission() (request notifications)

4. App-level state:
   - @StateObject for SubscriptionViewModel (shared across app)
   - @StateObject for StreakViewModel (shared across app)
   - Pass to child views via environmentObject

5. Handle deep links:
   - If notification tapped: Navigate to DailyRoutineView
   - If URL scheme: Handle external links

6. Error handling:
   - Global error handler
   - Log errors to console (can add Crashlytics later)

7. App Store configuration:
   - Bundle identifier
   - Version: 1.0.0
   - Build: 1

Use SwiftUI App lifecycle (not UIKit AppDelegate).
```

---

### PROMPT 13: Firebase Setup (Minimal)

**Prompt for AI Coding Agent:**

```
Set up Firebase for MVP (minimal):

1. Add Firebase iOS SDK via Swift Package Manager:
   - FirebaseAnalytics
   - FirebaseMessaging (optional, for push notifications)

2. Configure Firebase:
   - Add GoogleService-Info.plist to project
   - Call FirebaseApp.configure() in app launch

3. Analytics events to track:
   - "app_opened" (when app launches)
   - "scan_completed" (when face scan finishes)
   - "streak_maintained" (when user completes daily routine)
   - "paywall_shown" (when paywall appears)
   - "subscription_purchased" (when user subscribes)
   - "streak_freeze_purchased" (when user buys freeze)

4. User properties:
   - Set user_id: deviceID (from UserDefaults)
   - Set is_pro_user: SubscriptionViewModel.isProUser
   - Set current_streak: StreakViewModel.currentStreak

5. Push Notifications (optional for MVP):
   - Can skip FCM, use local notifications only
   - If adding: Configure FCM token registration
   - Handle remote notification delegate

6. Privacy:
   - Don't send facial images to Firebase
   - Don't send biometric data
   - Only send anonymized events

All Firebase setup must be optional (app works without it).
```

---

### PROMPT 14: Error Handling & Edge Cases

**Prompt for AI Coding Agent:**

```
Add comprehensive error handling:

1. Camera errors:
   - Permission denied: Show alert with Settings link
   - Camera unavailable: Show error message
   - Capture failure: Retry mechanism

2. Core Data errors:
   - Save failures: Log error, show user-friendly message
   - Fetch failures: Return empty results, don't crash
   - Migration errors: Handle gracefully

3. Network errors (for RevenueCat):
   - Purchase failures: Show error message
   - Receipt validation failures: Allow retry
   - Network unavailable: Cache subscription status locally

4. Subscription errors:
   - Purchase cancelled: Don't show error (user choice)
   - Purchase failed: Show error, allow retry
   - Restore failed: Show error message

5. Streak calculation errors:
   - Date calculation errors: Default to safe values
   - Timezone issues: Use device timezone consistently
   - Edge cases: Handle midnight transitions, DST changes

6. Image processing errors:
   - No face detected: Show error, allow retry
   - Processing timeout: Show error, allow retry
   - Invalid image: Show error, allow retry

7. User-friendly error messages:
   - Don't show technical errors to users
   - Provide actionable next steps
   - Allow retry for transient errors

All errors must be logged (can add Crashlytics later). App must never crash on errors.
```

---

### PROMPT 15: Testing & Validation

**Prompt for AI Coding Agent:**

```
Add basic testing infrastructure:

1. Unit tests for:
   - StreakViewModel logic (24h window, increment, reset)
   - CoreMLService rating calculation (heuristic algorithm)
   - SubscriptionViewModel entitlement checking

2. UI tests for:
   - Onboarding flow (permissions, navigation)
   - Camera capture (front + side)
   - Daily routine completion (all 3 tasks)
   - Paywall display

3. Manual testing checklist:
   - [ ] Onboarding completes successfully
   - [ ] Camera permission requested
   - [ ] Face scan works (front + side)
   - [ ] Rating displayed (<1 second)
   - [ ] Daily routine tasks complete
   - [ ] Streak increments correctly
   - [ ] Paywall displays
   - [ ] Subscription purchase works (sandbox)
   - [ ] Streak freeze IAP works (sandbox)
   - [ ] Push notifications scheduled
   - [ ] App works offline (Core Data)

4. Performance validation:
   - Face scan processing <1 second
   - UI animations smooth (60fps)
   - Core Data operations <100ms
   - App launch <2 seconds

5. Legal validation:
   - Camera permission text is clear
   - No dark patterns in paywall
   - Privacy messaging accurate
   - No medical claims

Note: For MVP, focus on manual testing. Automated tests can be added later.
```

---

## 13. BUILD ORDER (Implementation Sequence)

### Phase 1: Foundation (2-3 hours)
1. Project setup (Xcode, Core Data, file structure)
2. CoreDataManager implementation
3. UserDefaults extension
4. Basic navigation structure

### Phase 2: Core Features (4-6 hours)
5. OnboardingView (Welcome + Permissions)
6. CameraView (face capture)
7. CoreMLService (mocked rating algorithm)
8. ResultsView (display rating + paywall trigger)

### Phase 3: Retention Features (3-4 hours)
9. DailyRoutineView (3 micro-tasks)
10. StreakViewModel (streak logic)
11. HomeView (daily entry point)

### Phase 4: Monetization (2-3 hours)
12. SubscriptionViewModel (RevenueCat integration)
13. PaywallView (subscription offer)
14. Streak Freeze IAP integration

### Phase 5: Polish (1-2 hours)
15. Push notifications (NotificationService)
16. Error handling
17. Basic animations + haptics

**Total estimated time: 12-18 hours** (can be done in 1-2 days with AI coding)

---

## 14. DEPENDENCIES & SETUP

### Required SDKs (Swift Package Manager):

1. **RevenueCat SDK**
   - Package: https://github.com/RevenueCat/purchases-ios
   - Version: Latest stable
   - Purpose: Subscription + IAP management

2. **Firebase iOS SDK** (optional for MVP)
   - Package: Firebase iOS SDK
   - Modules: Analytics, Messaging (optional)
   - Purpose: Analytics + push notifications

### Required Accounts:

1. **Apple Developer Account**
   - Cost: $99/year
   - Needed for: App Store submission, push notifications, RevenueCat

2. **RevenueCat Account**
   - Cost: Free tier (up to $10k MRR)
   - Needed for: Subscription management, analytics

3. **Firebase Account** (optional)
   - Cost: Free tier (sufficient for MVP)
   - Needed for: Analytics, push notifications (optional)

### App Store Connect Setup:

1. Create app listing
2. Configure in-app purchases:
   - Pro Monthly: $14.99 CAD/month (auto-renewable subscription)
   - Streak Freeze: $1.99 CAD (non-consumable)
3. Set up RevenueCat products (link to App Store products)
4. Configure subscription groups

---

## 15. MOCK DATA & TESTING

### Mock Rating Algorithm (For MVP Speed):

```swift
func calculateRating(frontImage: UIImage, sideImage: UIImage) -> Double {
    // Use Vision framework to detect face landmarks
    let request = VNDetectFaceLandmarksRequest()
    // Calculate symmetry, ratios, etc.
    // Add randomization: baseRating + (random -0.2 to +0.2)
    let baseRating = 7.0 // Can be calculated from face metrics
    let randomVariation = Double.random(in: -0.2...0.2)
    return min(10.0, max(1.0, baseRating + randomVariation))
}
```

### Test Scenarios:

1. **First-time user flow:**
   - Onboarding → Permissions → Scan → Results → Daily Routine

2. **Free user limit:**
   - Scan once → Try to scan again <7 days → Paywall shown

3. **Streak maintenance:**
   - Complete all 3 tasks → Streak increments → Miss a day → Streak resets

4. **Subscription purchase:**
   - View paywall → Purchase → Unlock Pro features

5. **Streak freeze purchase:**
   - Streak at risk → Purchase freeze → Streak maintained

---

## 16. APP STORE SUBMISSION CHECKLIST

### Before Submission:

1. **App Information:**
   - [ ] App name: "Aesthetic Optimizer" (or similar, avoid "looksmaxxing" for mainstream)
   - [ ] Subtitle: "AI Facial Analysis & Self-Improvement"
   - [ ] Category: Health & Fitness or Lifestyle
   - [ ] Age rating: 17+ (due to body image content)

2. **Screenshots:**
   - [ ] iPhone screenshots (6.7", 6.5", 5.5" displays)
   - [ ] Show: Onboarding, Scan, Results, Daily Routine, Streak
   - [ ] No misleading screenshots

3. **App Description:**
   - [ ] "AI-powered facial analysis for self-improvement"
   - [ ] "Track your progress daily with streaks"
   - [ ] "All processing happens on your device (privacy-first)"
   - [ ] No medical/health claims

4. **Privacy:**
   - [ ] Privacy policy URL (can be simple, hosted on GitHub Pages)
   - [ ] App Privacy details in App Store Connect:
     * Camera: Used for facial analysis
     * No data collection (local-only)
     * No third-party sharing

5. **In-App Purchases:**
   - [ ] Pro Monthly subscription configured
   - [ ] Streak Freeze IAP configured
   - [ ] Test with sandbox accounts

6. **Legal:**
   - [ ] Terms of Service (simple, can be in-app)
   - [ ] Privacy Policy (must mention local-only processing)
   - [ ] No medical disclaimers needed (not claiming medical advice)

---

## 17. POST-MVP ITERATION PLAN

### If Metrics Pass (Day 7 retention >20%, conversion >10%):

**Week 2-3:**
1. Add real Core ML model (replace mocked algorithm)
2. Add progress photo comparison (Vision framework)
3. Optimize paywall (A/B test pricing)
4. Add more daily insights (personalized tips)

**Week 4+:**
1. Add habit stacking (anchor habits)
2. Add churn prediction (Firebase Predictions)
3. Add win-back campaigns (email/SMS)
4. Add social features (Growth Circles)

### If Metrics Fail:

**Kill criteria:**
- Day 7 retention <10% → Kill or pivot
- Conversion <2% → Kill or pivot pricing
- App Store rejection → Kill immediately

**Don't add features hoping it fixes retention. The MVP is a test.**

---

## 18. FINAL IMPLEMENTATION CHECKLIST

### Before Building:
- [ ] Xcode 15+ installed
- [ ] Apple Developer account ($99/year)
- [ ] RevenueCat account created
- [ ] Firebase project created (optional)
- [ ] App Store Connect app created
- [ ] In-app purchases configured

### During Building:
- [ ] Follow prompts in order (1-15)
- [ ] Test each component as you build
- [ ] Don't skip error handling
- [ ] Keep it simple (MVP, not full product)

### Before Launch:
- [ ] Test on real device (iPhone 12+)
- [ ] Test subscription purchase (sandbox)
- [ ] Test streak logic (24h window)
- [ ] Test offline functionality
- [ ] Verify no crashes
- [ ] Check legal compliance (camera permission text, privacy messaging)

### Launch:
- [ ] Submit to App Store (TestFlight first)
- [ ] Get 10-20 beta testers
- [ ] Monitor metrics (Day 7 retention, conversion)
- [ ] Kill if metrics fail

---

**Last Updated:** January 12, 2026
