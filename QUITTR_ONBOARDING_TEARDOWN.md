# Quittr Onboarding Technical Specification
**Reverse-Engineered UI/UX Architecture**  
**Date:** January 2025  
**Purpose:** Complete technical implementation guide for Quittr's onboarding flow

---

## Screen Inventory

| Timestamp | Screen Name | Core UI Elements | User Action |
|-----------|-------------|------------------|-------------|
| 00:00 | Splash / Intro | Brand Logo (QUITTR), Dynamic text captions, 5-star rating icon | Automatic transition |
| 00:04 | Welcome / Intent | Header, Subheader, "Start Quiz" CTA button | Single-tap button |
| 00:06 | Quiz Q1: Gender | Question text, Vertical option list (Male, Female) | Single-tap option |
| 00:08 | Quiz Q2: Frequency | Question text, Vertical option list (4 options) | Single-tap option |
| 00:11 | Quiz Q3: Source | Question text, Vertical option list (6 options) | Single-tap option |
| 00:15 | Quiz Q4: Progression | Question text, Yes/No toggle options | Single-tap option |
| 00:18 | Quiz Q5: Onset | Question text, Age bracket options | Single-tap option |
| 00:20 | Quiz Q6: Physiological Impact | Question text, Frequency scale (Rarely to Frequently) | Single-tap option |
| 00:22 | Quiz Q7: Emotional Coping | Question text, Frequency scale | Single-tap option |
| 00:24 | Quiz Q8: Stress Response | Question text, Frequency scale | Single-tap option |
| 00:25 | Quiz Q9: Boredom Trigger | Question text, Frequency scale | Single-tap option |
| 00:27 | Quiz Q10: Monetization | Question text, Yes/No toggle options | Single-tap option |
| 00:33 | User Profile Input | Text input fields (Name, Age), "Complete Quiz" CTA button, System keyboard | Text input & tap CTA |
| 00:44 | Labor Illusion / Processing | Circular progress bar (0-100%), Dynamic status text (Calculating/Analyzing) | Automatic transition |
| 00:50 | Results Dashboard | Comparative bar chart (User vs. Average), Percentage callout, "Check your symptoms" CTA | Single-tap button |
| 00:55 | Symptom Checklist | Scrollable multi-select list (Mental, Physical, Social categories) | Multi-tap selection & scroll |
| 01:09 | Problem-Agitation Carousel | Horizontal slider, Iconography, Bold educational text, Pagination dots | Automatic / Swipe transition |
| 01:16 | Feature Value Propositions | Custom illustrations, Media logos (Forbes, etc.), Benefit text | Swipe transition |
| 01:21 | Social Proof / Testimonials | Scrollable list, User avatars, Verified badges, Text quotes | Vertical scroll |
| 01:29 | Recovery Timeline Graph | Multi-line area chart (Relapse vs. Sobriety), Comparison caption | Vertical scroll |
| 01:31 | Goal Selection | Scrollable multi-select list, Color-coded icons | Multi-tap selection |
| 01:40 | Social Proof Grid | Reviewer profiles, Star ratings, Long-form testimonials | Vertical scroll |
| 01:43 | Commitment Signature | Instructional text, Signature canvas (whiteboard), "Clear" button | Manual gesture (draw) |
| 01:49 | Personalized Welcome | Tokenized text (User Name), Brand value statement | Automatic transition |
| 01:53 | Plan Preview Card | Virtual ID card UI, "Active Streak" counter, "Free since" date | Automatic transition |
| 02:04 | Personalized Plan / Paywall | Targeted quit date, Benefit badges, "Become a QUITTR" CTA, Feature list | Vertical scroll |
| 02:13 | Free Trial Offer | Device mockup (App UI), Checkbox icon, "Try For $0.00" CTA | Single-tap button |

---

## Detailed Screen Specifications

### Screen 1: Splash / Intro

**Overview:** Pattern interrupt designed to induce mindfulness through deep colors and rhythmic text pacing.

**Visual Hierarchy:**
- **Background:** Linear gradient with "Star Field" particle overlay
  - Top-Left: `#125E75` (Deep Teal)
  - Center: `#081630` (Navy)
  - Bottom-Right: `#040712` (Midnight Black)
- **Brand Logo:** White (`#FFFFFF`), bold, wide-set futuristic sans-serif
- **Social Proof Icon:** Five gold stars (`#FFD700`) with white laurel wings, 40px below caption

**Micro-interactions:**
- Logo: Static, 100% opacity from t=0
- Line 1 ("Embrace this pause."): Fades in at t=0.2s
- Line 2 ("Reflect before you relapse"): Fades in at t=0.8s
- Rating Icon: Fades in at t=1.4s
- **Easing:** ease-out-quad, 500ms per element
- **Offset:** Text slides upward from y: +10px to y: 0

**Copy Analysis:**
- "Embrace this pause": Validates current state, invitation not order
- "Reflect before you relapse": Psychological speed bump, filters for high-temptation users
- "Superhealth": Parent brand positioning

**SwiftUI Implementation:**
```swift
Text("Embrace this pause.")
    .font(.system(size: 18, weight: .medium))
    .opacity(startAnimation ? 1 : 0)
    .offset(y: startAnimation ? 0 : 10)
    .animation(.easeOut(duration: 0.5).delay(0.2), value: startAnimation)
```

---

### Screen 2: Welcome / Intent

**Overview:** Commitment gate transitioning user from passive observer to active participant.

**Layout:**
- Background: Continuous from Splash (navy-to-teal gradient with star field)
- Text: Center-aligned
- CTA: Centered at bottom safe area
- Padding: ~32px side, ~60px vertical spacing

**Copy Strategy:**
- Header: "Welcome!" (Friendly)
- Subheader: "Let's start by finding out if you have a problem with porn"
  - Low barrier: Diagnostic, not accusatory
  - Curiosity gap: Triggers inquiry reflex
- CTA: "Start Quiz" with right chevron (>)

**CTA Button Specs:**
- Background: `#FFFFFF` (Solid White)
- Text/Icon: `#081630` (Dark Navy)
- Border Radius: 50px (Full Pill)
- Font Weight: Semibold (600)
- Shadow: `0px 4px 15px rgba(0, 0, 0, 0.2)`
- Tap State: Scale to 0.97, medium haptic pulse

**Entrance Animation:**
- Stage 1 (0ms): "Welcome!" fades in with +15px Y-offset
- Stage 2 (150ms): Subheader fades in
- Stage 3 (300ms): Social proof icon fades in
- Stage 4 (450ms): CTA button slides up with spring-damper

---

### Screens 3-12: Quiz Questions (Q1-Q10)

