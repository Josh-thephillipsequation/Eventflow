#!/bin/bash
# Build app for TestFlight distribution

echo "Building EventFlow for TestFlight..."

# Clean previous builds
flutter clean
flutter pub get

# Build release iOS app
flutter build ios --release --no-codesign

echo "✅ Build complete!"
echo "Next steps:"
echo "1. Open ios/Runner.xcworkspace in Xcode"
echo "2. Select 'Any iOS Device' as target"
echo "3. Product → Archive"
echo "4. Upload to TestFlight via Xcode Organizer"
echo "5. App will persist for 90 days for testers"
