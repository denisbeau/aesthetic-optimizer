#!/bin/bash
# Verify Firebase Remote Config Setup
# Run this after setting up parameters in Firebase Console

echo "🔍 Firebase Remote Config Verification Script"
echo "=============================================="
echo ""

# Check if GoogleService-Info.plist exists
if [ -f "LooksmaxxingApp/GoogleService-Info.plist" ]; then
    echo "✅ GoogleService-Info.plist found"
else
    echo "⚠️  GoogleService-Info.plist not found (expected if running in CI)"
    echo "   Local builds need this file to use Remote Config"
fi

echo ""
echo "📋 Required Remote Config Parameters:"
echo ""

# List of required parameters
PARAMS=(
    "onboarding_messaging_variant"
    "results_headline"
    "results_subheadline"
    "results_gap_callout"
    "results_cta"
    "paywall_headline"
    "paywall_cta_text"
    "paywall_free_trial_text"
    "monthly_price"
    "show_signature_screen"
    "show_symptom_checklist"
)

for param in "${PARAMS[@]}"; do
    echo "  - $param"
done

echo ""
echo "💡 Next Steps:"
echo "1. Open Firebase Console: https://console.firebase.google.com"
echo "2. Navigate to Remote Config"
echo "3. Add the parameters listed above"
echo "4. Set default values (see FIREBASE_REMOTE_CONFIG_SETUP.md)"
echo "5. Publish changes"
echo ""
echo "📖 Full setup guide: FIREBASE_REMOTE_CONFIG_SETUP.md"
