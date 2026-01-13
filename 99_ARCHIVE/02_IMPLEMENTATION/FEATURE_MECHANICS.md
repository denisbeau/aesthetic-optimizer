# Feature Mechanics: Addictive Design Implementations

**Purpose:** Specific feature designs adapted from proven apps  
**Status:** Reference for post-MVP development

---

## 1. DAILY ENGAGEMENT LOOP

### Morning (7 AM)
1. Push: "Your daily routine is ready! 🌅"
2. Open app → 3 daily quests appear
3. Complete quest 1 (morning routine)
4. **Zeigarnik:** 2 quests incomplete = return trigger

### Midday (12 PM)
5. Push: "Your progress photo timer is ready! 📸"
6. Upload photo → AI analysis (variable reward)
7. Get rating → "You're 0.3 points from 8.0!" (near-miss)
8. **Variable Reward:** Random bonus scan chance

### Afternoon (4 PM)
9. Push: "3 circle members visited you today! 👥"
10. Visit circle → Get motivation points
11. Check leaderboard → "You're #5 in Diamond League"
12. **Social Pressure:** Others ahead, need to catch up

### Evening (8 PM)
13. Push: "Your streak expires in 4 hours! ⏰"
14. Complete evening routine → Maintain streak
15. All 3 quests complete = bonus reward
16. **Loss Aversion:** Don't lose streak

---

## 2. DUOLINGO MECHANICS (Adapted)

### Streak System (✅ Implemented)
| Duolingo | Our App |
|----------|---------|
| Fire emoji + number | 🔥 23 Day Streak |
| Streak freeze (gems) | Streak freeze ($2.99) |
| "Streak at risk" notification | "Your streak expires in 4h!" |

### Hearts/Energy System (❌ Not Yet)
| Duolingo | Our App |
|----------|---------|
| 5 hearts, lose 1 per mistake | 3 scans/day free |
| Wait 5h to regenerate | 1 scan regenerates per 8h |
| Pay gems to refill | Premium = unlimited |

**Implementation:**
```swift
struct EnergySystem {
    var currentEnergy: Int = 3
    var maxEnergy: Int = 3
    var regenerationInterval: TimeInterval = 8 * 60 * 60 // 8 hours
    var lastRegenerationTime: Date
}
```

### Weekly Leaderboards (❌ Not Yet)
| Duolingo | Our App |
|----------|---------|
| Bronze → Diamond leagues | Glow-Up Leagues |
| Top 10 advance | Top 10 get Diamond status |
| Bottom 10 demote | Bottom 10 demote |
| Resets every Monday | Resets every Monday |

### Daily Quests (⚠️ Partial)
| Duolingo | Our App |
|----------|---------|
| Exactly 3 quests | 3 daily tasks |
| Red badge until done | ❌ No badge (add this) |
| Gems reward | Daily insight unlock |

---

## 3. FARMVILLE MECHANICS (Adapted)

### Crop Timers (Multiple Return Points)
| Timer | Action | Reward |
|-------|--------|--------|
| 5 min | Quick scan | Instant rating |
| 30 min | Progress check | Detailed analysis |
| 4 hours | Daily routine | Streak point |
| 24 hours | Weekly review | Comprehensive report |

**Purpose:** User checks app 4-6 times/day naturally.

### Achievement Collections
| Collection | Badges | Reward |
|------------|--------|--------|
| Streak Master | 7-day, 14-day, 30-day, 90-day | Prestige title |
| Skin Glow | Moisturizer, Retinol, SPF | "Skin Expert" badge |
| Perfect Week | 7 consecutive task completions | Bonus scan |

**Variable Drop:** Badges drop randomly from actions. "Gotta catch 'em all."

---

## 4. SLOT MACHINE MECHANICS

### Near-Miss Effect (❌ Not Yet)
```
Current: "Your score: 7.8"
Better: "You're 0.2 points away from 8.0! Scan again after skincare routine."
```

**Implementation:**
```swift
func displayNearMiss(score: Double) -> String? {
    let thresholds = [7.0, 7.5, 8.0, 8.5, 9.0]
    for threshold in thresholds {
        if score < threshold && score > threshold - 0.3 {
            return "You're \(String(format: "%.1f", threshold - score)) points from \(threshold)!"
        }
    }
    return nil
}
```

### Big Win Celebrations (❌ Not Yet)
| Event | Animation |
|-------|-----------|
| 7-day streak | Confetti + "🔥 ONE WEEK!" |
| Score improvement | Glow pulse + "↑ UP 0.3!" |
| First 8.0 rating | Fireworks + "MILESTONE!" |
| Perfect week | Trophy animation |

