# Prompt: Generate "What to Add to My App" Document

**Context:** You are analyzing Quittr's 27-screen onboarding flow and comparing it to a looksmaxxing app's current implementation to identify high-impact additions.

**Current App Structure:**
- **ContentView.swift:** Main navigation controller (`hasCompletedOnboarding` flag)
- **OnboardingView.swift:** 2 screens (Welcome + Camera Permission) - NOT currently used in flow
- **OnboardingQuizView.swift:** 12-question quiz with progress bar, age verification (COPPA), uses `@AppStorage` for answers
- **AnalyzingView.swift:** Processing screen with animated steps, receives `OnboardingQuizData` object
- **ResultsTeaseView.swift:** Blurred results tease showing potential score and critical areas, transitions to paywall
- **PersonalizedPaywallView.swift:** Paywall with pricing options, personalized messaging, references `OnboardingQuizData`
- **OnboardingQuizData.swift:** ObservableObject model storing quiz answers with computed properties for personalization

**Current Flow:**
```
ContentView → OnboardingQuizView → AnalyzingView → ResultsTeaseView → PersonalizedPaywallView → (Subscribe) → DisclaimerView → HomeViewDark
```

**Quittr's Flow:** 27 screens including pre-quiz investment screens, symptoms selection, goals selection, signature commitment, plan preview card, and enhanced paywall.

**Key Technical Context:**
- App uses SwiftUI with `@AppStorage` for persistence
- Dark theme: `Color(hex: "0A0A0F")` background
- Quiz data stored in `OnboardingQuizData` ObservableObject (`LooksmaxxingApp/Models/OnboardingQuizData.swift`)
- Current quiz uses `TabView` with page dots for navigation
- Results tease calculates `potentialScore` and `criticalAreasCount` from quiz data
- Paywall references quiz answers for personalization
- Navigation: `ContentView` checks `hasCompletedOnboarding` flag to determine flow
- Current flow: `OnboardingQuizView` → `AnalyzingView` → `ResultsTeaseView` → `PersonalizedPaywallView`
- After subscription: Sets `hasCompletedOnboarding = true` → `DisclaimerView` → `HomeViewDark`

---

## Your Task

Generate a comprehensive document titled **"QUITTR_INSPIRED_ADDITIONS.md"** that provides:

### 1. Gap Analysis
Compare current app vs. Quittr's flow:
- **Current:** 2 screens → 12-question quiz → processing → results tease → paywall
- **Quittr:** 7-8 pre-quiz screens → 10-question quiz → processing → results → symptoms → goals → signature → plan card → paywall → free trial
- **Key Gaps:** Identify what's missing in each phase

### 2. Prioritized Feature Additions

For each addition, provide:

**A. Pre-Quiz Investment Screens (7-8 screens)**
- **Current Gap:** App jumps straight to quiz (ContentView directly shows OnboardingQuizView)
- **Quittr Has:** 7-8 welcome/problem-framing screens before quiz
- **Integration Point:** Insert between `ContentView` check and `OnboardingQuizView` initialization
- **What to Add:** Create `PreQuizOnboardingView.swift` with 6-7 specific screens adapted for looksmaxxing:
  - Screen 1: Authority/Science ("AI-powered facial analysis identifies 50+ aesthetic data points")
  - Screen 2: Social Proof ("Join 12,000+ users optimizing their facial aesthetics")
  - Screen 3: Hope/Transformation ("Your transformation journey starts here - From receded chin to defined jawline in 90 days")
  - Screen 4: Problem Identification ("Do you avoid photos because of your jawline?")
  - Screen 5: Problem Amplification ("70% of people have facial asymmetry - Most don't realize it until they see the data")
  - Screen 6: Scientific Explanation ("Facial structure responds to daily habits - Mewing, posture, and targeted exercises create lasting change")
  - Screen 7: Quiz Entry ("Welcome! Let's find out if you're maximizing your facial aesthetics potential")
