# MVP Specification: Looksmaxxing App (Hours-to-Ship)

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

**Last Updated:** January 12, 2026