---

## 5. PUSH NOTIFICATION TEMPLATES

### Loss Aversion
```
"Your 23-day streak expires in 3 hours! ⏰"
"Don't let your progress slip away - complete today's routine"
```

### Social Proof
```
"Sarah just hit a 14-day streak - don't fall behind! 💪"
"3 people in your league completed today's routine"
```

### Near-Miss
```
"You're 0.3 points from hitting 8.0 - scan now!"
"Almost there! One more task to complete your Perfect Week"
```

### Variable Reward
```
"Bonus scan available for the next 30 minutes! 🎁"
"You just unlocked a rare badge - check it out! 🏆"
```

### Timing Strategy
| Time | Notification Type |
|------|------------------|
| 7-9 AM | Daily routine reminder |
| 8 PM Tuesday | "Golden Hour" engagement |
| 4h before midnight | Streak at risk warning |
| Random | Bonus/variable rewards |

---

## 6. SOCIAL FEATURES (Post-MVP)

### Accountability Circles
- 5-10 people per circle
- Share progress percentages (not photos)
- Daily "circle rank" based on task completion
- **Social obligation:** "3 members visited you today"

### Reactions
- 🔥 Amazing progress
- 💪 Keep going
- 👑 Transformation king

### Leaderboards
- Rank by "Glow-Up Velocity" (rate of improvement)
- NOT by static attractiveness score
- Rewards effort and consistency

---

## 7. IMPLEMENTATION PRIORITY

### Phase 1 (Week 1-2)
- [ ] Red notification badge on incomplete quests
- [ ] Near-miss messaging after scans
- [ ] Basic celebration animations

### Phase 2 (Week 3-4)
- [ ] Energy/hearts system
- [ ] Achievement badge collection
- [ ] Weekly leaderboards structure

### Phase 3 (Month 2)
- [ ] Accountability circles
- [ ] Reaction system
- [ ] Full gamification layer

---

## 8. HABIT STACKING IMPLEMENTATION

### The Psychology
Habit stacking leverages existing neural pathways. James Clear formula: "After [Current Habit], I will [New Habit]"

### Implementation Steps
1. **Onboarding Question:** "When is your main grooming routine? (Morning shower, Brushing teeth, Evening skincare)"
2. **Store as `trigger_timestamp`**
3. **Mirror Notification:** Trigger exactly 2 minutes after anchor habit time
4. **One-Tap Widget:** iOS home screen quick action for immediate logging

### User Flow
```
User finishes brushing teeth (Anchor)
  → Haptic nudge (Cue)
  → Opens app to "Daily Progress" camera (Action)
  → AI provides "Morning Glow Score" (Reward)
```

### Success Rate
Users with weekly visual documentation report **37% better adherence** than those without.

---

## 9. MICRO-COMMITMENTS LADDER

### Progressive Investment System
| Level | Action | Investment |
|-------|--------|------------|
| 1 | One-tap mood log | 2 seconds |
| 2 | 7-question quiz | 60 seconds |
| 3 | Name + email (to "save progress") | 30 seconds |
| 4 | $1 trial | Financial threshold |
| 5 | Full subscription | Identity commitment |

### Invisible Wins
- Auto-fill from previous scans (silent commitment)
- Apple Health integration (feels like app "knows" them)
- Change "The Plan" to "Your Plan" (endowment effect)

### Metric
Track "Commitment Velocity" — time from first tap to first photo upload.

---

## 10. RETENTION LEVERS (Evidence-Based)

### What Works (Ranked by Impact)
1. **Streaks with Freeze Protection** — 2.4x more likely to return after 7+ days
2. **Personalized Push at "Mirror Time"** — 3.5x open rate vs generic
3. **Near-Miss Messaging** — 30% increase in engagement
4. **AI Comparison Slider** — High investment/endowment score
5. **Accountability Circles** — 22% higher task completion with friend streak

### What Doesn't Work
- Generic tips without personalization
- Static ratings (users treat as one-off diagnostic)
- Fixed quotas without adaptation
- Rigid schedules without flexibility

### Target Metrics
| Metric | Target | Kill Signal |
|--------|--------|-------------|
| Day 7 Retention | >25% | <10% |
| Day 30 Retention | >15% | <5% |
| DAU/MAU | >20% | <15% |
| Session Frequency | >3x/week | <1x/week |
| Monthly Churn | <10% | >15% |
