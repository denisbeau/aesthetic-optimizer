# Gemini Deep Research Prompt: Advanced Retention Tactics (Gap-Focused)

**Framework:** KERNEL (Keep it simple, Easy to verify, Reproducible, Narrow scope, Explicit constraints, Logical structure)

**CRITICAL:** This prompt focuses ONLY on content gaps. DO NOT research topics already covered in existing project files.

---

## CONTEXT (Input)

**App Description:**
- AI-driven looksmaxxing mobile app (iOS-first, native Swift)
- Core ML on-device facial analysis (<1 second processing)
- Current features: AI facial rating, daily roadmap, streak counter, subscription system
- Current monetization: Subscriptions ($14.99/month CAD), IAPs, rewarded ads
- Target ARPU: $15-25/month
- Legal compliance: PIPEDA, Quebec Law 25, Competition Act (Canada)

**Current Retention Problem:**
- Users treat app as "one-off diagnostic" (pay once, get rating, never return)
- 52% revenue decline (Umax case study) = retention failure
- Day 7 retention: <15% (target: >25%)
- Day 30 retention: <10% (target: >15%)
- DAU/MAU: <15% (target: >20%)

**What's Already Covered (DO NOT RESEARCH):**
- ✅ Behavioral Psychology (Variable Ratio, Zeigarnik, Loss Aversion, Social Validation, Endowment, Flow State, Commitment Bias, Identity Habits, Reciprocity, Progress Visualization) - Already in `research-addictive-features.md`
- ✅ Product Mechanics from Apps (Duolingo, Strava, Headspace, Calm, Noom, Habitica, MyFitnessPal) - Already documented
- ✅ Core Implementation (Core ML, iOS, Firebase, RevenueCat, streaks, daily quests, progress sliders) - Already in `implementation-roadmap.md`
- ✅ Basic Retention Features (onboarding, daily hooks, progress visualization, social features, personalization) - Already covered
- ✅ Push Notifications (timing, frequency, content) - Already in `research-addictive-features.md`

**What's Missing (FOCUS HERE):**
- ❌ Email/SMS Win-Back Campaigns (not covered in detail)
- ❌ Churn Prediction Signals (early warning system)
- ❌ Specific Retention Metrics & Benchmarks (actionable targets)
- ❌ Retention Economics (LTV impact calculations, ROI)
- ❌ Detailed Habit Stacking Implementation (mentioned but not detailed)
- ❌ Detailed Micro-commitments Strategy (mentioned but not detailed)

---

## TASK (Function)

**Single Goal:** Research ONLY the 6 missing retention topics listed above. Provide actionable, science-backed strategies with specific metrics and implementation details.

**Research Focus (ONLY These Topics):**

1. **Email/SMS Win-Back Campaigns:**
   - Specific email templates for re-engagement (Day 3, Day 7, Day 14 inactive)
   - SMS campaign strategies (timing, frequency, content)
   - Win-back offer strategies (discounts, free trials, exclusive content)
   - A/B testing frameworks for win-back campaigns
   - Industry benchmarks (open rates, click rates, conversion rates)
   - Legal compliance (CASL for Canada, opt-in requirements)

