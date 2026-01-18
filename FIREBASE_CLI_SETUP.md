# Firebase CLI Setup for Remote Config

**Quick setup:** Install Firebase CLI and upload all 14 parameters at once via command line.

---

## Step 1: Install Firebase CLI

### Option A: If you have Node.js/npm installed

```powershell
npm install -g firebase-tools
```

### Option B: If you don't have Node.js

1. Download Node.js from: https://nodejs.org/ (LTS version)
2. Install it
3. Then run:
   ```powershell
   npm install -g firebase-tools
   ```

---

## Step 2: Login to Firebase

```powershell
firebase login
```

This opens a browser. Sign in with your Google account (same one used for Firebase Console).

---

## Step 3: Upload Remote Config (All 14 Parameters at Once)

### Windows (PowerShell)

```powershell
.\scripts\setup-firebase-remote-config.ps1
```

### Or manually:

```powershell
# If you have .firebaserc file:
firebase remoteconfig:set firebase-remote-config-template.json

# Or specify project ID manually:
firebase remoteconfig:set firebase-remote-config-template.json --project="your-project-id"
```

**To find your project ID:**
- Open `LooksmaxxingApp/GoogleService-Info.plist`
- Look for `<key>PROJECT_ID</key>` → the value is your project ID

---

## Step 4: Publish Configuration

```powershell
firebase remoteconfig:publish --project="your-project-id"
```

Or publish from Firebase Console (click "Publish changes" button).

---

## What Gets Uploaded

All 14 parameters from the guide:
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

**All with default values matching your code!**

---

## Troubleshooting

### "firebase: command not found"
- Make sure `npm install -g firebase-tools` completed successfully
- Close and reopen PowerShell
- Or use: `npx firebase-tools` instead of `firebase`

### "Permission denied" on login
- Run PowerShell as Administrator
- Or allow the login browser popup

### "Project not found"
- Make sure you're using the correct project ID
- Check `GoogleService-Info.plist` for the PROJECT_ID value
- Or list your projects: `firebase projects:list`

---

## Files Created

- `firebase-remote-config-template.json` - Template with all 14 parameters
- `scripts/setup-firebase-remote-config.ps1` - Automated setup script (Windows)
- `scripts/setup-firebase-remote-config.sh` - Automated setup script (Mac/Linux)

---

## Quick One-Liner (After Installing Firebase CLI)

```powershell
firebase login ; firebase remoteconfig:set firebase-remote-config-template.json --project="$(Get-Content LooksmaxxingApp\GoogleService-Info.plist | Select-String -Pattern 'PROJECT_ID' -Context 0,1 | ForEach-Object { ($_ -split '>')[1] -split '<' | Select-Object -First 1 })" ; firebase remoteconfig:publish --project="same-project-id"
```

(Or just run the PowerShell script - it's easier!)
