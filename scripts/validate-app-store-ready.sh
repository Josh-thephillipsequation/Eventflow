#!/bin/bash
# App Store Readiness Validation Script
# Validates that EventFlow is ready for App Store submission

set -e

echo "✅ EventFlow App Store Readiness Check"
echo "======================================"

ERRORS=0
WARNINGS=0

# Check bundle identifier
echo "🔍 Checking Bundle Identifier..."
if grep -q "com.thephillipsequation.eventflow" ios/Runner/Info.plist; then
    echo "✅ Bundle ID correctly set to com.thephillipsequation.eventflow"
else
    echo "❌ Bundle ID not updated"
    ERRORS=$((ERRORS + 1))
fi

# Check app name
echo "🔍 Checking App Display Name..."
if grep -q "<string>EventFlow</string>" ios/Runner/Info.plist; then
    echo "✅ App name correctly set to EventFlow"
else
    echo "❌ App name not updated to EventFlow"
    ERRORS=$((ERRORS + 1))
fi

# Check version number
echo "🔍 Checking Version Number..."
VERSION=$(grep "version:" pubspec.yaml | cut -d' ' -f2)
if [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+\+[0-9]+$ ]]; then
    echo "✅ Version format correct: $VERSION"
else
    echo "❌ Version format incorrect: $VERSION"
    ERRORS=$((ERRORS + 1))
fi

# Check for required files
echo "🔍 Checking Required Files..."
REQUIRED_FILES=(
    "agent_assets/privacy-policy.md"
    "agent_assets/terms-of-service.md" 
    "agent_assets/app-store-metadata.json"
    "lib/theme/app_theme.dart"
    "assets/icons/eventflow_v3_minimal.svg"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
        ERRORS=$((ERRORS + 1))
    fi
done

# Check app icons
echo "🔍 Checking App Icons..."
IOS_ICON_SIZES=(
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png"
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png"
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png"
)

for icon in "${IOS_ICON_SIZES[@]}"; do
    if [[ -f "$icon" ]]; then
        echo "✅ Icon exists: $(basename $icon)"
    else
        echo "⚠️  Icon missing: $(basename $icon)"
        WARNINGS=$((WARNINGS + 1))
    fi
done

# Check launch images
echo "🔍 Checking Launch Images..."
LAUNCH_IMAGES=(
    "ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png"
    "ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png" 
    "ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png"
)

for launch_img in "${LAUNCH_IMAGES[@]}"; do
    if [[ -f "$launch_img" ]]; then
        echo "✅ Launch image exists: $(basename $launch_img)"
    else
        echo "❌ Launch image missing: $(basename $launch_img)"
        ERRORS=$((ERRORS + 1))
    fi
done

# Check permissions in Info.plist
echo "🔍 Checking Permissions..."
if grep -q "NSAppTransportSecurity" ios/Runner/Info.plist; then
    echo "✅ App Transport Security configured"
else
    echo "⚠️  App Transport Security not explicitly configured"
    WARNINGS=$((WARNINGS + 1))
fi

# Code quality checks
echo "🔍 Running Code Quality Checks..."
if flutter analyze --no-fatal-warnings > /dev/null 2>&1; then
    echo "✅ Code analysis passed"
else
    echo "⚠️  Code analysis has warnings"
    WARNINGS=$((WARNINGS + 1))
fi

# Build test
echo "🔍 Testing Release Build..."
if flutter build ios --release --no-codesign > /dev/null 2>&1; then
    echo "✅ Release build successful"
else
    echo "❌ Release build failed"
    ERRORS=$((ERRORS + 1))
fi

# Summary
echo ""
echo "📊 VALIDATION SUMMARY"
echo "===================="
echo "Errors: $ERRORS"
echo "Warnings: $WARNINGS"
echo ""

if [[ $ERRORS -eq 0 ]]; then
    echo "🎉 EventFlow is ready for App Store submission!"
    echo ""
    echo "📋 Next Steps:"
    echo "1. Set up Apple Developer account and certificates"
    echo "2. Create app listing in App Store Connect"
    echo "3. Upload screenshots and metadata"
    echo "4. Archive and upload build"
    echo "5. Submit for review"
    exit 0
else
    echo "❌ Please fix $ERRORS error(s) before submission"
    exit 1
fi
