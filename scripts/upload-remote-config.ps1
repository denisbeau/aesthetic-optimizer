# Upload Firebase Remote Config via REST API
# Usage: .\scripts\upload-remote-config.ps1 -AccessToken "YOUR_TOKEN"

param(
    [Parameter(Mandatory=$true)]
    [string]$AccessToken,
    [string]$ProjectId = "ascend-ce6e2"
)

Write-Host "Uploading Firebase Remote Config..." -ForegroundColor Cyan
Write-Host ""

# Load template
$templatePath = "firebase-remote-config-template.json"
if (-not (Test-Path $templatePath)) {
    Write-Host "ERROR: Template file not found" -ForegroundColor Red
    exit 1
}

$jsonBody = Get-Content $templatePath -Raw
$url = "https://firebaseremoteconfig.googleapis.com/v1/projects/$ProjectId/remoteConfig"

$headers = @{
    "Authorization" = "Bearer $AccessToken"
    "Content-Type" = "application/json; charset=UTF-8"
}

try {
    # Get ETag from current config
    try {
        $current = Invoke-WebRequest -Uri $url -Method "GET" -Headers $headers -ErrorAction SilentlyContinue
        if ($current.Headers["ETag"]) {
            $headers["If-Match"] = $current.Headers["ETag"]
        }
    } catch {
        # No existing config, continue
    }
    
    # Upload
    $response = Invoke-RestMethod -Uri $url -Method "PUT" -Headers $headers -Body $jsonBody -ErrorAction Stop
    
    Write-Host "SUCCESS! All 14 parameters uploaded!" -ForegroundColor Green
    Write-Host ""
    $template = $jsonBody | ConvertFrom-Json
    $template.parameters.PSObject.Properties.Name | ForEach-Object {
        Write-Host "  - $_" -ForegroundColor Green
    }
    Write-Host ""
    
} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response.StatusCode.value__ -eq 401) {
        Write-Host "Token expired. Get a new one with: npx firebase-tools login:ci" -ForegroundColor Yellow
    }
    exit 1
}
