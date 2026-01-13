# Canonical Project Brief: Aesthetic Optimizer

**Date:** January 12, 2026  
**Version:** 1.0 (Consolidated from 10+ source documents)  
**Status:** MVP Built, Pending Validation

---

## 1. CLEAN PROJECT SUMMARY

This is an iOS mobile application that provides AI-powered facial analysis with a daily streak retention system. Users take selfies (front + side profile), receive a numerical attractiveness rating (1-10) with strengths/weaknesses, and complete daily micro-tasks to maintain engagement streaks.

The app monetizes through a $14.99 CAD/month subscription (unlimited scans, detailed analysis) and $1.99 IAP streak freezes. All facial processing occurs on-device using Apple's Vision framework. No images are uploaded to servers.

The core hypothesis: Users will pay for facial analysis AND return daily if the app provides ongoing value through streaks and micro-tasks (unlike competitors who treated this as one-time diagnostic).

---

## 2. CORE GOALS

- Validate that users will pay $14.99/month for AI facial analysis
- Achieve Day 7 retention >20% (competitors achieved <15%)
- Achieve subscription conversion rate >10%
- Achieve 30%+ of users maintaining 3+ day streaks
- Process facial analysis in <1 second on-device
- Maintain zero legal complaints or platform warnings
- Determine within 7-14 days if the core loop works

---

## 3. NON-GOALS / EXCLUSIONS

**Explicitly excluded from MVP:**
- Social features (leaderboards, friend circles, sharing)
- Cloud sync / multi-device support
- Real Core ML model (using Vision framework heuristics)
- Progress visualization (charts, graphs)
- Habit stacking onboarding questions
- Churn prediction systems
- Win-back email/SMS campaigns
- AI coaching / personalized recommendations
- 90-day journey roadmaps
- Multiple streak types
- Advanced analytics dashboard

**Intentionally deferred decisions:**
- Full legal review (acceptable for test phase)
- Privacy Impact Assessment (post-MVP if validated)
- CAI notification (60 days before public launch)
- Firebase integration (optional for MVP)
- RevenueCat full implementation (simulated for testing)

---

## 4. TARGET USER

**Demographics:**
- Age: 18-34 (likely skews younger)
- Gender: Primarily male
- Interest: Self-improvement, appearance optimization
- Tech: iPhone 12+ users (iOS 15+)

**Psychographics:**
- High intent: Actively searching for self-improvement tools
- Motivated by: Quantified feedback, progress tracking, social validation
- Pain point: Want objective assessment of facial appearance
- Behavior pattern: May treat as one-time diagnostic (retention challenge)

**User source:**
- Looksmaxxing/mewing communities on Reddit, TikTok
- Followers of aesthetic self-improvement influencers

[UNSPECIFIED]: Geographic distribution, income level, existing app usage patterns

---

## 5. CORE PRODUCT LOOP

**Entry:**
User downloads app → Completes onboarding (2 screens) → Grants camera permission

**Action:**
Takes front selfie → Takes side profile photo → Waits <1 second

**Value delivery:**
Receives rating (1-10) → Sees top strength → Sees blurred weakness (conversion trigger) → Option to unlock full analysis ($14.99/month)

**Retention hook:**
Directed to Daily Routine → Completes 3 micro-tasks (water, skincare, posture) → Streak counter increments → Daily insight unlocks

**Return trigger:**
Push notification next day → "Your streak is at risk" → Complete tasks or lose streak → Loss aversion drives return

**Loop repeats daily.** Streak becomes primary retention driver through loss aversion.

---

## 6. MONETIZATION INTENT

**Confirmed:**
- Subscription: $14.99 CAD/month (auto-renewable)
- IAP: $1.99 CAD streak freeze (non-consumable)
- Free tier: 1 scan per week, basic rating only
- Pro tier: Unlimited scans, detailed analysis, streak freeze access

**Assumed (requires validation):**
- 10%+ of users will convert free → paid
- Loss aversion will drive streak freeze purchases
- $14.99 is acceptable price point (not validated)
- Weekly subscription churn will be manageable

**Deferred:**
- Pricing optimization (A/B testing post-MVP)
- Annual subscription option
- Additional IAP products
- Data licensing to enterprises

---

## 7. DATA INTENT & CONSTRAINTS

**Data collected:**
- Facial images (front + side) - stored locally only
- AI rating and analysis results - stored locally only
- Streak count and completion dates - stored locally
- Daily task completions - stored locally
- Subscription status - stored via RevenueCat
- Push notification token - stored via Firebase (optional)
- Anonymous analytics events - stored via Firebase (optional)

**Explicitly NOT collected:**
- Biometric templates (facial embeddings)
- Cloud-stored facial images
- Email addresses (unless subscribed, handled by RevenueCat)
- Phone numbers
- Location data
- Third-party ad tracking IDs

**Legal constraints acknowledged:**
- Quebec Law 25: Requires explicit consent, local-first storage, PIA for biometric data
- PIPEDA: Federal privacy requirements
- CASL: Opt-in required for marketing communications
- App Store: No dark patterns, clear pricing, medical disclaimer required

**Privacy architecture:**
- All facial processing on-device (Core ML / Vision framework)
- Images never leave device
- Camera permission with explicit privacy messaging
- Consent obtained before data collection