- **Why It Works:** Passive investment (1-2 min reading) before commitment, builds authority, reduces skepticism
- **Expected Impact:** +15-20% quiz completion rate
- **Implementation Details:**
  - File: `LooksmaxxingApp/Views/PreQuizOnboardingView.swift`
  - Structure: `TabView` with `PageTabViewStyle` (horizontal paging)
  - Background: Same dark theme `Color(hex: "0A0A0F")` or gradient matching current app
  - Transitions: Horizontal slide (250ms, ease-in-out) between screens
  - Skip Button: Add to each screen (reduces friction, prevents abandonment)
  - Animation: Staggered text fade-in (500ms per element, ease-out-quad)
  - Navigation: On final screen, set flag or call completion handler to show `OnboardingQuizView`
- **Data Storage:** No data collection needed (passive investment phase)
- **Time Estimate:** 6-8 hours

**B. Symptoms Selection Screen**
- **Current Gap:** No symptom selection after results (ResultsTeaseView → directly to PersonalizedPaywallView)
- **Quittr Has:** Multi-select symptom checklist (Mental/Physical/Social categories)
- **Integration Point:** Insert between `ResultsTeaseView` and `PersonalizedPaywallView`
- **What to Add:** Create `SymptomsSelectionView.swift`
  - Categories adapted for looksmaxxing:
    - **Confidence/Behavioral:** "I avoid photos because of my jawline", "I feel self-conscious about my side profile", "I compare myself to others constantly", "I've tried multiple routines but gave up"
    - **Physical/Appearance:** "Receded chin or weak jawline", "Mouth breathing habits", "Poor posture awareness", "Uneven facial symmetry", "Skin texture issues"
    - **Functional:** "Difficulty breathing through nose", "Jaw tension or TMJ issues", "Sleep quality affected by breathing"
  - UI Pattern: 
    - Single-column scrollable list with category headers
    - Multi-select checkboxes (not radio buttons)
    - Category Headers: Uppercase, `#9CA3AF` (Muted Gray), 24px top-margin
    - Symptom Row: 56px height, 10px gutter, pill-shaped outline
    - Default: Circular outline (24px), 16px Medium white text, border `rgba(255, 255, 255, 0.2)`
    - Selected: Circle fills with `#E11D48` (Deep Red), white checkmark centered, scale animation (150ms, ease-out)
  - Sticky "Continue" CTA at bottom with gradient fade/blur
  - Minimum 1 selection required to continue
- **Why It Works:** Problem multiplication (selecting 5+ symptoms amplifies perceived severity), commitment escalation, identity fusion
- **Expected Impact:** +10-15% paywall conversion
- **Data Storage:** 
  - Add to `OnboardingQuizData.swift`: `@Published var selectedSymptoms: [String] = []`
  - Or use `@AppStorage("selectedSymptoms") private var selectedSymptoms: [String] = []`
  - Store as array of symptom IDs (e.g., ["avoid_photos", "mouth_breathing", "poor_posture"])
- **Placement:** Modify `ResultsTeaseView.swift` - instead of `showPaywall = true`, navigate to `SymptomsSelectionView`
- **Time Estimate:** 3-4 hours

**C. Goals Selection Screen (Separate from Q1)**
- **Current Gap:** Goal is captured in Q1 (`userGoal`), but no separate commitment screen
- **Quittr Has:** Dedicated goals selection screen after symptoms
- **Integration Point:** Insert after `SymptomsSelectionView`, before signature
- **What to Add:** Create `GoalsSelectionView.swift`
  - Goal Options (6-8): 
    1. "🔥 Sharper, more defined jawline"
    2. "✨ Better skin texture and glow"
    3. "⚖️ Improved facial symmetry"
    4. "💪 Increased confidence in photos"
    5. "👃 Fix mouth breathing habits"
    6. "🧍 Better posture and presence"
    7. "💎 Overall aesthetic transformation"
    8. "🎯 Specific feature improvement" (if they selected one in Q1)
  - UI Pattern: 
    - Single-column vertical list, 64px row height, 12px gutter
    - Background: `rgba(255, 255, 255, 0.05)`, Border: `1px solid rgba(255, 255, 255, 0.15)`
    - Border Radius: 50px (Full Capsule)
    - Iconography: Glossy 3D-effect emojis/glyphs, high-contrast saturated colors
    - Multi-select (allow 1-3 selections)
    - Selected cards: Right-hand circle fills with category color, white checkmark, border opacity → 0.8, glow effect
    - Haptic: Selection pulse (Impact Light) on tap
    - Staggered Entrance: `FadeInUp.delay(index * 100).duration(500)` (React Native) or equivalent SwiftUI animation
  - Instruction: "Select 1-3 goals that matter most"
  - Sticky footer button (disabled until at least 1 goal selected)