**Component Architecture:**
- **Header:** "QUESTION #X" (Uppercase, Semibold, underline)
- **Question Text:** Large bold sans-serif (~24px), 20px below header
- **Options:** Vertical stack, 12px spacing
  - Index Circle (left) → Label Text → Status Indicator (hidden checkmark)

**Option Styling:**
- **Default:**
  - Shape: Pill/Capsule (50px border-radius)
  - Background: `#0B1222` (Transparent Navy)
  - Border: 1px solid `#1E293B`
- **Selected:**
  - Background: `#10B981` at 10% opacity
  - Border: 2px solid `#10B981`
  - Index Circle → Green Checkmark

**Auto-Advance Pattern:**
- Selected state renders for 350ms (visual confirmation)
- Transition: Quick crossfade
- Exit: Fade out + scale down (0.98)
- Entrance: Fade in + scale up (0.98 to 1.0)
- Easing: `cubic-bezier(0.4, 0, 0.2, 1)`

**React/TypeScript Implementation:**
```typescript
const handleSelect = (id: number) => {
  setSelected(id);
  setTimeout(() => {
    onNext(id);
    setSelected(null);
  }, 450); // Auto-advance delay
};
```

**Technical Colors:**
- Background: `#050914`
- Text: `#FFFFFF`
- Success Accent: `#4ADE80`

---

### Screen 13: User Profile Input

**Overview:** Lead capture phase shifting from anonymous to personal identification.

**Form UI:**
- Keyboard-Avoiding View: Container shifts ~120px vertically when focused
- CTA remains visible 10px above keyboard
- Input Fields:
  - Background: `rgba(255, 255, 255, 0.05)`
  - Border: 1px solid `rgba(255, 255, 255, 0.3)`
  - Border Radius: 15px
  - Active Focus: Border opacity → 0.8
  - Placeholder: `#A0A0A0` (muted light-gray)

**CTA Strategy:**
- Button: "Complete Quiz" (interactive by default)
- Validation: Opacity 0.6 until both fields pass (Name > 2 chars, Age > 12)
- "Complete" triggers closure psychology

**Exit Animation:**
- Keyboard dismissed programmatically
- Simultaneous dissolve + scale-up
- Screen fades out, "Calculating" fades in (scale 0.95 → 1.0)

**React Native Implementation:**
```typescript
const handleComplete = () => {
  Keyboard.dismiss();
  if (formData.name.length > 0 && formData.age.length > 0) {
    onComplete(formData);
  }
};
```

---

### Screen 14: Labor Illusion / Processing

**Overview:** Increases perceived value through fake processing delay (Ben Franklin effect).

**Circular Progress Bar:**
- **Variable Velocity (Stutter-Stepping):**
  - 0-25%: Rapid acceleration (~0.8s)
  - 25-64%: Drastic slowdown (~2.5s) - "heavy lifting" simulation
  - 64-100%: Final burst (~1.2s)
- **Visual:** 4px stroke
  - Track: `rgba(255, 255, 255, 0.1)`
  - Fill: `#4ADE80` (Emerald Green)
  - Glow: Drop-shadow for light-emitting effect

**Status Text Sequence:**
- "Analyzing patterns..." (triggered at 5%)
- "Processing data..." (triggered at 70%)
- Main Title: "Calculating" (static throughout)

**Total Duration:** 5.5-6.5 seconds

**JavaScript Progress Simulator:**
```javascript
const simulateProgress = (updateProgress, updateLabel, onComplete) => {
  let progress = 0;
  const interval = setInterval(() => {
    let increment = 0;
    if (progress < 25) increment = Math.random() * 5;
    else if (progress < 65) increment = Math.random() * 1.5; // Slowdown
    else increment = Math.random() * 8;
    
    progress = Math.min(progress + increment, 100);
    updateProgress(Math.floor(progress));
    
    if (progress >= 100) {
      clearInterval(interval);
      setTimeout(onComplete, 500);
    }
  }, 150);
};
```

---

### Screen 15: Results Dashboard

**Overview:** "Aha!" moment using social comparison to induce concern/urgency.

**Chart Structure:**
- Type: Comparative Vertical Bar Chart
- Dimensions: ~40% of screen height
- Bar Width: ~80px each
- Corner Radius: 10px (top only)
- Spacing: 40px gutter

**Color Logic:**
- User Bar (High Risk): `#F13644` (Vivid Crimson)
- Average Bar (Baseline): `#2DD4BF` (Bright Teal)

**Typography:**
- Percentages: 32px Bold, White (`#FFFFFF`)
- Sub-labels: 14px Medium, Muted White (`#D1D5DB`)

**Header Section:**
- Status: "Analysis Complete" with Green Checkmark (`#10B981`)
- Headline: "We've got some news to break to you..."
- Statement: "Your Responses indicate a clear dependence on internet porn*"
- Gap Callout: "39% higher dependence on porn" (52% - 13%)

**Staggered Bar Growth Animation:**
1. Average (Teal) bar: 0 → 13% over 600ms
2. 200ms delay
3. User (Red) bar: 0 → 52% over 1200ms

**SwiftUI Implementation:**
```swift
struct ResultChart: View {
    @State private var averageHeight: CGFloat = 0
    @State private var userHeight: CGFloat = 0

    var body: some View {
        HStack(alignment: .bottom, spacing: 40) {
            // Average Bar
            VStack {
                Text("13%").font(.headline).foregroundColor(.white)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#2DD4BF"))
                    .frame(width: 80, height: averageHeight)
                Text("Average").font(.caption).foregroundColor(.gray)
            }
            
            // User Bar
            VStack {
                Text("52%").font(.title).bold().foregroundColor(.white)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#F13644"))
                    .frame(width: 80, height: userHeight)
                Text("Your Score").font(.caption).foregroundColor(.white)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                averageHeight = 60
            }
            withAnimation(.easeOut(duration: 1.2).delay(0.3)) {
                userHeight = 240
            }
        }
    }
}
```

---

### Screen 16: Symptom Checklist

**Overview:** Self-diagnosis phase increasing problem awareness and psychological buy-in.

**Information Architecture:**
- Structure: Single-column scrollable list
- Categories: Mental, Physical, Social, Faith
- Category Headers: Uppercase, Muted Light-Gray (`#9CA3AF`), 24px top-margin
- List Density: 5-6 items visible, 56px row height, 10px gutter

**Symptom Row Component:**
- **Default:**
  - Container: Pill-shaped outline, 1px border `rgba(255, 255, 255, 0.2)`
  - Indicator: Circular outline (24px diameter)
  - Typography: 16px Medium white text
- **Selected:**
  - Indicator: Circle fills with Deep Red (`#E11D48`)
  - Icon: White checkmark (✓) centered
  - No row-color change (focus on checked status)

