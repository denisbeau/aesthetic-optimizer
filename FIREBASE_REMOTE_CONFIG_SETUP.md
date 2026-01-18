# Firebase Remote Config Setup Guide

**Status:** ✅ Code is ready - Configure values in Firebase Console

This guide shows you how to set up Firebase Remote Config for A/B testing messaging variants without rebuilding the app.

---

## Prerequisites

1. **Firebase Project**: You should already have one (you have `GoogleService-Info.plist`)
2. **Firebase Console Access**: https://console.firebase.google.com
3. **Remote Config Enabled**: Should be enabled by default

---

## Step 1: Navigate to Remote Config

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project (the one matching `GoogleService-Info.plist`)
3. In the left sidebar, click **"Remote Config"** (under "Engage" section)
4. If prompted, click **"Get Started"** or **"Create configuration"**

---

## Step 2: Set Default Values (Required)

Add these parameters with their default values. These match what's in the code fallbacks:

### Messaging Variant (Primary Control)

| Parameter Key | Type | Default Value | Description |
|---------------|------|---------------|-------------|
| `onboarding_messaging_variant` | String | `brutal_honesty` | Controls which messaging set to use |

**Allowed values:**
- `brutal_honesty` (default)
- `optimization_focus`
- `balanced`

### Results Screen Messaging

| Parameter Key | Type | Default Value |
|---------------|------|---------------|
| `results_headline` | String | `You're spiraling harder than most` |
| `results_subheadline` | String | `Your responses indicate significant appearance anxiety*` |
| `results_gap_callout` | String | `% higher concern than average` |
| `results_cta` | String | `Check your symptoms` |

### Paywall Messaging

| Parameter Key | Type | Default Value |
|---------------|------|---------------|
| `paywall_headline` | String | `Stop spiraling. Start optimizing.` |
| `paywall_subheadline` | String | `(optional - currently not used)` |
| `paywall_cta_text` | String | `Become a Member` |
| `paywall_free_trial_text` | String | `Try For $0.00` |

### Pricing

| Parameter Key | Type | Default Value |
|---------------|------|---------------|
| `monthly_price` | Number | `14.99` |
| `show_annual_plan` | Boolean | `false` (optional) |

### Feature Flags

| Parameter Key | Type | Default Value |
|---------------|------|---------------|
| `show_signature_screen` | Boolean | `true` |
| `show_symptom_checklist` | Boolean | `true` |

---

## Step 3: How to Add Parameters

1. Click **"Add parameter"** button
2. Enter the **Parameter key** (exact match from table above)
3. Select the **Data type** (String, Number, or Boolean)
4. Enter the **Default value**
5. Click **"Save"**
6. Repeat for all parameters

**Tip:** You can add multiple parameters at once by clicking "Add parameter" multiple times before saving.

---

## Step 4: Publish Configuration

After adding all parameters:

1. Review your changes
2. Click **"Publish changes"** button (top right)
3. Confirm in the dialog

**Important:** Changes take effect within 1 hour (cache interval) for existing users. New users get updated values immediately.

---

## Step 5: A/B Testing Setup (Optional)

To test different messaging variants:

### Option A: Conditional Values (Recommended)

1. Click on a parameter (e.g., `onboarding_messaging_variant`)
2. Click **"Add value for condition"**
3. Create conditions based on:
   - **User properties** (e.g., `user_type == "new"`)
   - **Random percentile** (e.g., 0-50% get variant A, 50-100% get variant B)
   - **App version** (e.g., specific version ranges)
   - **Device/OS** (e.g., iOS only)

### Option B: Multiple Variants via Variant Parameter

Set `onboarding_messaging_variant` to different values:
- `brutal_honesty` → Uses harsh, direct messaging
- `optimization_focus` → Uses optimization/potential messaging
- `balanced` → Uses neutral, controlled messaging

Then set corresponding values for the other parameters based on the variant.

---

## Step 6: Testing Your Changes

### In the App

1. Build and run the app locally
2. The app fetches Remote Config on launch (cached for 1 hour)
3. To force refresh during testing, change `minimumFetchInterval` temporarily to `0` in `RemoteConfigService.swift` (line 69)

### Verify Values Are Loading

Add this debug code temporarily in your app:

```swift
let service = RemoteConfigService.shared
print("Messaging Variant: \(service.messagingVariant)")
print("Results Headline: \(service.getResultsHeadline())")
print("Paywall Headline: \(service.getPaywallHeadline())")
```

---

## Quick Reference: All Keys

Copy-paste this list when adding parameters:

```
onboarding_messaging_variant
results_headline
results_subheadline
results_gap_callout
results_cta
paywall_headline
paywall_subheadline
paywall_cta_text
paywall_free_trial_text
monthly_price
show_annual_plan
show_signature_screen
show_symptom_checklist
```

---

## Messaging Variants Explained

### `brutal_honesty` (Default)

**Tone:** Direct, confrontational, loss-aversion focused

- Results: "You're spiraling harder than most"
- Paywall: "Stop spiraling. Start optimizing."

### `optimization_focus`

**Tone:** Growth-oriented, potential-focused

- Results: "You have 40% optimization potential"
- Paywall: "Optimize your 40% potential"

### `balanced`

**Tone:** Neutral, factual, control-focused

- Results: "You're operating below your potential"
- Paywall: "Your system for transformation"

---

## Troubleshooting

### App Still Shows Old Messages

- Remote Config caches values for 1 hour
- Wait 1 hour, or reinstall the app
- For testing, temporarily set `minimumFetchInterval = 0`

### Firebase Not Configured Error

- Ensure `GoogleService-Info.plist` is in `LooksmaxxingApp/` folder
- Verify the file is not in `.gitignore` locally (it should be gitignored for CI, but present locally)
- Check that Firebase is initialized in `LooksmaxxingApp.swift`

### Values Not Updating

- Check parameter keys match exactly (case-sensitive)
- Verify you clicked "Publish changes"
- Check Firebase Console for any error messages
- Ensure parameter data types match (String vs Number vs Boolean)

---

## CI/CD Compatibility

✅ **Your CI/CD pipeline already handles this correctly:**

- `GoogleService-Info.plist` is gitignored
- App uses fallback defaults when Firebase isn't configured
- Builds succeed in GitHub Actions without Firebase config
- Local builds use Firebase when the file is present

**No changes needed to CI/CD.**

---

## Next Steps

1. **Set up parameters** in Firebase Console (use defaults from this guide)
2. **Test locally** with your `GoogleService-Info.plist`
3. **Create A/B test variants** based on your target audience
4. **Monitor results** in Firebase Analytics (link to events if needed)

---

## Support

If you need to change the parameter keys or add new ones:

1. Update `ConfigKey` enum in `RemoteConfigService.swift`
2. Update `setDefaults()` dictionary in `loadConfig()`
3. Add getter methods if needed
4. Update this guide

**The code is already set up to handle all of this dynamically.**