- **Why It Works:** Future-state commitment, aspiration building, identity shift from "problem" to "achiever"
- **Expected Impact:** +5-10% paywall conversion
- **Data Storage:**
  - Add to `OnboardingQuizData.swift`: `@Published var selectedGoals: [String] = []`
  - Store as array of goal IDs (e.g., ["sharper_jawline", "better_skin", "increased_confidence"])
  - These will be used in paywall for Benefit Badges
- **Placement:** After `SymptomsSelectionView`, before signature
- **Time Estimate:** 2-3 hours

**D. Commitment Signature Screen**
- **Current Gap:** No signature commitment before paywall
- **Quittr Has:** Physical signature canvas before paywall
- **Integration Point:** Insert after `GoalsSelectionView`, immediately before `PersonalizedPaywallView`
- **What to Add:** Create `CommitmentSignatureView.swift`
  - Canvas drawing area:
    - Use SwiftUI `Canvas` API or PencilKit framework
    - Large centered rectangle, 16:9 aspect ratio
    - Background: Solid White `#FFFFFF` (contrasts with dark theme)
    - Corner Radius: 12px
    - Border: None (shadow-based elevation only)
    - "Ink" Physics: Vector Path (SVG-based), solid black `#000000`, 4px fixed width
    - Smoothing: High (Quadratic Bezier curve smoothing)
  - Instruction & Header:
    - Header: "Sign your commitment" (26px Bold, White)
    - Subtitle: "Finally, promise yourself that you will commit to your transformation plan"
    - Prompt: "Draw on the open space above" (14px Muted Gray `#9CA3AF`, centered below canvas)
    - **NOT:** "Legally binding" or "Contract" (avoid legal misrepresentation)
  - Control Elements:
    - "Clear" Button: Text-only, 12px below bottom-left corner of canvas, white text 14px medium
    - "Continue" button (disabled until signature drawn)
  - Validation & Logic:
    - Stroke Detection: Minimum path length 50 units (approx. one small curve)
    - Haptic: Continuous light haptic during draw (mimics pen on paper)
    - Auto-advance: On valid stroke (finger lifted after minimum requirement), 500ms delay then transition
    - Exit Animation: 300ms fade-out to paywall
  - Data Storage:
    - Add to `OnboardingQuizData.swift`: `@Published var commitmentSignature: Data?` (UIImage as Data)
    - Or use `@AppStorage("commitmentSignature") private var signatureData: Data?`
    - Store as PNG/JPEG data
- **Why It Works:** Highest form of commitment, strategic friction (drawing > tapping), identity fusion, cognitive dissonance
- **Expected Impact:** +15-20% paywall conversion
- **Placement:** After `GoalsSelectionView`, immediately before paywall
- **Time Estimate:** 4-5 hours
- **Dependencies:** SwiftUI Canvas or PencilKit framework

**E. Enhanced Labor Illusion**
- **Current Gap:** `AnalyzingView` has step-by-step progress but no rotating text labels
- **Quittr Has:** Status text cycles every 800ms ("Analyzing patterns...", "Processing data...")
- **Integration Point:** Modify existing `AnalyzingView.swift`
- **What to Add:**
  - Rotating text labels above/below progress steps
  - Cycle through 4 labels every 800ms:
    1. "Analyzing facial architecture..."
    2. "Comparing to 50,000+ data points..."
    3. "Synthesizing your transformation plan..."
    4. "Calculating potential improvements..."
  - Implementation:
    - Add `@State private var currentLabelIndex = 0`
    - Use `Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true)` to cycle labels
    - Text fade + slide animation (500ms) when label changes
    - Light haptic feedback on each label change (optional, V2)
  - Typography: 16px Regular, White `#FFFFFF`, centered
  - Animation: Fade out old label, fade in new label with slight Y-offset (+5px to 0)
- **Why It Works:** Labor illusion increases perceived value, anticipation builds investment, technical language suggests scientific rigor
- **Expected Impact:** +5% perceived value, +3-5% paywall conversion
- **Implementation:** Modify existing `AnalyzingView.swift` (add label cycling logic)
- **Time Estimate:** 1-2 hours