**Scrolling:**
- Lazy Loading: FlashList or FlatList for 60fps
- "Continue" CTA: Sticky bottom with gradient fade/blur

**Data Structure (JSON):**
```json
{
  "groups": [
    {
      "id": "mental",
      "label": "Mental",
      "items": [
        {"id": "unmotivated", "text": "Feeling unmotivated"},
        {"id": "ambition", "text": "Lack of ambition to pursue goals"},
        {"id": "concentration", "text": "Difficulty concentrating"}
      ]
    }
  ]
}
```

**SwiftUI Implementation:**
```swift
struct SymptomRow: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                        .frame(width: 26, height: 26)
                    
                    if isSelected {
                        Circle()
                            .fill(Color(hex: "#E11D48"))
                            .frame(width: 26, height: 26)
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                Text(text)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
        }
    }
}
```

---

### Screen 17: Problem-Agitation Carousel

**Overview:** Transitions from self-diagnosis to educational conviction using high-urgency red palette.

**Carousel Architecture:**
- Navigation: Horizontal paging with fixed snapping
- Pagination: 5 dots
  - Active: `#FFFFFF` 100% opacity, scale 1.2x
  - Inactive: `rgba(255, 255, 255, 0.4)` 40% opacity
- Position: Fixed bottom: 40px, centered
- Auto-play: 5000ms fallback timer

**Background Color Interpolation:**
- Slides 1-4: Agitation Red (`#E11D48`)
- Slide 5: Recovery Teal (`#125E75`)
- Interpolation between penultimate and final slide

**Iconography:**
- Slide 1: Pink brain/cloud (biological target)
- Slide 2: Broken heart (relationship impact)
- Slide 3: Gender symbols (sexual impact)
- Slide 4: Sad droplet (emotional impact)
- Slide 5: Sprouting plant (path to recovery)

**Typography:**
- Header: 28px Bold, White, centered
- Body: 16px Regular, White, 1.5 line-height
- Ratio: 1.75:1 (Header:Body)

**React Native Implementation:**
```typescript
const animatedStyle = useAnimatedStyle(() => {
  const backgroundColor = interpolateColor(
    progressValue.value,
    [0, 3, 4],
    ["#E11D48", "#E11D48", "#125E75"]
  );
  return { backgroundColor };
});
```

---

### Screen 18: Feature Value Propositions

**Overview:** Transition from "Agitation" (Red) to "Solution" (Teal/Navy) using trust anchors.

**Layout:**
- Media Logo Bar: Fixed bottom (~60px above pagination)
  - Logos: Forbes, LA Weekly, TechTimes
  - Filter: grayscale(100%) + brightness(200%) = white silhouettes
  - Opacity: 0.85
  - Alignment: flex-row, space-around

**Illustrations:**
- Style: Flat, high-contrast vectors
- Color Palette: Teal, Navy, Action Yellow (`#FFD700`)
- Yellow: Exclusive for key objects (jetpacks, keys, trophies)

**Copy Hierarchy:**
- Header: 24px Bold, White
- Supporting Text: 15px Regular, `#E5E7EB`, 1.6 line-height

**Interaction:**
- Swipe: Horizontal paging carousel
- Parallax: Illustration moves faster than text (3D depth)
- Pagination: Shared dots with previous sequence

**SwiftUI Implementation:**
```swift
struct FeatureCard: View {
    let illustration: String
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 24) {
            Image(illustration)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 220)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.system(size: 16))
                    .foregroundColor(Color.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }
        }
        .padding(.top, 40)
    }
}
```

---

### Screen 19: Social Proof / Testimonials

**Overview:** Confirmation bias stage normalizing recovery process through verified success stories.

**Testimonial Card Structure:**
- Header Row:
  - Avatar: 40x40px circular image (left)
  - User Info: Display Name (16px Bold) + Handle (14px Regular, `#9CA3AF`)
  - Verified Badge: Green circle with white checkmark (`#10B981`)
- Rating Row: Five solid gold stars (`#FACC15`), 14px each, 2px spacing
- Body Text: 15px Regular, White, 1.5 line-height

**Visual Container:**
- Background: `rgba(255, 255, 255, 0.03)` (Ultra-subtle glassmorphism)
- Border: 1px solid `rgba(255, 255, 255, 0.1)`
- Corner Radius: 16px
- Shadow: `0px 4px 12px rgba(0, 0, 0, 0.25)`

**Scrolling:**
- Direction: Vertical only
- Momentum: Normal deceleration rate
- Spacing: 16px vertical margin
- Truncation: None (full text displayed)

**Sample Data (JSON):**
```json
[
  {
    "id": "user_01",
    "name": "Connor",
    "verified": true,
    "stars": 5,
    "text": "Quitting has allowed me to change my mindset on the little things in life...",
    "avatar_url": "https://cdn.quittr.com/avatars/connor.jpg"
  }
]
```

**React Native Implementation:**
```typescript
export const TestimonialCard = ({ user }) => (
  <View style={styles.card}>
    <View style={styles.header}>
      <Image source={{ uri: user.avatar_url }} style={styles.avatar} />
      <View style={styles.userInfo}>
        <View style={styles.nameRow}>
          <Text style={styles.name}>{user.name}</Text>
          {user.verified && (
            <Ionicons name="checkmark-circle" size={16} color="#10B981" />
          )}
        </View>
        <View style={styles.starRow}>
          {[...Array(user.stars)].map((_, i) => (
            <Ionicons key={i} name="star" size={14} color="#FACC15" />
          ))}
        </View>
      </View>
    </View>
    <Text style={styles.body}>{user.text}</Text>
  </View>
);
```

---

### Screen 20: Recovery Timeline Graph

**Overview:** Visualizes "Willpower Gap" through dual-line area chart contrasting unassisted vs. QUITTR recovery.

**Chart Structure:**
- Type: Dual-Layered Spline Area Chart
- Data Line A (Old Way):
  - Style: Spiky sawtooth
  - Color: `#F13644` (Crimson)
  - Visual Cues: Five red "X" marks (relapses)
  - Fill: Vertical gradient `#F13644` 20% opacity → transparent
- Data Line B (QUITTR):
  - Style: Smooth sigmoid/growth curve
  - Color: `#4ADE80` (Emerald Green)
  - Visual: Steady upward trajectory to "Sobriety" plateau
  - Fill: Vertical gradient `#4ADE80` 30% opacity → transparent

**Axis & Labels:**
- X-Axis: "Week 1", "Week 2", "Week 3" in `#9CA3AF`, 12px
- Y-Axis: No numeric labels (represents Progress/Rewiring)

**Draw Animation:**
- Trigger: On screen entrance
- Logic: stroke-dashoffset animation, both lines simultaneously
- Duration: 1500ms
- Easing: ease-in-out-cubic
- Dynamic Annotations: "X" marks fade in at t+1200ms

