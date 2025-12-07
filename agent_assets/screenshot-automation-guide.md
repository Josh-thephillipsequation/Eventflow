# Automated Screenshot Generation Guide

**Problem:** Manually taking screenshots for multiple device sizes is time-consuming  
**Solution:** Automated screenshot generation using multiple methods

---

## Overview

We've created **three different approaches** to automate screenshots:

1. **Fastlane** (Industry standard, most powerful)
2. **Flutter Integration Tests** (Most reliable, uses actual app navigation)
3. **Shell Scripts** (Simple, flexible, easy to customize)

---

## Method 1: Fastlane (Recommended for Production)

### Setup

1. **Install Fastlane:**
   ```bash
   sudo gem install fastlane
   ```

2. **Initialize Fastlane (if not already done):**
   ```bash
   cd /path/to/eventflow
   fastlane init
   ```

3. **Fastlane is already configured:**
   - `fastlane/Fastfile` - Main configuration
   - `fastlane/scripts/take_screenshots.rb` - Screenshot automation script

### Usage

**Generate screenshots:**
```bash
fastlane ios screenshots
```

**Generate and upload to App Store Connect:**
```bash
fastlane ios screenshots_and_upload
```

**Just upload existing screenshots:**
```bash
fastlane ios upload_screenshots
```

### How It Works

1. Boots each simulator device
2. Builds and launches the app
3. Navigates through screens automatically
4. Takes screenshots at correct resolutions
5. Saves to `fastlane/screenshots/`
6. Optionally uploads to App Store Connect

### Customization

Edit `fastlane/Fastfile` to:
- Add/remove devices
- Change screenshot sequence
- Adjust timing
- Add custom navigation

---

## Method 2: Flutter Integration Tests (Most Reliable)

### Setup

1. **Add integration_test dependency** (if not already):
   ```yaml
   # pubspec.yaml
   dev_dependencies:
     integration_test:
       sdk: flutter
   ```

2. **Integration test is already created:**
   - `test/integration/screenshot_automation_test.dart`

### Usage

**Run screenshot automation:**
```bash
./scripts/screenshot_with_integration_test.sh
```

**Or manually:**
```bash
# For specific device
flutter test integration_test/screenshot_automation_test.dart \
  -d "iPhone 15 Pro Max" \
  --screenshot-dir screenshots/iphone_15_pro_max \
  --release
```

### How It Works

1. Uses Flutter's integration test framework
2. Actually navigates through the app (real taps, real navigation)
3. Takes screenshots at each step
4. Most reliable because it uses actual app behavior

### Advantages

- ✅ Uses real app navigation (not coordinate tapping)
- ✅ Waits for UI to be ready automatically
- ✅ Handles async operations properly
- ✅ Works with any screen changes

---

## Method 3: Shell Scripts (Simple & Flexible)

### Setup

Make scripts executable:
```bash
chmod +x scripts/automate_screenshots.sh
chmod +x scripts/resize_screenshots_for_app_store.sh
```

### Usage

**Generate screenshots:**
```bash
./scripts/automate_screenshots.sh
```

**Resize to App Store requirements:**
```bash
./scripts/resize_screenshots_for_app_store.sh \
  screenshots/automated \
  screenshots/app_store_ready
```

### How It Works

1. Boots simulators
2. Launches app
3. Uses `xcrun simctl` to tap coordinates
4. Takes screenshots
5. Optionally resizes to exact App Store dimensions

### Customization

Edit `scripts/automate_screenshots.sh` to:
- Adjust tap coordinates (use Accessibility Inspector)
- Change wait times
- Add/remove devices
- Modify screenshot sequence

---

## Quick Start (Choose One)

### Option A: Fastlane (Best for CI/CD)
```bash
fastlane ios screenshots
```

### Option B: Integration Tests (Most Reliable)
```bash
./scripts/screenshot_with_integration_test.sh
```

### Option C: Shell Scripts (Simplest)
```bash
./scripts/automate_screenshots.sh
./scripts/resize_screenshots_for_app_store.sh
```

---

## Device Coverage

