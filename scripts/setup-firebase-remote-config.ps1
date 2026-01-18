# PowerShell script to setup Firebase Remote Config via CLI
# This script uploads all Remote Config parameters at once

Write-Host "🔥 Firebase Remote Config CLI Setup" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Check if Firebase CLI is installed
$firebaseCmd = Get-Command firebase -ErrorAction SilentlyContinue
if (-not $firebaseCmd) {
    Write-Host "❌ Firebase CLI is not installed." -ForegroundColor Red
    Write-Host ""
    Write-Host "Install it with:" -ForegroundColor Yellow
    Write-Host "  npm install -g firebase-tools" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host "✅ Firebase CLI found: $(firebase --version)" -ForegroundColor Green
Write-Host ""

# Check if user is logged in
$loginCheck = firebase projects:list 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "🔐 Not logged in to Firebase. Logging in..." -ForegroundColor Yellow
    firebase login
    Write-Host ""
}

# Check if .firebaserc exists or ask for project ID
$projectId = $null
if (Test-Path ".firebaserc") {
    Write-Host "✅ Found .firebaserc file" -ForegroundColor Green
    $firebaseConfig = Get-Content ".firebaserc" | ConvertFrom-Json
    $projectId = $firebaseConfig.projects.default
    Write-Host "📦 Project ID: $projectId" -ForegroundColor Cyan
} else {
    Write-Host "⚠️  No .firebaserc found. Checking GoogleService-Info.plist..." -ForegroundColor Yellow
    $plistPath = "LooksmaxxingApp\GoogleService-Info.plist"
    if (Test-Path $plistPath) {
        # Try to extract project ID from plist (basic XML parsing)
        $plistContent = Get-Content $plistPath -Raw
        if ($plistContent -match '<key>PROJECT_ID</key>\s*<string>([^<]+)</string>') {
            $projectId = $matches[1]
            Write-Host "📦 Project ID from plist: $projectId" -ForegroundColor Cyan
        }
    }
    
    if (-not $projectId) {
        $projectId = Read-Host "Enter your Firebase project ID"
        if ([string]::IsNullOrWhiteSpace($projectId)) {
            Write-Host "❌ Project ID is required" -ForegroundColor Red
            exit 1
        }
    }
}

Write-Host ""
Write-Host "📤 Uploading Remote Config template..." -ForegroundColor Cyan
Write-Host ""

# Use firebase CLI to set Remote Config
firebase remoteconfig:set firebase-remote-config-template.json --project="$projectId"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Remote Config parameters uploaded successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Uploaded 14 parameters:" -ForegroundColor Cyan
    Write-Host "  - onboarding_messaging_variant"
    Write-Host "  - results_headline"
    Write-Host "  - results_subheadline"
    Write-Host "  - results_gap_callout"
    Write-Host "  - results_cta"
    Write-Host "  - paywall_headline"
    Write-Host "  - paywall_subheadline"
    Write-Host "  - paywall_cta_text"
    Write-Host "  - paywall_free_trial_text"
    Write-Host "  - monthly_price"
    Write-Host "  - show_annual_plan"
    Write-Host "  - show_signature_screen"
    Write-Host "  - show_symptom_checklist"
    Write-Host ""
    Write-Host "🚀 Next: Publish the configuration in Firebase Console" -ForegroundColor Yellow
    Write-Host "   Or run: firebase remoteconfig:publish --project=`"$projectId`"" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "❌ Failed to upload Remote Config. Check errors above." -ForegroundColor Red
    exit 1
}