**Comparison Caption:**
- Text: "QUITTR helps you quit porn 76% faster than willpower alone. 📈"
- Placement: Fixed footer, center-aligned

**React Native SVG Implementation:**
```typescript
const spikyD = "M0,80 L20,40 L40,90 L60,30 L80,100 L100,50 L120,110 L140,60 L160,120";
const smoothD = "M0,120 C40,120 60,10 160,10";

const animatedProps = useAnimatedProps(() => ({
  strokeDashoffset: progress.value * 500,
}));
```

---

### Screen 21: Goal Selection

**Overview:** Aspirational bridge shifting focus from pain to reward.

**Layout:**
- Type: Single-column vertical list
- Row Dimensions: 64px height, 12px vertical gutter
- Border Radius: 50px (Full Capsule)
- Background: `rgba(255, 255, 255, 0.05)`
- Border: 1px solid `rgba(255, 255, 255, 0.15)`

**Iconography:**
- Style: Glossy 3D-effect emojis/glyphs
- Color Coding: High-contrast saturated colors
  - Red Heart: Relationships
  - Yellow Face: Happiness
  - Blue Figure: Confidence
  - Green Spark: Energy

**Selection Feedback:**
- Active State:
  - Right-hand circle fills with category color
  - White checkmark (✓) appears
  - Border opacity → 0.8
  - Haptic: Selection pulse (Impact Light)

**Goal Inventory:**
1. Stronger relationships (Social)
2. Improved self-confidence (Internal)
3. Improved mood and happiness (Emotional)
4. More energy and motivation (Performance)
5. Improved libido and sex life (Physical)
6. Improved self-control (Discipline)
7. Improved focus and clarity (Cognitive)
8. Pure and healthy thoughts (Mental/Faith)

**Data Schema (JSON):**
```json
[
  {
    "id": "rel_01",
    "title": "Stronger relationships",
    "icon": "❤️",
    "category": "social",
    "accent_color": "#F43F5E"
  }
]
```

**Staggered Entrance (React Native):**
```typescript
{goals.map((goal, index) => (
  <Animated.View 
    key={goal.id}
    entering={FadeInUp.delay(index * 100).duration(500)}
  >
    <GoalRow goal={goal} />
  </Animated.View>
))}
```

---

### Screen 22: Social Proof Grid

**Overview:** Social gravity phase creating overwhelming validation through high-volume verified reviews.

**Grid Layout:**
- Type: 2-Column responsive grid
- Style: Masonry-Lite (dynamic heights)
- Content Density: 4-6 micro-reviews per scroll-length
- Visual Rhythm: Alternating 4-line and 2-line reviews

**Review Card Style:**
- Background: `rgba(255, 255, 255, 0.05)`
- Corner Radius: 16px
- Border: 1px solid `rgba(255, 255, 255, 0.1)`
- Shadow: `0px 4px 12px rgba(0, 0, 0, 0.25)`
- Verification: Green circle-check (`#10B981`)
- Stars: `#FACC15` (Solid Gold), horizontal flex-row, 2px spacing

**Scrolling:**
- Physics: Continuous vertical with standard friction
- Animation: Fade-In on Scroll (entrance at bottom 10% viewport)
- Transition: 300ms opacity 0 → 1
- Auto-transition: End of content → instant opacity swap to Signature screen

**React Native FlashList:**
```typescript
<FlashList
  data={reviews}
  numColumns={2}
  estimatedItemSize={150}
  renderItem={({ item }) => <ReviewCard data={item} />}
  contentContainerStyle={{ padding: 16 }}
/>
```

---

### Screen 23: Commitment Signature

**Overview:** Psychological "point of no return" leveraging Consistency Principle.

**Canvas Architecture:**
- Container: Large centered rectangle, 16:9 aspect ratio
- Background: Solid White (`#FFFFFF`)
- Corner Radius: 12px
- Border: None (shadow-based elevation)
- "Ink" Physics:
  - Type: Vector Path (SVG-based)
  - Color: Solid Black (`#000000`)
  - Line Weight: 4px fixed
  - Smoothing: High (Quadratic Bezier)

**Control Elements:**
- "Clear" Button: Text-only, 12px below bottom-left corner
  - Styling: White text, 14px medium weight

**Instruction & Header:**
- Header: "Sign your commitment" (26px Bold)
- Subtitle: "Finally, promise yourself that you will never watch porn again."
- Prompt: "Draw on the open space above" (14px Muted Gray, centered)

**Completion Trigger:**
- Logic: Stroke Detection listener
- Validation: Minimum path length 50 units
- Haptic: Continuous light haptic during draw
- Exit: 300ms fade-out after valid stroke

**React Native Implementation:**
```typescript
<SignatureScreen
  ref={ref}
  onEnd={handleEnd}
  onOK={handleOK}
  descriptionText="Draw on the open space above"
  clearText="Clear"
  penColor={"#000000"}
/>
```

---

### Screen 24: Personalized Welcome

**Overview:** Palate cleanser between signature and final offer, rebuilding trust.

**Personalization:**
- Header: "Hey [Name]," (28px Bold, White)
- Sub-Message: "Welcome to QUITTR, your path to freedom." (20px Medium, White)
- "QUITTR" underlined for brand reinforcement

**Visual Composition:**
- Background: Deep navy starry gradient (`#081630`)
- Layout: Top-aligned, 120px from top notch
- Brand: Inline within text (personal letter feel)

**Animation:**
- Entrance: "Gentle Rise"
  - Header: 0ms delay
  - Sub-Message: 200ms delay
  - Elements: 10px upward drift + opacity fade
- Duration: 1800ms
- Exit: 400ms cross-dissolve to Plan Preview Card

**SwiftUI Implementation:**
```swift
struct PersonalizedWelcome: View {
    let userName: String
    @State private var opacity: Double = 0
    @State private var yOffset: CGFloat = 10

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hey \(userName),")
                .font(.system(size: 28, weight: .bold))
            Text("Welcome to _QUITTR_, your path to freedom")
                .font(.system(size: 20, weight: .medium))
        }
        .foregroundColor(.white)
        .padding(.top, 120)
        .opacity(opacity)
        .offset(y: yOffset)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                opacity = 1
                yOffset = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                onComplete()
            }
        }
    }
}
```

---

### Screen 25: Plan Preview Card

**Overview:** Ownership phase leveraging IKEA Effect and Endowment Effect.

**Card Design:**
- Container: Premium Virtual ID Pass
- Dimensions: 1.586:1 aspect ratio (Standard ID-1)
- Background: Animated Mesh Gradient
  - Colors: Crimson (`#F43F5E`), Deep Orange (`#FB923C`), Indigo (`#4F46E5`)
  - Overlay: 5% opacity noise/grain texture
