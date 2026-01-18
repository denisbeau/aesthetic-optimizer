# PowerShell script to setup Firebase Remote Config via REST API (no Firebase CLI needed)
# This uploads all 14 parameters directly to Firebase

param(
    [string]$ProjectId = "",
    [string]$AccessToken = ""
)

Write-Host "🔥 Firebase Remote Config Setup (Direct API)" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Get project ID
if ([string]::IsNullOrWhiteSpace($ProjectId)) {
    $plistPath = "LooksmaxxingApp\GoogleService-Info.plist"
    if (Test-Path $plistPath) {
        $plistContent = Get-Content $plistPath -Raw
        if ($plistContent -match '<key>PROJECT_ID</key>\s*<string>([^<]+)</string>') {
            $ProjectId = $matches[1]
            Write-Host "✅ Found Project ID from plist: $ProjectId" -ForegroundColor Green
        }
    }
    
    if ([string]::IsNullOrWhiteSpace($ProjectId)) {
        $ProjectId = Read-Host "Enter your Firebase project ID"
        if ([string]::IsNullOrWhiteSpace($ProjectId)) {
            Write-Host "❌ Project ID is required" -ForegroundColor Red
            exit 1
        }
    }
}

Write-Host ""

# Get access token (if not provided)
if ([string]::IsNullOrWhiteSpace($AccessToken)) {
    Write-Host "🔐 You need a Firebase access token." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Get it from: https://console.firebase.google.com/project/$ProjectId/settings/serviceaccounts/adminsdk" -ForegroundColor Cyan
    Write-Host "Or install Firebase CLI and run: firebase login:ci" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Alternative: Use Firebase CLI method (see FIREBASE_CLI_SETUP.md)" -ForegroundColor Yellow
    Write-Host ""
    $AccessToken = Read-Host "Enter Firebase access token (or press Enter to use Firebase CLI method)"
    
    if ([string]::IsNullOrWhiteSpace($AccessToken)) {
        Write-Host ""
        Write-Host "💡 To use Firebase CLI instead, run:" -ForegroundColor Cyan
        Write-Host "   npm install -g firebase-tools" -ForegroundColor White
        Write-Host "   firebase login" -ForegroundColor White
        Write-Host "   .\scripts\setup-firebase-remote-config.ps1" -ForegroundColor White
        Write-Host ""
        exit 0
    }
}

# Load template
$templatePath = "firebase-remote-config-template.json"
if (-not (Test-Path $templatePath)) {
    Write-Host "❌ Template file not found: $templatePath" -ForegroundColor Red
    exit 1
}

$template = Get-Content $templatePath -Raw | ConvertFrom-Json

Write-Host "📤 Uploading Remote Config template..." -ForegroundColor Cyan
Write-Host ""

# Firebase Remote Config REST API endpoint
$url = "https://firebaseremoteconfig.googleapis.com/v1/projects/$ProjectId/remoteConfig"

# Update version timestamp
$template.version.versionNumber = "1"
$template.version.updateTime = [DateTimeOffset]::UtcNow.ToString("yyyy-MM-ddTHH:mm:ss.fffZ")

# Convert back to JSON
$jsonBody = $template | ConvertTo-Json -Depth 10

try {
    $headers = @{
        "Authorization" = "Bearer $AccessToken"
        "Content-Type" = "application/json; UTF8"
    }
    
    $response = Invoke-RestMethod -Uri $url -Method "PUT" -Headers $headers -Body $jsonBody -ErrorAction Stop
    
    Write-Host "✅ Remote Config uploaded successfully!" -ForegroundColor Green
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
    Write-Host "✅ Configuration is LIVE - no need to publish!" -ForegroundColor Green
    Write-Host ""
    
} catch {
    Write-Host "❌ Error uploading Remote Config:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response: $responseBody" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "💡 Tip: Use Firebase CLI method instead (easier):" -ForegroundColor Yellow
    Write-Host "   See FIREBASE_CLI_SETUP.md" -ForegroundColor Cyan
    exit 1
}
