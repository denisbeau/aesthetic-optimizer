# Onboarding Specification: Psychological Priming Flow

**Status:** ✅ IMPLEMENTED  
**Files:** OnboardingQuizView.swift, AnalyzingView.swift, ResultsTeaseView.swift, PersonalizedPaywallView.swift

---

## 1. PURPOSE

Transform 2-screen "Welcome" flow into 15-18 screen "Clinical Assessment" flow.

**Expected Impact:**
- 30-50% conversion lift
- 10-20% drop-off during questions (acceptable)
- Users who finish are 5x more likely to pay

**Psychology:** By paywall, user has invested 3 minutes. If they leave, that effort is "wasted."

---

## 2. THE 12-QUESTION SEQUENCE

| # | Question | Options | Psychology | Priming |
|---|----------|---------|------------|---------|
| 1 | What is your primary aesthetic goal? | Sharper jawline / Better skin / Better symmetry / Overall glow-up | Commitment/Consistency | Sets "North Star" |
| 2 | How old are you? | 12-16 / 16-18 / 18-25 / 25+ | Personalization | Implies AI adjusts for age |
| 3 | How often do you feel confident in photos? | Always / Sometimes / Rarely / I avoid photos | Problem Amplification | Reminds of pain |
| 4 | Which of these do you struggle with? | Mouth breathing / Poor posture / Uneven skin / Receded chin | Specific Identification | Validates app understands terms |
| 5 | Do you currently follow a grooming routine? | None / Basic / Intermediate / Advanced | Gap Analysis | App is "missing piece" |
| 6 | How many hours of sleep do you average? | Less than 6 / 6-7 hours / 8+ hours | Variables of Success | Feels "scientific" |
| 7 | Are you willing to commit 10 mins/day? | Yes, I'm ready / Maybe / Not sure yet | Micro-Commitment | Agreement before price |
| 8 | How soon do you want visible results? | 2 weeks (Intense) / 1 month / 3 months | Urgency | Subscription = "fast track" |
| 9 | What has stopped you from improving before? | Lack of knowledge / Consistency / No clear plan / Just starting | Objection Pre-emption | App solves these |
| 10 | Do you breathe through your mouth or nose? | Nose / Mouth / Unsure | Authority (Mewing) | Targets core demographic |
| 11 | How dedicated are you to your glow-up? | 10 - All in / 8-9 / 6-7 / 5 or below | Self-Labeling | High scores = higher payment intent |
| 12 | Ready to analyze your facial structure? | [Start AI Analysis] | Momentum | Transitions to action |

---

## 3. FLOW STRUCTURE

```
[Questions 1-11] → [Question 12: Start] → [Analyzing Screen] → [Results Tease] → [Paywall]
```

### Screen Count: 15-18 total
1. Questions (11 screens, auto-advance)
2. "Start Analysis" action screen (1)
3. "Analyzing" loading animation (1)
4. "Results Ready" tease (1)
5. Personalized paywall (1)

---

## 4. THE "ANALYZING" SCREEN

**Duration:** ~10 seconds (fake processing)

**Animation:** Progress bars filling, checkmarks appearing

**Copy:**
```
Headline: Analyzing your facial architecture...

Steps (appear sequentially):
✓ Scanning mandible structure...
✓ Assessing orbital symmetry...
✓ Evaluating skin texture...
⟳ Comparing to 50,000+ data points...
⟳ Building your personalized plan...
```

**Purpose:** Creates perceived value. User sees "work" being done.

---

## 5. THE "RESULTS TEASE" SCREEN

**What to show:**
- "Your Aesthetic Profile is Ready" ✓
- Potential Score: 8.5/10 (personalized)
- "3 Critical Areas Identified"
- ONE area visible, TWO blurred/locked
- Lock icons indicating premium content

**What NOT to show:**
- Full results (they'd have no reason to pay)
- Actual numerical breakdown
- Specific recommendations

**Copy:**
```
Headline: Your Profile is Ready

Body: We've identified 2 high-impact areas where you can see 
visible changes in 30 days. Based on your mouth-breathing status 
and jawline goals, we've built your custom routine.

Button: [View My 30-Day Transformation Plan]
```

---

## 6. THE PAYWALL

**Headline (personalized):**
```
"From 6.5 to 8.5: Get Your Step-by-Step Roadmap"
```

**Sub-headline:**
```
Join 12,000+ men using Aesthetic Optimizer to fix their 
facial symmetry and sharpen their features.
```

**Personalization:**
- Reference their primary goal ("sharper jawline")
- Reference their timeframe ("your 1 month plan")
- Show transformation visual (6.5 → 8.5)

**Pricing Options:**
- Monthly: $14.99/month (BEST VALUE badge)
- Yearly: $99.99/year (Save 44%)
- Weekly: $4.99/week

**Features List:**
- Unlimited AI facial scans
- Full analysis with all metrics
- Personalized [timeframe] plan
- Daily exercises for [goal]
- Progress tracking & streaks
- Streak freeze protection

---

## 7. UI SPECIFICATIONS

### Theme
- Background: #0A0A0F (near-black)
- Accent: #00D4FF (neon blue)
- Success: #10B981 (green)
- Warning: #EF4444 (red)
- Text: #FFFFFF (white), #6B7280 (gray)

### Typography
- Headlines: SF Pro Bold
- Body: SF Pro Regular
- Numbers: SF Pro Rounded Bold

### Animations
- Progress bar: Smooth gradient fill
- Checkmarks: Appear with scale animation
- Cards: Slide in from bottom
- Buttons: Glow shadow on accent color

---

## 8. IMPLEMENTATION STATUS

| Component | File | Status |
|-----------|------|--------|
| Quiz Questions | OnboardingQuizView.swift | ✅ Built |
| Quiz Data Model | OnboardingQuizData (in same file) | ✅ Built |
| Analyzing Animation | AnalyzingView.swift | ✅ Built |
| Results Tease | ResultsTeaseView.swift | ✅ Built |
| Personalized Paywall | PersonalizedPaywallView.swift | ✅ Built |
| Color Extension | Color(hex:) in OnboardingQuizView | ✅ Built |

---

## 9. TESTING CHECKLIST

- [ ] All 12 questions display correctly
- [ ] Progress bar advances per question
- [ ] Auto-advance on selection works
- [ ] Analyzing animation runs ~10 seconds
- [ ] Results tease shows personalized score
- [ ] Locked items show blur effect
- [ ] Paywall references user's goal
- [ ] Paywall references user's timeframe
- [ ] Purchase flow completes