- Border Radius: 24px
- Shadow: `0px 20px 50px rgba(0,0,0,0.4)` (multi-layered)
- Gloss Effect: Diagonal linear-gradient light sweep (white 20% opacity)

**Layout:**
- Top-Left: "QTR" Brand Mark (white circular border)
- Top-Right: Profile/Account Icon (person silhouette in rounded box)
- Primary Metric: "Active Streak: 0 days"
  - Label: Small uppercase, muted white `rgba(255,255,255,0.7)`
  - Value: Large Bold, high-contrast White
- Personal Data Row:
  - Name: From User Profile Input
  - Free since: Dynamic date (MM/DD format, e.g., "01/14")

**Animation:**
- Entrance: SlideUp + Spring damping
  - Behavior: Slide from bottom with overshoot bounce
  - Damping: 0.7, Stiffness: 120
- Presence (Idle):
  - Glint: Shimmering light every 2.5 seconds
  - Floating: Slow Y-axis oscillation (±5px over 4000ms)
- Exit: 2200ms pause, then text changes + vertical scroll to Personalized Plan

**SwiftUI Implementation:**
```swift
struct VirtualIDCard: View {
    let userName: String
    let startDate: String = Date().formatted(.dateTime.month().day())

    var body: some View {
        ZStack {
            LinearGradient(colors: [.red, .orange, .blue], 
                          startPoint: .topLeading, 
                          endPoint: .bottomTrailing)
                .overlay(Color.black.opacity(0.1))
            
            VStack(alignment: .leading) {
                HStack {
                    Image("qtr_logo_circle")
                    Spacer()
                    Image(systemName: "person.crop.rectangle")
                }
                .foregroundColor(.white)
                
                Spacer()
                
                Text("ACTIVE STREAK").font(.caption2).opacity(0.7)
                Text("0 days").font(.title).bold()
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("NAME").font(.caption2).opacity(0.7)
                        Text(userName).bold()
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("FREE SINCE").font(.caption2).opacity(0.7)
                        Text(startDate).bold()
                    }
                }
            }
            .padding(24)
            .foregroundColor(.white)
        }
        .frame(width: 340, height: 210)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 15)
    }
}
```

---

### Screen 26: Personalized Plan / Paywall

**Overview:** Endowment Effect culmination transitioning from diagnostic tool to personalized solution.

**Hero Header & Goal Anchoring:**

**Quit Date Banner (The "North Star"):**
- Copy: "You will quit porn by: [Date]"
- Date Logic: Current Date + 60 days (8 weeks)
- Styling:
  - Container: Solid White capsule (`#FFFFFF`)
  - Typography: Bold Sans-serif, Deep Navy text (`#081630`), 20px
  - Visual Weight: Highest on page

**Benefit Badges (Dynamic Mirroring):**
- Logic: Displays goals selected in Goal Selection screen
- Architecture: Flex-wrap tag cloud of rounded pills
- Styling:
  - Background: Muted Navy with thin colored border matching goal category
  - Icons: Miniature versions of high-res icons from Goal Selection

**Pricing & Feature List:**

**The "Become a QUITTR" CTA:**
- Style: High-contrast solid White (`#FFFFFF`)
- Typography: Extra-Bold Navy text (`#081630`), 20px
- Animation: Pulse/Breath (Scale 1.0 to 1.03 every 2000ms)

**Privacy Sub-label:**
- Text: "Purchase appears Discretely"
- Placement: Immediately below CTA in Muted Gray (`#9CA3AF`)
- Purpose: Critical "Safety Signal" for shame-based friction

**Visual Hierarchy:**
- Above the Fold: Personalized Header → Quit Date Banner → Star Ratings → First row of Benefit Badges
- Scroll Strategy: Long-form sales letter with re-stated value props (testimonials, recovery graph)
- Background Continuity: Plan Preview Card dissolves into this layout (500ms fade)

**React Native Implementation:**
```typescript
export const QuitDateBanner = () => {
  const successDate = format(addDays(new Date(), 60), 'MMM d, yyyy');
  
  return (
    <View style={styles.bannerContainer}>
      <Text style={styles.label}>You will quit porn by:</Text>
      <View style={styles.dateCapsule}>
        <Text style={styles.dateText}>{successDate}</Text>
      </View>
    </View>
  );
};
```

---

### Screen 27: Free Trial Offer

**Overview:** Final de-risking phase removing financial risk through Zero-Price Effect.

**Mockup & Visualization:**
- Device Mockup: High-fidelity iPhone preview (~65% of screen height)
- Internal UI Preview: Post-Onboarding Dashboard
- Focal Points:
  - Sobriety Timer: "14d 4hrs 23mins" (high-contrast)
  - Action Grid: Four circular buttons (Pledge, Meditate, Reset, More)
  - Analytics: Miniature "Weekly Activity" bar chart

**The $0.00 Strategy:**
- CTA Button: "Try For $0.00"
  - Styling: Solid White background (`#FFFFFF`), Deep Navy text (`#081630`)
  - Typography: "Try For" - 18px Extra-Bold, "$0.00" - 22px Black (900 weight)
  - Psychology: "$0.00" larger than "Try For" anchors on "Free" aspect

**Safety Signal:**
- Element: Large Green Checkmark (`#10B981`) + "No Payment Due Now" text
- Placement: Directly above CTA button
- Agreement Logic: Pre-checked or static "Verified" symbol (not interactive)

**Dismissal (Escape Hatch):**
- Element: Small "X" in top-right corner
- Visibility: Low-contrast `rgba(255,255,255,0.2)` on Dark Navy
- Purpose: App Store compliance, visually suppressed to minimize bounce

**Footer Note:**
- Text: "Cancel anytime in Settings"
- Styling: Muted gray, below CTA

**React Native Implementation:**
```typescript
export const TrialCTA = ({ onPress }) => (
  <View style={styles.container}>
    <View style={styles.safetyRow}>
      <Ionicons name="checkmark-circle" size={24} color="#10B981" />
      <Text style={styles.safetyText}>No Payment Due Now</Text>
    </View>
    
    <TouchableOpacity style={styles.button} onPress={onPress}>
      <Text style={styles.buttonText}>
        Try For <Text style={styles.priceHighlight}>$0.00</Text>
      </Text>
    </TouchableOpacity>
    
    <Text style={styles.footerNote}>Cancel anytime in Settings</Text>
  </View>
);
```

---

## Color Palette

### Primary Colors
- Deep Navy: `#081630`
- Deep Teal: `#125E75`
- Midnight Black: `#040712`
- White: `#FFFFFF`
- Muted Gray: `#9CA3AF`

