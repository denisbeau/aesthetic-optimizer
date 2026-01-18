# Upload Remote Config - Quick Instructions

## Option 1: Automated Upload (Recommended)

### Step 1: Get Firebase CI Token (One-time)

Run this in your PowerShell terminal:

```powershell
npx firebase-tools login:ci
```

This will output a token like: `1//0abc123...`

**Copy this token** - you'll use it in step 2.

### Step 2: Upload Parameters

Run the upload script with your token:

```powershell
.\scripts\upload-remote-config.ps1 -AccessToken "YOUR_TOKEN_HERE"
```

**Example:**
```powershell
.\scripts\upload-remote-config.ps1 -AccessToken "1//0abc123xyz..."
```

That's it! All 14 parameters will be uploaded automatically.

---

## Option 2: Manual Upload (Via Firebase Console)

If you prefer, you can add parameters manually in Firebase Console:

1. Go to https://console.firebase.google.com
2. Select your project
3. Click "Remote Config"
4. Add each parameter from `FIREBASE_REMOTE_CONFIG_SETUP.md`
5. Click "Publish changes"

---

## What Gets Uploaded

All 14 parameters from `firebase-remote-config-template.json`:

- `onboarding_messaging_variant`
- `results_headline`
- `results_subheadline`
- `results_gap_callout`
- `results_cta`
- `paywall_headline`
- `paywall_subheadline`
- `paywall_cta_text`
- `paywall_free_trial_text`
- `monthly_price`
- `show_annual_plan`
- `show_signature_screen`
- `show_symptom_checklist`

---

## Troubleshooting

### "Token expired" error
Get a new token: `npx firebase-tools login:ci`

### "Template file not found"
Make sure you're running the script from the project root directory.

### Script won't run
Make sure you're in PowerShell (not Command Prompt), and the script path is correct.