---

## 8. OPEN QUESTIONS / UNRESOLVED DECISIONS

**Must answer before/during MVP test:**

1. **Will users actually return daily for streaks?**
   - Competitors failed retention (<15% Day 7)
   - Hypothesis: Micro-tasks provide daily value; streaks create loss aversion
   - Will validate in 7-14 days

2. **Is $14.99/month acceptable?**
   - Based on competitor pricing, not user validation
   - May need price sensitivity testing

3. **Does the mocked AI rating provide sufficient value?**
   - Using Vision framework heuristics, not trained model
   - Rating is semi-randomized for "variable reward"
   - May not feel accurate to users

4. **Will streak freezes sell?**
   - Untested IAP concept
   - Depends on streak value perception

5. **Can we avoid App Store rejection?**
   - Body-image apps face scrutiny
   - Age rating: 17+ for body image content
   - No medical claims made

6. **Is the underlying market durable or trend-based?**
   - Business audit says: TREND (risky)
   - Revised strategy says: DURABLE MOVEMENT (like fitness)
   - Unresolved: Will validate through user behavior

---

## 9. CANONICAL PROJECT BRIEF (FOR AI BUILDERS)

```
PROJECT: Aesthetic Optimizer (iOS MVP)
TYPE: AI Facial Analysis App with Streak Retention
PLATFORM: iOS 15+, SwiftUI, Core Data (local storage)
TIMELINE: Test for 7-14 days, kill if metrics fail

CORE LOOP:
1. User takes selfie (front + side)
2. App analyzes on-device (<1 second, Vision framework)
3. Shows rating (1-10) + strengths (visible) + weaknesses (blurred for free users)
4. Free users: 1 scan/week, basic rating
5. Pro users ($14.99/mo): Unlimited scans, full analysis
6. Daily: User completes 3 micro-tasks (water, skincare, posture)
7. All 3 complete = streak maintained
8. Streak creates loss aversion → daily return
9. Streak freeze IAP ($1.99) protects against missed days

TECH STACK:
- SwiftUI for UI
- Core Data for local storage (never cloud)
- Vision framework for face detection (mocked AI rating)
- RevenueCat for subscriptions (simulated for testing)
- Local push notifications (no Firebase required for MVP)

KEY FILES:
- App/LooksmaxxingApp.swift: Entry point
- Views/: 6 screens (Onboarding, Home, Camera, Results, DailyRoutine, Paywall)
- ViewModels/: ScanViewModel, StreakViewModel, SubscriptionViewModel
- Services/: CoreDataManager, CoreMLService, NotificationService

SUCCESS METRICS (7-14 days):
- Day 7 retention >20% (kill if <10%)
- Conversion rate >10% (kill if <2%)
- Streak maintenance >30%
- Zero App Store rejections

KILL CRITERIA:
- Day 7 retention <10%
- Conversion rate <2%
- App Store rejection
- Legal warning

WHAT NOT TO BUILD:
- Social features
- Cloud sync
- Real ML model (use heuristics)
- Progress charts
- Email/SMS campaigns
- Advanced analytics

LEGAL REQUIREMENTS:
- Camera permission with privacy messaging
- No medical claims
- Local-only image storage
- Clear subscription terms
- Easy cancellation via App Store

BRAND POSITIONING:
- Use "Aesthetic Optimizer" (not "looksmaxxing")
- Position as self-improvement (not vanity)
- Distance from extreme content
- No body dysmorphia encouragement

THE MVP IS A TEST:
- If metrics pass: iterate and scale
- If metrics fail: kill immediately
- Do not add features hoping to fix retention
- Better to fail fast than waste months
```

---

## APPENDIX: CONFLICTING STATEMENTS RESOLVED

| Conflict | Resolution |
|----------|------------|
| "NOT MVP-READY" vs. MVP built | MVP was built to test hypothesis. Validation happens through metrics, not more research. |
| "Looksmaxxing" vs. "Aesthetic Optimizer" | Using "Aesthetic Optimizer" for App Store and mainstream positioning. |
| "TREND" vs. "DURABLE MOVEMENT" | Testing assumes durability. Kill metrics will reveal truth. |
| "DO NOT PROCEED" vs. "PROCEED WITH CHANGES" | Proceeding with changes: legal compliance, rebranding, retention focus. |
| "Validate before building" vs. "Build fast" | Fast MVP build for real-world validation. Research alone cannot validate. |
| Day 7 >25% vs. Day 7 >20% | Using >20% as target, <10% as kill signal (more conservative). |
| 34.7% conversion vs. 10% conversion | Using 10% as realistic target based on competitor analysis. |

---

## APPENDIX: WHAT WAS REMOVED AS REDUNDANT

- 47 duplicate behavioral psychology principles (already documented)
- 7 duplicate app mechanic analyses (Duolingo, Strava, etc.)
- Repeated legal compliance warnings (consolidated into section 7)
- Multiple versions of success metrics (normalized to section 2)
- Overlapping retention strategies (simplified to core loop)
- Speculative revenue projections ($18M-$100M) (removed as unvalidated)
- Exit strategy discussions (deferred, not MVP-relevant)

---

**Last Updated:** January 12, 2026  
**This document supersedes all prior specifications.**