### Accent Colors
- Action Green: `#10B981`
- Emerald Green: `#4ADE80`
- Vivid Crimson: `#F13644`
- Bright Teal: `#2DD4BF`
- Gold: `#FFD700` / `#FACC15`
- Deep Red: `#E11D48`

### Category Colors (Goal Badges)
- Relationships: `#F43F5E` (Red)
- Confidence: `#3B82F6` (Blue)
- Energy: `#F59E0B` (Orange)
- Focus: `#8B5CF6` (Purple)
- Self-Control: `#10B981` (Green)

---

## Animation Specifications

### Transition Timings
- Quiz Q → Q+1: 250ms horizontal slide (right to left), ease-in-out
- Calculating Circle: 3000ms circular progress + pulse, linear
- Score Reveal: 800ms vertical bar grow, ease-out-back
- Symptom Selection: 150ms scale-up + border color change, ease-out
- Signature Clear: 200ms instant opacity fade, linear
- CTA Pulse: Scale 1.0 to 1.03 every 2000ms (infinite loop)
- Background Continuity: 500ms fade transition

### Easing Functions
- Standard: `cubic-bezier(0.4, 0, 0.2, 1)`
- Entrance: `ease-out-quad`
- Exit: `ease-in-out-cubic`

---

## Critical Implementation Notes

### Date Calculation
- **MUST** be client-side (always "Today + 60 days")
- Use `date-fns` (React) or `Calendar` (Swift)
- Format: "MMM d, yyyy" (e.g., "Mar 14, 2026")

### Goal Mapping
- Map `selectedGoals` array to badge components
- Use same icons/categories for consistency
- Flex-wrap layout (responsive)

### Privacy Sub-label
- **DO NOT OMIT** "Purchase appears Discretely"
- Critical "Safety Signal" for shame-based friction
- Placement: Immediately below CTA

### Zero-Price Typography
- "$0.00" must be larger than "Try For" (22px vs 18px)
- Creates visual anchor on "Free" aspect
- Reduces cognitive load

### Device Mockup
- Show actual app interface (not marketing mockup)
- Reduces pre-purchase anxiety
- Focal points: Sobriety Timer, Action Grid, Analytics

### Auto-Advance Pattern
- Selected state: 350ms visual confirmation
- Transition: Quick crossfade (300ms)
- No skip functionality (ensures data quality)

---

## Psychological Principles

### Endowment Effect
- "Custom Plan" framing makes purchase feel like logical final step
- Plan Preview Card creates ownership before paywall

### Zero-Price Effect
- $0.00 increases perceived value disproportionately
- Removes final financial friction

### Labor Illusion
- Processing screen increases perceived value of results
- Variable velocity (stutter-stepping) simulates "heavy lifting"

### Social Comparison
- 52% vs 13% creates shame/urgency
- Cannot un-see negative comparison

### Commitment & Consistency
- Signature screen = highest form of commitment
- Drawing > tapping for psychological weight

### Strategic Friction
- Signature screen's friction is intentional
- High-friction task = high commitment

---

## Implementation Priority

### Build Now (MVP)
1. Splash/Intro screen
2. Welcome/Intent screen
3. Quiz component (reusable, auto-advance)
4. User Profile Input
5. Labor Illusion Processing
6. Results Dashboard (staggered bar animation)
7. Symptom Checklist
8. Goal Selection
9. Commitment Signature
10. Personalized Welcome
11. Plan Preview Card
12. Personalized Plan/Paywall
13. Free Trial Offer

### Defer (Post-MVP)
- Problem-Agitation Carousel (can use static slides)
- Feature Value Propositions (can combine with testimonials)
- Recovery Timeline Graph (can use simpler chart)
- Social Proof Grid (can use simpler list)

---

## Expected Conversion Metrics

**Baseline:** 10-15% conversion

**With Full Implementation:**
- Personalized Plan/Paywall: +20-30% lift
- Free Trial Offer: +15-25% lift
- **Total: 30-50% conversion rate**

**Key Drivers:**
1. Endowment Effect (Custom Plan framing)
2. Zero-Price Effect ($0.00 removes friction)
3. Safety Signals (Privacy sub-label, "No Payment Due Now")
4. Visualization (Device mockup shows actual product)

---

## Feature Implementation Guide (For Looksmaxxing App)

### Pre-Quiz Investment Screens (7-8 Screens)
**Purpose:** Build passive investment and problem awareness before quiz commitment.

**Screens to Add:**
1. Authority/Science: "Rewire your facial structure through targeted exercises"
2. Social Proof: "Join 12,000+ users optimizing their facial aesthetics"
3. Hope/Transformation: "Your transformation journey starts here"
4. Problem Identification: "Do you avoid photos because of your jawline?"
5. Problem Amplification: "70% of people have facial asymmetry"
6. Scientific Explanation: "Facial structure responds to daily habits"
7. Quiz Entry: "Welcome! Let's find out if you're maximizing your facial aesthetics"

**Implementation:** Create `PreQuizOnboardingView.swift` with `TabView`, horizontal slide transitions (250ms), skip button on each screen.

### Symptoms Selection Screen
**Purpose:** Problem multiplication and commitment escalation.

**Categories (Adapted for Looksmaxxing):**
- Confidence/Behavioral: "I avoid photos because of my jawline", "I feel self-conscious about my side profile"
- Physical/Appearance: "Receded chin or weak jawline", "Mouth breathing habits", "Poor posture awareness"
- Functional: "Difficulty breathing through nose", "Jaw tension or TMJ issues"

**UI Pattern:** Multi-select checkboxes, category headers, selected items with blue border + checkmark + scale animation (150ms).

**Data Storage:** `@AppStorage("selectedSymptoms") private var selectedSymptoms: [String] = []`

### Goals Selection Screen
**Purpose:** Future-state commitment and aspiration building.

**Goal Options (6-8):**
1. "🔥 Sharper, more defined jawline"
2. "✨ Better skin texture and glow"
3. "⚖️ Improved facial symmetry"
4. "💪 Increased confidence in photos"
5. "👃 Fix mouth breathing habits"
6. "🧍 Better posture and presence"
7. "💎 Overall aesthetic transformation"

**UI Pattern:** Multi-select (1-3 selections), card-based layout, selected cards with blue border + glow effect.

**Data Storage:** `@AppStorage("selectedGoals") private var selectedGoals: [String] = []`

### Enhanced Labor Illusion
**Enhancement:** Add rotating text labels to `AnalyzingView`:
- Cycle through 4 labels every 800ms:
  1. "Analyzing facial architecture..."
  2. "Comparing to 50,000+ data points..."
  3. "Synthesizing your transformation plan..."
  4. "Calculating potential improvements..."