All methods support:
- ✅ iPhone 15 Pro Max (6.7" - 1290 x 2796)
- ✅ iPhone 15 Pro (6.1" - 1179 x 2556)
- ✅ iPhone 14 Pro Max (6.7" - 1290 x 2796)
- ✅ iPhone 11 Pro Max (6.5" - 1242 x 2688)
- ✅ iPad Pro 12.9" (2048 x 2732)
- ✅ iPad Pro 11" (1668 x 2388)
- ✅ iPad Air 5th gen (1640 x 2360)

---

## Screenshot Sequence

All methods capture:
1. **Import Screen** - Default landing screen
2. **All Events** - Events list with day grouping
3. **My Agenda** - Personal agenda view
4. **Insights** - Analytics with topic cloud
5. **Fun** - Bingo and AI features
6. **Settings** - Settings screen

---

## Troubleshooting

### Simulator Not Booting

**Problem:** Simulator fails to boot

**Solution:**
```bash
# List available simulators
xcrun simctl list devices available

# Boot manually
xcrun simctl boot "iPhone 15 Pro Max"
open -a Simulator
```

### App Not Launching

**Problem:** App doesn't start on simulator

**Solution:**
```bash
# Build first
flutter build ios --simulator --debug

# Then run
flutter run -d "iPhone 15 Pro Max"
```

### Screenshots Wrong Size

**Problem:** Screenshots not exact App Store dimensions

**Solution:**
```bash
# Use resize script
./scripts/resize_screenshots_for_app_store.sh \
  screenshots/automated \
  screenshots/app_store_ready
```

### Navigation Not Working

**Problem:** Scripts tap wrong coordinates

**Solution:**
1. Use Accessibility Inspector to find exact coordinates
2. Update tap coordinates in scripts
3. Or use Integration Test method (more reliable)

---

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Generate Screenshots

on:
  push:
    branches: [main]
    paths:
      - 'lib/**'

jobs:
  screenshots:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - name: Generate Screenshots
        run: fastlane ios screenshots
      - name: Upload Screenshots
        uses: actions/upload-artifact@v3
        with:
          name: screenshots
          path: fastlane/screenshots/
```

---

## Advanced: Custom Screenshot Scenarios

### Add Custom Navigation

Edit the integration test to add custom scenarios:

```dart
// In test/integration/screenshot_automation_test.dart

// Example: Screenshot with events filtered
testWidgets('Screenshot filtered events', (tester) async {
  // Navigate to All Events
  await tester.tap(find.text('All Events'));
  await tester.pumpAndSettle();
  
  // Apply filter
  await tester.tap(find.byIcon(Icons.filter_list));
  await tester.pumpAndSettle();
  
  // Take screenshot
  await tester.binding.takeScreenshot('filtered_events');
});
```

### Screenshot Specific States

```dart
// Screenshot with sample data loaded
await eventProvider.loadCalendarFromAsset('assets/sample_conference.ics');
await tester.pumpAndSettle();
await tester.binding.takeScreenshot('with_data');
```

---

## Best Practices

1. **Always test on actual devices** after generating screenshots
2. **Review screenshots** before uploading to App Store
3. **Keep screenshots in version control** (or artifact storage)
4. **Automate in CI/CD** for consistent results
5. **Update screenshots** when UI changes significantly

---

## Comparison

| Method | Pros | Cons | Best For |
|--------|------|------|----------|
| **Fastlane** | Industry standard, uploads automatically, CI/CD ready | Requires Ruby/gem setup | Production, teams |
| **Integration Tests** | Most reliable, uses real navigation | Requires test setup | Reliability, accuracy |
| **Shell Scripts** | Simple, no dependencies, easy to customize | Coordinate-based (less reliable) | Quick testing, customization |

---

## Next Steps

1. **Choose a method** based on your needs
2. **Test on one device** first
3. **Review screenshots** for quality
4. **Automate in CI/CD** if desired
5. **Update when UI changes**

---

## Resources

- **Fastlane Docs:** https://docs.fastlane.tools/
- **Flutter Integration Tests:** https://docs.flutter.dev/testing/integration-tests
- **App Store Screenshot Requirements:** https://developer.apple.com/app-store/product-page/

---

**Last Updated:** 2025-01-XX  
**Status:** Ready to use  
**Recommended:** Start with Integration Test method for reliability