2. **Churn Prediction Signals:**
   - Early warning indicators (behavioral patterns before churn)
   - Predictive models (what signals predict churn within 7 days?)
   - Intervention strategies (what to do when churn signal detected)
   - Timing of interventions (when to intervene for maximum effect)
   - Success rates of interventions (what works, what doesn't)
   - Technical implementation (how to track and detect signals)

3. **Specific Retention Metrics & Benchmarks:**
   - Industry benchmarks for Day 7, Day 30, Day 90 retention (by app category)
   - Target metrics for looksmaxxing/wellness apps (specific numbers)
   - DAU/MAU benchmarks (what's good, what's excellent)
   - Session frequency targets (how often should users return?)
   - Churn rate benchmarks (what's acceptable, what's problematic)
   - How to measure retention (analytics tools, tracking methods)

4. **Retention Economics:**
   - LTV impact of retention improvements (if Day 7 retention improves by 10%, how much does LTV increase?)
   - ROI calculations for retention features (development cost vs. revenue impact)
   - Unit economics (CAC payback period, LTV:CAC ratio improvements)
   - Revenue impact of retention (how much revenue is lost to churn?)
   - Cost of churn vs. cost of retention (which is cheaper?)

5. **Detailed Habit Stacking Implementation:**
   - Specific habit stacking formulas (James Clear's "After [X], I will [Y]")
   - How to identify anchor habits (what existing habits can we stack onto?)
   - Implementation in app (how to build habit stacking feature)
   - User onboarding for habit stacking (how to set it up)
   - Success rates (what percentage of users successfully stack habits?)
   - Examples from successful apps (who does this well?)

6. **Detailed Micro-commitments Strategy:**
   - What are micro-commitments (specific definition, examples)
   - How to implement micro-commitments in app (specific features)
   - Progression from micro to macro (how to scale up commitments)
   - Success rates (do micro-commitments actually improve retention?)
   - Examples from successful apps (who uses this strategy?)
   - Psychology behind micro-commitments (why do they work?)

**Success Criteria (Verifiable):**
- ✅ Each topic includes specific, actionable strategies (not theory)
- ✅ Each recommendation includes comparable company examples with data
- ✅ Each strategy includes implementation details (how to build it)
- ✅ Each tactic includes specific metrics (expected retention improvement)
- ✅ All strategies are 100% legal in Canada (CASL, PIPEDA, Law 25)
- ✅ All recommendations include risk assessment (what could go wrong)

---

## CONSTRAINTS (Parameters)

**Explicit Constraints (What NOT to Do):**

**DO NOT:**
- ❌ Research behavioral psychology principles (already covered)
- ❌ Research product mechanics from Duolingo, Strava, etc. (already covered)
- ❌ Research basic retention features (onboarding, streaks, daily quests) - already covered
- ❌ Research push notification strategies (already covered)
- ❌ Research implementation details (Core ML, iOS, Firebase) - already covered
- ❌ Include strategies that violate PIPEDA, GDPR, CCPA, or biometric data regulations
- ❌ Recommend dark patterns (deceptive design, forced engagement)
- ❌ Use temporal references ("current trends", "latest", "recent") - use specific dates/years
- ❌ Include strategies requiring >$1M initial investment
- ❌ Recommend illegal data collection or privacy violations

**MUST:**
- ✅ Focus ONLY on the 6 missing topics listed above
- ✅ All strategies must include specific metrics (Day 7, Day 30, DAU/MAU improvements)
- ✅ All recommendations must be implementable within 1-6 month timeline
- ✅ All strategies must include evidence from comparable companies
- ✅ All tactics must respect user privacy (explicit consent, CASL compliance)
- ✅ All recommendations must include legal compliance check (Canada-specific)

**Legal Requirements:**
- 100% compliance with CASL (Canada's Anti-Spam Legislation) for email/SMS
- Explicit opt-in required for all marketing communications
- PIPEDA compliance for data collection
- Quebec Law 25 compliance (if applicable)
- No deceptive practices (Competition Act)

---

## FORMAT (Output)

**Structure:** Follow this exact format with specific, verifiable data:

### 1. EXECUTIVE SUMMARY
- **Problem Statement:** Current retention gaps (what's missing)
- **Solution Overview:** Top 3-5 strategies from the 6 topics with expected impact
- **Key Metrics:** Target improvements (Day 7, Day 30, DAU/MAU)
- **Implementation Priority:** Ranked list by retention impact

### 2. EMAIL/SMS WIN-BACK CAMPAIGNS
For each campaign type:
- **Campaign Name:** (e.g., "Day 3 Inactive - Progress Snapshot")
- **Trigger:** (when to send - specific user behavior)
- **Email/SMS Template:** (exact copy, subject line)
- **Offer Strategy:** (discount, free trial, exclusive content)
- **Timing:** (specific time of day, day of week)
- **Frequency:** (how often to send)
- **Expected Impact:** (Day 7, Day 30 retention improvement)
- **Industry Benchmarks:** (open rates, click rates, conversion rates)
- **Legal Compliance:** (CASL requirements, opt-in verification)
- **A/B Testing Framework:** (what to test, sample sizes)
- **Risk Assessment:** (email fatigue, spam complaints)

**Required Campaigns:**
1. Day 3 inactive (early intervention)
2. Day 7 inactive (mid-stage intervention)
3. Day 14 inactive (late-stage intervention)
4. Day 30 inactive (win-back campaign)
5. Post-churn (re-engagement attempt)

### 3. CHURN PREDICTION SIGNALS
For each signal:
- **Signal Name:** (e.g., "Decreased Session Frequency")
- **Description:** (what behavior indicates churn risk)
- **Predictive Power:** (how accurate is this signal? % of users who churn within 7 days)
- **Detection Method:** (how to track this signal technically)
- **Intervention Strategy:** (what to do when signal detected)
- **Timing:** (when to intervene - immediate, 24h, 48h?)
- **Success Rate:** (what % of interventions prevent churn)
- **Implementation Details:** (analytics setup, automation)
- **Risk Assessment:** (false positives, user annoyance)

**Required Signals:**
1. Decreased session frequency (early warning)
2. Missed streak without recovery (immediate risk)
3. Reduced feature usage (engagement decline)
4. No progress photo uploads (value disconnect)
5. Subscription cancellation intent (final warning)

### 4. SPECIFIC RETENTION METRICS & BENCHMARKS
- **Industry Benchmarks by Category:**
  - Wellness apps: Day 7, Day 30, Day 90 retention (specific %)
  - Fitness apps: Day 7, Day 30, Day 90 retention (specific %)
  - Self-improvement apps: Day 7, Day 30, Day 90 retention (specific %)
  - Looksmaxxing apps: Current benchmarks (if available)

- **Target Metrics for This App:**
  - Day 7 retention: >25% (current: <15%)
  - Day 30 retention: >15% (current: <10%)
  - DAU/MAU: >20% (current: <15%)
  - Session frequency: >3x/week (current: <1x/week)
  - Monthly churn: <10% (current: high)

- **How to Measure:**
  - Analytics tools (Firebase Analytics, Mixpanel, Amplitude)
  - Tracking implementation (what events to track)
  - Cohort analysis setup
  - Retention curve interpretation

- **Benchmarking Sources:**
  - Industry reports (specific studies, years)
  - Comparable apps (Duolingo, Strava, Headspace - specific numbers)
  - Internal targets (what's achievable)

### 5. RETENTION ECONOMICS
For each calculation:
- **Metric:** (e.g., "LTV Impact of 10% Day 7 Retention Improvement")
- **Calculation:** (specific formula, assumptions)
- **Result:** (dollar amount, percentage improvement)
- **ROI:** (development cost vs. revenue impact)
- **Payback Period:** (how long to recoup investment)
- **Assumptions:** (user acquisition cost, subscription price, etc.)

**Required Calculations:**
1. LTV impact of Day 7 retention improvement (10% increase)
2. LTV impact of Day 30 retention improvement (5% increase)
3. Revenue lost to churn (current churn rate × ARPU × users)
4. Cost of retention feature vs. cost of churn (which is cheaper?)
5. ROI of win-back campaigns (campaign cost vs. recovered revenue)
6. CAC payback period improvement (how retention affects payback)

### 6. DETAILED HABIT STACKING IMPLEMENTATION
- **Definition:** What is habit stacking (James Clear's formula)
- **Psychology:** Why it works (scientific basis)
- **Implementation in App:**
  - How to identify anchor habits (user onboarding questions)
  - How to build the feature (technical requirements)
  - User flow (step-by-step implementation)
  - Success tracking (how to measure if it's working)

- **Examples from Successful Apps:**
  - Which apps use habit stacking (specific examples)
  - How they implement it (feature descriptions)
  - Success rates (retention improvements)

- **Expected Impact:**
  - Day 7 retention improvement (specific %)
  - Day 30 retention improvement (specific %)
  - User engagement increase (specific %)

- **Risk Assessment:**
  - What could go wrong (user confusion, complexity)
  - How to mitigate (simplification, testing)

### 7. DETAILED MICRO-COMMITMENTS STRATEGY
- **Definition:** What are micro-commitments (specific examples)
- **Psychology:** Why they work (scientific basis)
- **Implementation in App:**
  - How to build micro-commitments (specific features)
  - Progression system (micro → macro)
  - User flow (how users interact with micro-commitments)
  - Success tracking (how to measure effectiveness)

- **Examples from Successful Apps:**
  - Which apps use micro-commitments (specific examples)
  - How they implement it (feature descriptions)
  - Success rates (retention improvements)

- **Expected Impact:**
  - Day 7 retention improvement (specific %)
  - Day 30 retention improvement (specific %)
  - Conversion rate improvement (specific %)

- **Risk Assessment:**
  - What could go wrong (too easy, not engaging)
  - How to mitigate (progression, gamification)

### 8. IMPLEMENTATION ROADMAP
- **Phase 1 (Month 1):** Quick wins (Email/SMS campaigns, Churn prediction setup)
- **Phase 2 (Month 2-3):** Habit Stacking + Micro-commitments features
- **Phase 3 (Month 4+):** Advanced retention tactics

For each phase:
- **Features:** (list with descriptions)
- **Expected Impact:** (Day 7, Day 30, DAU/MAU improvement)
- **Implementation Timeline:** (specific weeks/months)
- **Dependencies:** (what must be built first)
- **Success Metrics:** (how to measure if it's working)

### 9. PRIORITIZED ACTION ITEMS
Ranked list by retention impact:
1. **Action Item:** (description, expected impact, implementation complexity)
2. **Action Item:** (description, expected impact, implementation complexity)
3. ... (continue for top 10-15 items)

---

## VERIFICATION CRITERIA (Quality Check)

**Before submitting, verify:**
- ✅ Every strategy focuses on the 6 missing topics (no duplicates)
- ✅ Every recommendation includes specific metrics (Day 7, Day 30, DAU/MAU)
- ✅ Every strategy includes implementation details (how to build it)
- ✅ Every tactic includes legal compliance check (Canada-specific, CASL)
- ✅ All strategies are ranked by retention impact (prioritized)
- ✅ All recommendations are implementable within 1-6 months
- ✅ All strategies respect user privacy and autonomy (no dark patterns)
- ✅ Document includes risk assessment for each strategy
- ✅ All data is from 2020-2026 (no outdated information)
- ✅ NO content on behavioral psychology principles (already covered)
- ✅ NO content on app mechanics from Duolingo/Strava (already covered)
- ✅ NO content on basic implementation details (already covered)

**Red Flags (Do NOT include):**
- ❌ Behavioral psychology principles (Variable Ratio, Zeigarnik, etc.) - ALREADY COVERED
- ❌ Product mechanics from apps (Duolingo streaks, Strava social) - ALREADY COVERED
- ❌ Basic retention features (onboarding, daily quests) - ALREADY COVERED
- ❌ Push notification strategies - ALREADY COVERED
- ❌ Core implementation details (Core ML, iOS, Firebase) - ALREADY COVERED
- ❌ Strategies without specific retention metric improvements
- ❌ Tactics that violate legal compliance (CASL, PIPEDA)
- ❌ Recommendations that damage user trust

---

## OUTPUT REQUIREMENTS

**Format:** Markdown document, 3,000-5,000 words (focused, no duplicates)
**Tone:** Analytical, data-driven, actionable
**Citations:** Include sources for all data, studies, and examples
**Specificity:** Use exact numbers, dates, and metrics (no vague statements)
**Actionability:** Every recommendation must be implementable

**Deliverables:**
1. Email/SMS Win-Back Campaigns (specific templates, timing, offers)
2. Churn Prediction Signals (early warning system, interventions)
3. Retention Metrics & Benchmarks (industry standards, targets)
4. Retention Economics (LTV calculations, ROI)
5. Habit Stacking Implementation (detailed feature design)
6. Micro-commitments Strategy (detailed feature design)
7. Implementation Roadmap (prioritized, phased approach)

---

**Last Updated:** January 12, 2026