### Social Comparison Bar Chart (Safe Implementation)
**Visual:** Two vertical bars: "Your Potential" vs "Average User"
- Your bar: Animate from 0 to 82% over 1.5s with `ease-out-back`
- Average bar: Static at 65%
- Label: "Indicative Assessment" (not "Medical Diagnosis")
- Disclaimer: "Based on general population data"

**MVP:** Fixed numbers (82% vs 65%) with disclaimer
**V2:** Replace with real user average once you have 1000+ scores

### Free Trial Messaging Enhancement
**Add to Paywall:**
- Headline: "Try For $0.00"
- Subtext: "Start your 7-day free trial. Cancel anytime."
- Visual: "$0.00" in large, bold text (22px vs 18px for "Try For")
- Embedded App Preview: Show mockup of streak counter, scan interface, results screen

---

## Master Developer Prompt (Improved)

> **Context:** I am building a high-conversion onboarding flow for a looksmaxxing app, reverse-engineered from Quittr's 27-screen flow. This is a complete technical specification with exact implementation details.
> 
> **Your Task:** Implement the onboarding flow with pixel-perfect accuracy to the specifications below. Every color code, animation timing, and interaction pattern is specified for maximum conversion.
> 
> **Critical Requirements:**
> 
> **1. Complete Screen Flow (27 Screens):**
> - Build all screens in exact sequence: Splash → Welcome → Quiz (Q1-Q10) → Profile Input → Processing → Results → Symptoms → Goals → Signature → Welcome → Plan Card → Paywall → Free Trial
> - Use exact timestamps and transitions specified in Screen Inventory table
> - Maintain background continuity (navy-to-teal gradient with star field particles)
> 
> **2. Reusable Quiz Component (Auto-Advance Pattern):**
> - Header: "QUESTION #X" (Uppercase, Semibold, underline)
> - Question Text: 24px bold sans-serif, 20px below header
> - Options: Vertical stack, 12px spacing, pill-shaped (50px border-radius)
> - Default State: Background `#0B1222`, border `1px solid #1E293B`
> - Selected State: Background `#10B981` at 10% opacity, border `2px solid #10B981`, index circle → green checkmark
> - **Auto-Advance Logic:** Selected state renders for 350ms, then crossfade transition (300ms)
> - Exit: Fade out + scale down (0.98), Entrance: Fade in + scale up (0.98 to 1.0)
> - Easing: `cubic-bezier(0.4, 0, 0.2, 1)`
> - **NO SKIP FUNCTIONALITY** (ensures data quality)
> 
> **3. Labor Illusion Processing Screen:**
> - Circular progress bar: 4px stroke, track `rgba(255, 255, 255, 0.1)`, fill `#4ADE80`
> - **Variable Velocity (Stutter-Stepping):**
>   - 0-25%: Rapid acceleration (~0.8s, increment `Math.random() * 5`)
>   - 25-64%: Drastic slowdown (~2.5s, increment `Math.random() * 1.5`) - "heavy lifting" simulation
>   - 64-100%: Final burst (~1.2s, increment `Math.random() * 8`)
> - Status Text Sequence: "Analyzing patterns..." (5%), "Processing data..." (70%)
> - Total Duration: 5.5-6.5 seconds
> - Glow effect: Drop-shadow for light-emitting appearance
> 
> **4. Results Dashboard (Staggered Bar Animation):**
> - Chart Type: Comparative Vertical Bar Chart
> - Bar Width: 80px each, Corner Radius: 10px (top only), Spacing: 40px gutter
> - User Bar: `#F13644` (Vivid Crimson), Average Bar: `#2DD4BF` (Bright Teal)
> - **Animation Sequence:**
>   1. Average bar: 0 → 13% over 600ms (`ease-out`)
>   2. 200ms delay
>   3. User bar: 0 → 52% over 1200ms (`ease-out`)
> - Typography: Percentages 32px Bold White, Sub-labels 14px Medium Muted White
> 
> **5. Symptom Checklist Screen:**
> - Structure: Single-column scrollable list, categories (Mental, Physical, Social, Faith)
> - Category Headers: Uppercase, `#9CA3AF`, 24px top-margin
> - Symptom Row: 56px height, 10px gutter, pill-shaped outline
> - Default: Circular outline (24px), 16px Medium white text
> - Selected: Circle fills with `#E11D48`, white checkmark centered
> - Lazy Loading: FlashList or FlatList for 60fps
> - Sticky "Continue" CTA with gradient fade/blur
> 
> **6. Goal Selection Screen:**
> - Layout: Single-column vertical list, 64px row height, 12px gutter
> - Background: `rgba(255, 255, 255, 0.05)`, Border: `1px solid rgba(255, 255, 255, 0.15)`
> - Border Radius: 50px (Full Capsule)
> - Iconography: Glossy 3D-effect emojis/glyphs, high-contrast saturated colors
> - Selection Feedback: Right-hand circle fills with category color, white checkmark, border opacity → 0.8, haptic pulse
> - Staggered Entrance: `FadeInUp.delay(index * 100).duration(500)`
> 
> **7. Commitment Signature Screen:**
> - Canvas: Large centered rectangle, 16:9 aspect ratio, solid white background `#FFFFFF`
> - Ink: Vector Path (SVG-based), solid black `#000000`, 4px fixed width
> - Smoothing: High (Quadratic Bezier curve smoothing)
> - "Clear" Button: Text-only, 12px below bottom-left corner, white text 14px medium
> - Header: "Sign your commitment" (26px Bold)
> - Subtitle: "Finally, promise yourself that you will never watch porn again."
> - **Validation:** Minimum path length 50 units, auto-advance on valid stroke
> - Haptic: Continuous light haptic during draw
> - Exit: 300ms fade-out after valid stroke
> 
> **8. Plan Preview Card (Virtual ID Card):**
> - Dimensions: 1.586:1 aspect ratio (Standard ID-1), 340x210px
> - Background: Animated Mesh Gradient (Crimson `#F43F5E`, Deep Orange `#FB923C`, Indigo `#4F46E5`)
> - Overlay: 5% opacity noise/grain texture
> - Border Radius: 24px
> - Shadow: `0px 20px 50px rgba(0,0,0,0.4)` (multi-layered)
> - Gloss Effect: Diagonal linear-gradient light sweep (white 20% opacity)
> - Top-Left: "QTR" Brand Mark (white circular border)
> - Top-Right: Profile/Account Icon
> - Primary Metric: "Active Streak: 0 days" (label: small uppercase muted white, value: large bold white)
> - Personal Data: Name (from User Profile), "Free since: [MM/DD]" (dynamic date)
> - **Entrance Animation:** SlideUp + Spring damping (damping: 0.7, stiffness: 120), overshoot bounce
> - **Idle Animation:** Glint effect every 2.5s, slow Y-axis oscillation (±5px over 4000ms)
> 
> **9. Personalized Plan / Paywall:**
> - **Quit Date Banner (CRITICAL):**
>   - Copy: "You will quit porn by: [Date]"
>   - Date Logic: **Client-side calculation** (Today + 60 days), format "MMM d, yyyy"
>   - Container: Solid White capsule `#FFFFFF`
>   - Typography: Bold Sans-serif, Deep Navy `#081630`, 20px
>   - Visual Weight: Highest on page
> - **Benefit Badges:**
>   - Display goals from Goal Selection screen
>   - Architecture: Flex-wrap tag cloud of rounded pills
>   - Background: Muted Navy with thin colored border matching goal category
>   - Icons: Miniature versions from Goal Selection
> - **CTA Button:**
>   - Text: "Become a QUITTR"
>   - Background: High-contrast solid White `#FFFFFF`
>   - Typography: Extra-Bold Navy `#081630`, 20px
>   - **Pulse Animation:** Scale 1.0 to 1.03 every 2000ms (infinite loop)
> - **Privacy Sub-label (CRITICAL - DO NOT OMIT):**
>   - Text: "Purchase appears Discretely"
>   - Placement: Immediately below CTA in Muted Gray `#9CA3AF`
>   - Purpose: Critical "Safety Signal" for shame-based friction
> - **Visual Hierarchy:** Personalized Header → Quit Date Banner → Star Ratings → Benefit Badges
> - **Scroll Strategy:** Long-form sales letter with re-stated value props
> - **Background Continuity:** Plan Preview Card dissolves into this layout (500ms fade)
> 
> **10. Free Trial Offer:**
> - **Device Mockup:**
>   - High-fidelity iPhone preview (~65% of screen height)
>   - Internal UI Preview: Post-Onboarding Dashboard
>   - Focal Points: Sobriety Timer ("14d 4hrs 23mins"), Action Grid (4 circular buttons), Analytics (bar chart)
> - **CTA Button:**
>   - Text: "Try For $0.00"
>   - Background: Solid White `#FFFFFF`, Deep Navy text `#081630`
>   - **Typography:** "Try For" - 18px Extra-Bold, "$0.00" - 22px Black (900 weight)
>   - **CRITICAL:** "$0.00" must be larger than "Try For" (visual anchor on "Free")
> - **Safety Signal:**
>   - Element: Large Green Checkmark `#10B981` + "No Payment Due Now" text
>   - Placement: Directly above CTA button
>   - Agreement Logic: Pre-checked or static "Verified" symbol (not interactive)
> - **Dismissal Button (Escape Hatch):**
>   - Element: Small "X" in top-right corner
>   - Visibility: Low-contrast `rgba(255,255,255,0.2)` on Dark Navy
>   - Purpose: App Store compliance, visually suppressed to minimize bounce
> - **Footer Note:** "Cancel anytime in Settings" (muted gray, below CTA)
> 
> **11. Color Palette (Exact Hex Codes):**
> - Primary: Deep Navy `#081630`, Deep Teal `#125E75`, Midnight Black `#040712`, White `#FFFFFF`, Muted Gray `#9CA3AF`
> - Accent: Action Green `#10B981`, Emerald Green `#4ADE80`, Vivid Crimson `#F13644`, Bright Teal `#2DD4BF`, Gold `#FFD700`/`#FACC15`, Deep Red `#E11D48`
> - Category Colors: Relationships `#F43F5E`, Confidence `#3B82F6`, Energy `#F59E0B`, Focus `#8B5CF6`, Self-Control `#10B981`
> 
> **12. Animation Specifications:**
> - Quiz Q → Q+1: 250ms horizontal slide (right to left), `ease-in-out`
> - Processing: Variable velocity (stutter-stepping), 5.5-6.5s total
> - Score Reveal: Staggered bar growth (Average 600ms, User 1200ms with 200ms delay), `ease-out`
> - Symptom Selection: 150ms scale-up + border color change, `ease-out`
> - Goal Selection: Staggered entrance `FadeInUp.delay(index * 100).duration(500)`
> - Signature Clear: 200ms instant opacity fade, `linear`
> - CTA Pulse: Scale 1.0 to 1.03 every 2000ms (infinite loop)
> - Background Continuity: 500ms fade transition
> - Easing Functions: Standard `cubic-bezier(0.4, 0, 0.2, 1)`, Entrance `ease-out-quad`, Exit `ease-in-out-cubic`
> 
> **13. Data Collection & Storage:**
> - User Profile: Name, Age (from Profile Input screen)
> - Quiz Answers: Store all 10 question responses
> - Selected Symptoms: `@AppStorage("selectedSymptoms") private var selectedSymptoms: [String] = []`
> - Selected Goals: `@AppStorage("selectedGoals") private var selectedGoals: [String] = []`
> - Commitment Signature: `@AppStorage("commitmentSignature") private var signatureData: Data?`
> - All data must persist for personalization in paywall and retention triggers
> 
> **14. Implementation Priority:**
> - **MVP (Build First):** Screens 1-13, 15-16, 21, 23-27 (core conversion flow)
> - **Post-MVP:** Screens 17-20, 22 (social proof and education carousels)
> 
> **15. Critical "Do NOT" List:**
> - DO NOT omit "Purchase appears Discretely" privacy sub-label
> - DO NOT make date calculation server-side (must be client-side: Today + 60 days)
> - DO NOT make "$0.00" same size as "Try For" (must be 22px vs 18px)
> - DO NOT add skip functionality to quiz (ensures data quality)
> - DO NOT use medical/clinical language ("diagnosis" → use "assessment" or "indicative")
> - DO NOT present fixed comparison numbers as dynamic analysis without disclaimer
> 
> **16. Testing Checklist:**
> - [ ] All 27 screens render correctly in sequence
> - [ ] Quiz auto-advance works (350ms delay, crossfade transition)
> - [ ] Processing screen uses variable velocity (stutter-stepping)
> - [ ] Results chart animates with staggered bar growth
> - [ ] Date calculation is client-side (Today + 60 days)
> - [ ] "$0.00" is larger than "Try For" (22px vs 18px)
> - [ ] Privacy sub-label "Purchase appears Discretely" is present
> - [ ] Signature validation works (minimum 50-unit path)
> - [ ] All color codes match exact hex values
> - [ ] All animation timings match specifications
> 
> **Expected Conversion Impact:**
> - Baseline: 10-15% conversion
> - With Full Implementation: 30-50% conversion rate
> - Key Drivers: Endowment Effect, Zero-Price Effect, Safety Signals, Visualization
> 
> **Start Implementation:** Build screens 1-13, 15-16, 21, 23-27 for MVP. Use exact specifications above. Test each screen individually before integrating into full flow."