**F. Social Comparison Bar Chart**
- **Current Gap:** `ResultsTeaseView` shows potential score (e.g., 8.5/10) but no comparison to average
- **Quittr Has:** "52% vs 13% average" bar chart (staggered animation)
- **Integration Point:** Enhance existing `ResultsTeaseView.swift` - add chart above or below `potentialScoreCard`
- **What to Add:**
  - Chart Type: Comparative Vertical Bar Chart
  - Two vertical bars: "Your Potential" vs "Average User"
  - Bar Specifications:
    - Width: ~80px each
    - Corner Radius: 10px (top only)
    - Spacing: 40px gutter between bars
    - Your bar: `#00D4FF` (Cyan) or `#10B981` (Green) - animate from 0 to 82% over 1.5s with `ease-out-back`
    - Average bar: `#6B7280` (Muted Gray) - static at 65% (no animation)
    - Pulse animation on user bar for 2 seconds after reveal
  - Typography:
    - Percentages: 32px Bold, White `#FFFFFF`, centered above bar
    - Sub-labels: 14px Medium, Muted White `#D1D5DB` ("Your Potential", "Average User")
    - Gap Callout: "You're 24% above average potential" (fade in after bars complete)
  - Label & Disclaimer:
    - Header: "Indicative Assessment" (not "Medical Diagnosis")
    - Disclaimer: "Based on general population data" (small text below chart)
  - Animation Sequence:
    1. Average bar: Static (no animation, appears immediately)
    2. 200ms delay
    3. User bar: Grow from 0 to 82% over 1500ms with `ease-out-back`
    4. Pulse animation on user bar (scale 1.0 to 1.05, 2 seconds)
    5. Gap text fades in after bars complete
