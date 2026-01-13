# Implementation Index: Aesthetic Optimizer

**Last Updated:** January 12, 2026  
**Status:** Consolidated from 13 source files → 3 canonical files

---

## CANONICAL IMPLEMENTATION FILES

### 1. `MVP_SPEC.md`
**Purpose:** Complete technical specification for AI coding agents.

**Contains:**
- Core user loop (scan → rating → streak → return)
- Feature set (must-have, nice-to-have, excluded)
- Technical architecture (SwiftUI, Core Data, Vision framework)
- File structure and code patterns
- Success metrics and kill criteria
- Legal requirements

**Merged from:**
- mvp-specification.md
- mvp-specification-detailed.md
- mvp-ai-coding-prompts.md

### 2. `ONBOARDING_SPEC.md`
**Purpose:** 12-question psychological priming flow.

**Contains:**
- Complete question sequence with copy
- Psychological principles per question
- Flow structure (questions → analyzing → tease → paywall)
- UI specifications
- Implementation status (✅ BUILT)

**Source:** Gemini onboarding optimization research (NEW CONTENT integrated)

### 3. `FEATURE_MECHANICS.md`
**Purpose:** Specific addictive feature implementations.

**Contains:**
- Duolingo mechanics adaptation (streaks, hearts, leagues)
- FarmVille mechanics adaptation (energy, timers, collections)
- Social mechanics (circles, reactions, challenges)
- Daily loop design (morning → midday → evening → night)
- Push notification strategy with exact templates

**Merged from:**
- specific-mechanics.md
- implementation-roadmap.md (feature sections)

---

## REMOVED FILES (Reason)

| File | Reason |
|------|--------|
| mvp-specification.md | Merged into MVP_SPEC.md |
| mvp-specification-detailed.md | Merged into MVP_SPEC.md |
| mvp-ai-coding-prompts.md | Merged into MVP_SPEC.md |
| implementation-roadmap.md | Feature sections → FEATURE_MECHANICS.md, rest outdated |
| action-plan.md | Outdated, superseded by MVP spec |
| next-steps-prioritized.md | Outdated |
| framework-priority-analysis.md | Superseded |
| revised-strategy-analysis.md | Superseded by CANONICAL_PROJECT_BRIEF.md |
| business-model-audit.md | Key insights in monetization-strategy.md |
| product-audit.md | Key insights in CANONICAL_PROJECT_BRIEF.md |
| market-durability-analysis.md | Conclusion in project brief |
| umax-case-study.md | Merged into monetization-strategy.md |

---

## WHAT'S BUILT VS. PLANNED

### ✅ IMPLEMENTED (In Codebase)
- 12-question onboarding flow (OnboardingQuizView.swift)
- "Analyzing" loading animation (AnalyzingView.swift)
- Results tease with locked items (ResultsTeaseView.swift)
- Personalized paywall (PersonalizedPaywallView.swift)
- Dark theme home screen (HomeViewDark.swift)
- Streak system (StreakViewModel.swift)
- Push notifications (NotificationService.swift)
- AI facial analysis (CoreMLService.swift)
- Subscription paywall (PaywallView.swift)

### ❌ NOT YET IMPLEMENTED
- Energy/Hearts system
- Weekly leaderboards
- Accountability circles
- Achievement badge collection
- Near-miss effect messaging
- Consumable IAPs (Streak Freeze, Scan Boosters)
- Rewarded video ads
- Big win celebrations (confetti, sounds)
