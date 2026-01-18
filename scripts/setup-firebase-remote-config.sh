#!/bin/bash
# Setup Firebase Remote Config via CLI
# This script uploads all Remote Config parameters at once

set -e

echo "🔥 Firebase Remote Config CLI Setup"
echo "===================================="
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI is not installed."
    echo ""
    echo "Install it with:"
    echo "  npm install -g firebase-tools"
    echo ""
    echo "Or on Windows:"
    echo "  npm install -g firebase-tools"
    echo ""
    exit 1
fi

echo "✅ Firebase CLI found: $(firebase --version)"
echo ""

# Check if user is logged in
if ! firebase projects:list &> /dev/null; then
    echo "🔐 Not logged in to Firebase. Logging in..."
    firebase login
    echo ""
fi

# Check if .firebaserc exists or ask for project ID
if [ -f ".firebaserc" ]; then
    echo "✅ Found .firebaserc file"
    PROJECT_ID=$(grep -o '"default": "[^"]*"' .firebaserc | cut -d'"' -f4)
    echo "📦 Project ID: $PROJECT_ID"
else
    echo "⚠️  No .firebaserc found. You'll need to specify project ID."
    echo ""
    read -p "Enter your Firebase project ID (from GoogleService-Info.plist): " PROJECT_ID
    if [ -z "$PROJECT_ID" ]; then
        echo "❌ Project ID is required"
        exit 1
    fi
fi

echo ""
echo "📤 Uploading Remote Config template..."
echo ""

# Use firebase CLI to set Remote Config
firebase remoteconfig:set firebase-remote-config-template.json --project="$PROJECT_ID"

echo ""
echo "✅ Remote Config parameters uploaded successfully!"
echo ""
echo "📋 Uploaded parameters:"
echo "  - onboarding_messaging_variant"
echo "  - results_headline"
echo "  - results_subheadline"
echo "  - results_gap_callout"
echo "  - results_cta"
echo "  - paywall_headline"
echo "  - paywall_subheadline"
echo "  - paywall_cta_text"
echo "  - paywall_free_trial_text"
echo "  - monthly_price"
echo "  - show_annual_plan"
echo "  - show_signature_screen"
echo "  - show_symptom_checklist"
echo ""
echo "🚀 Next: Publish the configuration in Firebase Console"
echo "   Or run: firebase remoteconfig:publish --project=\"$PROJECT_ID\""
echo ""