- **Why It Works:** Social comparison creates positive urgency (above average vs. Quittr's below average), visual impact more compelling than text-only
- **Expected Impact:** +10-15% paywall conversion
- **Implementation:** Enhance `ResultsTeaseView.swift` - add chart component
- **Time Estimate:** 3-4 hours
- **MVP:** Fixed numbers (82% vs 65%) with "Indicative Assessment" label and disclaimer
- **V2:** Replace with real user average once you have 1000+ scores (calculate from `OnboardingQuizData.potentialScore` across all users)

**G. Plan Preview Card (Virtual ID Card)**
- **Current Gap:** No ownership phase before paywall
- **Quittr Has:** Virtual ID card showing "Active Streak: 0 days", "Free since: [Date]"
- **Integration Point:** Insert after `CommitmentSignatureView`, before `PersonalizedPaywallView`
- **What to Add:** Create `PlanPreviewCardView.swift`
  - Card Design:
    - Premium Virtual ID Pass (1.586:1 aspect ratio, Standard ID-1 format)
    - Dimensions: 340x210px (or responsive to screen width)
    - Background: Animated Mesh Gradient
      - Colors: Crimson `#F43F5E`, Deep Orange `#FB923C`, Indigo `#4F46E5`
      - Overlay: 5% opacity noise/grain texture (optional)
    - Border Radius: 24px
    - Shadow: `0px 20px 50px rgba(0,0,0,0.4)` (multi-layered, deep shadow)
    - Gloss Effect: Diagonal linear-gradient light sweep (white 20% opacity) that translates every 2.5s
  - Layout & Typography:
    - Top-Left: App Brand Mark (circular logo with white border)
    - Top-Right: Profile/Account Icon (person silhouette in rounded box)
    - Primary Metric: "Active Streak: 0 days"
      - Label: Small uppercase, muted white `rgba(255,255,255,0.7)`, 12px
      - Value: Large Bold, high-contrast White, 28px
    - Personal Data Row:
      - Field 1 (Name): From User Profile Input or quiz (if captured)
      - Field 2 (Free since): Dynamic date (MM/DD format, e.g., "01/14") - use `Date().formatted(.dateTime.month().day())`
  - Animation:
    - Entrance: SlideUp + Spring damping
      - Behavior: Slide from bottom with overshoot bounce
      - Damping: 0.7, Stiffness: 120
      - Duration: 600ms
    - Presence (Idle):
      - Glint: Shimmering light effect passes over card every 2.5 seconds
      - Floating: Slow Y-axis oscillation (±5px over 4000ms)
    - Exit: 2200ms pause, then text changes + vertical scroll to Personalized Plan
- **Why It Works:** IKEA Effect (user feels they "created" this), Endowment Effect (ownership before purchase), makes paywall feel like logical next step
- **Expected Impact:** +10-15% paywall conversion
- **Data Requirements:**
  - User name (from profile or quiz)
  - Current date (for "Free since")
  - Streak: Always starts at 0 days (initiates streak psychology immediately)
- **Placement:** After signature, before paywall
- **Time Estimate:** 4-5 hours

**H. Enhanced Paywall Features**
- **Current Gap:** Paywall has pricing and personalized messaging but missing Quittr's high-conversion elements
- **Quittr Has:** Quit Date Banner, Benefit Badges, "$0.00" messaging, device mockup, privacy sub-label
- **Integration Point:** Enhance existing `PersonalizedPaywallView.swift`
- **What to Add:**
  - **Transformation Date Banner (CRITICAL):**
    - Copy: "You will maximize your aesthetics by: [Date]"
    - Date Logic: **Client-side calculation** (Today + 60 days), format "MMM d, yyyy" (e.g., "Mar 14, 2026")
    - Styling: Solid White capsule `#FFFFFF`, Bold Sans-serif, Deep Navy text `#081630`, 20px
    - Visual Weight: Highest on page (concrete "End Date")
    - Placement: Below personalized headline, above pricing section
  - **Benefit Badges:**
    - Display goals from Goals Selection screen (`selectedGoals` array)
    - Architecture: Flex-wrap tag cloud of rounded pills
    - Styling: Background Muted Navy `rgba(8, 22, 48, 0.8)`, thin colored border matching goal category
    - Icons: Miniature versions of high-res icons from Goal Selection
    - Category Colors: Energy `#F59E0B`, Confidence `#3B82F6`, Relationships `#F43F5E`, Focus `#8B5CF6`, Self-Control `#10B981`
  - **Free Trial Messaging:**
    - Headline: "Try For $0.00"
    - Typography: "Try For" - 18px Extra-Bold, "$0.00" - 22px Black (900 weight)
    - **CRITICAL:** "$0.00" must be larger than "Try For" (visual anchor on "Free")
    - Subtext: "Start your 7-day free trial. Cancel anytime."
  - **Safety Signal:**
    - Element: Large Green Checkmark `#10B981` + "No Payment Due Now" text
    - Placement: Directly above CTA button
    - Agreement Logic: Pre-checked or static "Verified" symbol (not interactive checkbox)
  - **Device Mockup:**
    - High-fidelity iPhone preview (~65% of screen height)
    - Internal UI Preview: Post-Onboarding Dashboard
    - Focal Points: Streak counter, scan interface, results screen, daily routine
    - Purpose: Shows actual product (not marketing mockup), reduces pre-purchase anxiety
  - **Privacy Sub-label (CRITICAL - DO NOT OMIT):**
    - Text: "Purchase appears Discretely"
    - Placement: Immediately below CTA button in Muted Gray `#9CA3AF`
    - Purpose: Critical "Safety Signal" for shame-based friction
- **Why It Works:** Endowment Effect (Custom Plan framing), Zero-Price Effect ($0.00 removes friction), Safety Signals (privacy, no payment now)
- **Expected Impact:** +20-30% paywall conversion
- **Implementation:** Enhance `PersonalizedPaywallView.swift` - add components above existing pricing section
- **Data Requirements:**
  - `selectedGoals` array (from Goals Selection screen)
  - User name (for personalization)
  - Date calculation (client-side: Today + 60 days)
- **Time Estimate:** 6-8 hours

### 3. Implementation Roadmap

**Week 1: MVP Features (Must-Have)**
1. Pre-Quiz Investment Screens (4-5 screens minimum) - 6-8 hours
2. Symptoms Selection Screen - 3-4 hours
3. Goals Selection Screen - 2-3 hours
4. Commitment Signature Screen - 4-5 hours
5. Enhanced Labor Illusion - 1-2 hours
**Total: 16-22 hours**

**Week 2: High-Leverage Additions**
6. Social Comparison Bar Chart - 3-4 hours
7. Plan Preview Card - 4-5 hours
8. Enhanced Paywall Features - 6-8 hours
**Total: 13-17 hours**

**Post-MVP: Nice-to-Have**
- Problem-Agitation Carousel (can use static slides)
- Feature Value Propositions (can combine with testimonials)
- Recovery Timeline Graph (can use simpler chart)
- Social Proof Grid (can use simpler list)

### 4. Expected Metrics Impact

**Activation (Quiz Completion):**
- Current: ~60-70% (estimated)
- Expected: +15-20% (from pre-quiz investment screens)
- Mechanism: Passive investment before quiz = higher completion

**Paywall Conversion:**
- Current: ~20-30% (estimated)
- Expected: +30-50% (from commitment escalation: symptoms + goals + signature + plan card)
- Mechanism: Multi-stage investment before paywall = higher conversion

**Early Retention (Day 7):**
- Current: ~40-50% (estimated)
- Expected: +10-15% (from identity fusion: "I signed, I selected, I committed")
- Mechanism: Higher commitment = higher retention

### 5. Risk Mitigation

- **Too Many Screens:** Start with 4-5 pre-quiz screens, A/B test optimal count
- **Fixed Comparison Numbers:** Clearly label as "Indicative Assessment," add disclaimer
- **Signature Misrepresentation:** Frame as "personal commitment tool," not "legal agreement"
- **Over-Promising Results:** Use "potential improvements" language, realistic timeframes

### 6. Adaptation Notes

**Niche Differences (Looksmaxxing vs. Addiction Recovery):**
- **Positive Framing:** Use "optimization potential" vs. "problem" (Quittr uses negative framing)
- **Social Comparison:** Show "above average" (82% vs 65%) vs. Quittr's "below average" (52% vs 13%)
- **Goal Language:** "Transformation" vs. "Recovery"
- **Privacy Sub-label:** "Purchase appears Discretely" (addresses shame-based friction in both niches)

**What NOT to Copy:**
- Medical/clinical language without validation
- Fabricated "average" scores without disclaimer
- False testimonials or media endorsements
- Negative shame-based framing (use positive aspiration instead)

---

## Output Format

Create a comprehensive markdown document titled **"QUITTR_INSPIRED_ADDITIONS.md"** with the following structure:

### 1. Executive Summary (1-2 paragraphs)
- Current state: 2 screens → 12-question quiz → processing → results → paywall
- Quittr's advantage: 27-screen flow with pre-quiz investment, multi-stage commitment, ownership phase
- Key opportunity: Add 8 high-impact features to match/exceed Quittr's conversion
- Expected lift: +30-50% paywall conversion, +15-20% quiz completion, +10-15% retention

### 2. Gap Analysis Table
Compare current app vs. Quittr vs. What to Add:

| Phase | Current App | Quittr Has | What to Add | Impact |
|-------|-------------|------------|-------------|--------|
| Pre-Quiz | 2 screens (Welcome + Camera) | 7-8 investment screens | PreQuizOnboardingView (6-7 screens) | +15-20% completion |
| Quiz | 12 questions | 10 questions | Keep current (already good) | - |
| Post-Quiz | Processing → Results → Paywall | Processing → Results → Symptoms → Goals → Signature → Plan Card → Paywall | 4 new screens | +30-50% conversion |
| Paywall | Basic pricing + personalization | Date banner + badges + $0.00 + mockup | Enhanced features | +20-30% conversion |

### 3. Detailed Feature Specifications

For each addition (A-H), provide:

**Structure for Each Feature:**
- **Feature Name & Purpose** (1 sentence)
- **Current Gap** (what's missing)
- **Quittr's Implementation** (what they do)
- **What to Add** (detailed specification):
  - File name and location
  - UI/UX architecture (layout, components, styling)
  - Animation specifications (timing, easing, triggers)
  - Interaction patterns (gestures, feedback, validation)
  - Data model integration (what to add to `OnboardingQuizData.swift`)
  - Integration point (where in flow, what to modify)
- **Code Snippets** (SwiftUI examples for key components)
- **Why It Works** (psychological principles)
- **Expected Impact** (quantified metrics)
- **Implementation Details:**
  - Time estimate
  - Dependencies
  - Complexity (Low/Medium/High)
  - Testing checklist
- **Placement in Flow** (exact sequence)
- **Data Storage** (what to persist, where)

### 4. Implementation Roadmap

**Week 1: MVP Features (Must-Have)**
- Detailed breakdown with file names, integration points, dependencies
- Estimated hours per feature
- Order of implementation (dependencies considered)
- Testing requirements

**Week 2: High-Leverage Additions**
- Same level of detail as Week 1
- Integration with Week 1 features

**Post-MVP: Nice-to-Have**
- Deferred features with rationale
- Future enhancement opportunities

### 5. Expected Metrics Impact

**Before/After Comparison:**
- Activation (Quiz Completion): Current % → Expected %
- Paywall Conversion: Current % → Expected %
- Early Retention (Day 7): Current % → Expected %
- Total Expected Lift: Combined impact

**Key Drivers:**
- List top 3-5 psychological mechanisms driving the lift
- Attribution per feature (which feature contributes what %)

### 6. Risk Mitigation Strategies

For each risk:
- Risk description
- Mitigation strategy
- Monitoring approach
- Fallback plan

### 7. Adaptation Guidelines

**Looksmaxxing-Specific Considerations:**
- Positive framing vs. negative (Quittr uses shame, we use aspiration)
- Social comparison direction (above average vs. below average)
- Language adaptations (transformation vs. recovery)
- Niche-specific friction points (privacy, shame, social stigma)

**What NOT to Copy:**
- List with rationale
- Safe alternatives

### 8. Code Integration Guide

**File Modifications Required:**
- List all files that need changes
- Specific modifications per file
- New files to create
- Data model updates (`OnboardingQuizData.swift`)

**Flow Integration:**
- Current flow diagram
- New flow diagram
- Navigation changes
- State management updates

### 9. Testing Checklist

**Functional Testing:**
- Screen-by-screen validation (all 8 new features)
- Data persistence verification (`@AppStorage` and `OnboardingQuizData` updates)
- Animation performance (60fps, no jank)
- Edge cases (empty selections, invalid signatures, network failures)
- Navigation flow (all transitions work correctly)
- State management (data flows correctly between screens)

**Conversion Testing:**
- A/B test recommendations:
  - Pre-quiz screens: 4 vs. 7 vs. 10 screens
  - Signature: Required vs. Optional
  - Comparison chart: Fixed vs. Real data
  - Date range: 30 vs. 60 vs. 90 days
- Metrics to track:
  - Drop-off rate at each new screen
  - Paywall conversion rate (before/after)
  - Quiz completion rate (before/after)
  - Early retention (Day 7, Day 14)
  - Time to conversion (how long in onboarding)
- Success criteria:
  - Paywall conversion: +30% minimum
  - Quiz completion: +15% minimum
  - Retention: +10% minimum

### 10. Psychological Principles Reference

For each feature, explain the underlying psychology:
- **Pre-Quiz Screens:** Passive Investment, Authority Building, Problem Awareness
- **Symptoms Selection:** Problem Multiplication, Commitment Escalation, Identity Fusion
- **Goals Selection:** Future-State Commitment, Aspiration Building, Identity Shift
- **Signature:** Consistency Principle, Strategic Friction, Cognitive Dissonance
- **Plan Preview Card:** IKEA Effect, Endowment Effect, Ownership Psychology
- **Enhanced Paywall:** Zero-Price Effect, Safety Signals, Loss Aversion Removal
- **Social Comparison:** Social Proof (positive), Urgency Creation, Anchoring Bias

### 11. Data Model Updates

**Required Changes to `OnboardingQuizData.swift`:**
- Add `@Published var selectedSymptoms: [String] = []`
- Add `@Published var selectedGoals: [String] = []`
- Add `@Published var commitmentSignature: Data?`
- Add computed properties for paywall personalization:
  - `var transformationDate: Date` (Today + 60 days)
  - `var goalBadges: [GoalBadge]` (from selectedGoals)
  - `var hasSignedCommitment: Bool` (signature != nil)

**UserDefaults Keys to Add:**
- `selectedSymptoms` (array of strings)
- `selectedGoals` (array of strings)
- `commitmentSignature` (Data)
- `planPreviewShown` (Bool - track if user saw the card)

### 12. Color Palette Reference

**Current App Colors:**
- Background: `#0A0A0F` (Dark)
- Primary Accent: `#00D4FF` (Cyan)
- Success: `#10B981` (Green)
- Muted: `#6B7280` (Gray)
- Text: `#FFFFFF` (White)

**New Colors Needed (from Quittr spec):**
- Deep Navy: `#081630`
- Deep Teal: `#125E75`
- Vivid Crimson: `#F13644` (for comparison chart)
- Bright Teal: `#2DD4BF` (for comparison chart)
- Deep Red: `#E11D48` (for symptom selection)
- Gold: `#FFD700` / `#FACC15` (for ratings/stars)

**Category Colors (Goal Badges):**
- Energy/Motivation: `#F59E0B` (Orange)
- Confidence: `#3B82F6` (Blue)
- Relationships: `#F43F5E` (Red)
- Focus: `#8B5CF6` (Purple)
- Self-Control: `#10B981` (Green)

### 13. File Structure & Organization

**New Files to Create:**
1. `LooksmaxxingApp/Views/PreQuizOnboardingView.swift` - 6-7 pre-quiz investment screens
2. `LooksmaxxingApp/Views/SymptomsSelectionView.swift` - Multi-select symptom checklist
3. `LooksmaxxingApp/Views/GoalsSelectionView.swift` - Goals selection (separate from Q1)
4. `LooksmaxxingApp/Views/CommitmentSignatureView.swift` - Signature canvas
5. `LooksmaxxingApp/Views/PlanPreviewCardView.swift` - Virtual ID card

**Files to Modify:**
1. `LooksmaxxingApp/Models/OnboardingQuizData.swift` - Add new data fields
2. `LooksmaxxingApp/Views/AnalyzingView.swift` - Add rotating text labels
3. `LooksmaxxingApp/Views/ResultsTeaseView.swift` - Add comparison bar chart
4. `LooksmaxxingApp/Views/PersonalizedPaywallView.swift` - Add date banner, badges, $0.00 messaging
5. `LooksmaxxingApp/Views/ResultsTeaseView.swift` - Update navigation (add SymptomsSelectionView)
6. `LooksmaxxingApp/App/ContentView.swift` - Potentially add PreQuizOnboardingView check

**Data Model Integration:**
- All new data should integrate with existing `OnboardingQuizData` pattern
- Use `@Published` for ObservableObject properties
- Use `@AppStorage` for simple persistence (if not using ObservableObject)
- Ensure data flows correctly to paywall for personalization

**Navigation Flow Updates:**
- Current: `OnboardingQuizView` → `AnalyzingView` → `ResultsTeaseView` → `PersonalizedPaywallView`
- New: `PreQuizOnboardingView` → `OnboardingQuizView` → `AnalyzingView` → `ResultsTeaseView` → `SymptomsSelectionView` → `GoalsSelectionView` → `CommitmentSignatureView` → `PlanPreviewCardView` → `PersonalizedPaywallView`

---

## Final Instructions

**Output Quality Standards:**
- Every feature specification must include actual SwiftUI code snippets (not pseudocode)
- All color codes must be exact hex values
- All animation timings must be specified (duration, easing, delay)
- All file paths must be exact (relative to workspace root)
- All integration points must reference actual existing code
- All data model changes must show exact property declarations

**Completeness Check:**
- [ ] All 8 features (A-H) have complete specifications
- [ ] Code snippets are production-ready (not placeholders)
- [ ] Integration points are clearly identified
- [ ] Data model updates are specified
- [ ] Animation specs are complete
- [ ] Time estimates are realistic
- [ ] Expected impact is quantified
- [ ] Risk mitigation is addressed
- [ ] Testing checklist is comprehensive

**Ready to Execute:** This prompt is now comprehensive enough to generate a complete, actionable implementation guide.

---

**Tone:** Actionable, technical, prioritized. Every feature should have:
- Exact screen placement and file paths
- Complete UI/UX specifications with hex codes
- SwiftUI code snippets (not just descriptions)
- Data storage requirements (exact `@AppStorage` or `@Published` syntax)
- Animation timing and easing functions
- Integration points (which existing files to modify)
- Time estimates with rationale
- Expected impact metrics (quantified)
- Implementation complexity rating
- Dependencies and prerequisites

**Code Examples:** Include actual SwiftUI code snippets for:
- Component structures
- Animation logic
- State management
- Data binding
- Navigation transitions

**Priority:** Focus on MVP features first (Week 1) - these provide 80% of conversion lift with 20% of effort. Each feature should be independently implementable and testable.
