#!/bin/bash
# EventFlow App Store Preparation Script
# Automates code preparation for App Store submission

set -e

echo "🚀 EventFlow App Store Preparation"
echo "================================="

# Configuration
BUNDLE_ID="com.thephillipsequation.eventflow"
APP_VERSION="1.0.0"
BUILD_NUMBER=$(date +%Y%m%d%H%M)

echo "📱 App Configuration:"
echo "Bundle ID: $BUNDLE_ID"
echo "Version: $APP_VERSION"
echo "Build: $BUILD_NUMBER"
echo ""

# 1. Update Bundle Identifier
echo "🔧 Updating Bundle Identifier..."
sed -i '' "s/com.example.conferenceAgendaTracker/$BUNDLE_ID/g" ios/Runner/Info.plist
sed -i '' "s/com.example.conference_agenda_tracker/$BUNDLE_ID/g" android/app/build.gradle.kts
echo "✅ Bundle identifier updated"

# 2. Update Version Numbers
echo "🔢 Updating version numbers..."
sed -i '' "s/version: .*/version: $APP_VERSION+$BUILD_NUMBER/" pubspec.yaml
echo "✅ Version numbers updated"

# 3. Update App Display Name
echo "📝 Updating app display names..."
sed -i '' 's/<string>conference_agenda_tracker<\/string>/<string>EventFlow<\/string>/g' ios/Runner/Info.plist
echo "✅ App names updated"

# 4. Clean and get dependencies
echo "🧹 Cleaning and updating dependencies..."
flutter clean
flutter pub get
echo "✅ Dependencies updated"

# 5. Run code analysis
echo "🔍 Running code analysis..."
flutter analyze --fatal-infos
echo "✅ Code analysis passed"

# 6. Run tests
echo "🧪 Running tests..."
flutter test
echo "✅ Tests passed"

# 7. Build iOS release (for validation)
echo "🏗️ Building iOS release for validation..."
flutter build ios --release --no-codesign
echo "✅ iOS build completed"

echo ""
echo "🎉 App Store preparation completed!"
echo ""
echo "📋 Next Steps:"
echo "1. Set up Apple Developer account and certificates"
echo "2. Configure code signing in Xcode"
echo "3. Archive and upload to App Store Connect"
echo "4. Complete App Store Connect metadata"
echo ""
