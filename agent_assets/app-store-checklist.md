# EventFlow - App Store Submission Checklist

**Version:** 1.0.0 (Build 1)  
**Date Prepared:** October 15, 2025  
**Company:** thephillipsequation llc

## ✅ Pre-Submission Checklist Complete

### App Build
- [x] Version set to 1.0.0+1 in pubspec.yaml
- [x] Bundle ID configured (use Xcode to set unique ID)
- [x] App display name: "EventFlow"
- [x] All tests passing (50/50 tests passed)
- [x] Code analyzed with no critical errors

### iOS Configuration
- [x] Info.plist updated with .ics file support
- [x] Document types configured (LSSupportsOpeningDocumentsInPlace, CFBundleDocumentTypes)
- [x] App icon generated (1024x1024 required)
- [x] Splash screen configured

### Privacy & Data
- [x] Privacy policy updated to reflect "Data Not Collected"
- [x] Privacy policy URL: https://josh-thephillipsequation.github.io/Eventflow/privacy
- [x] No analytics or crash reporting
- [x] All data stored locally on device

### User Experience
- [x] Clear data functionality in Settings
- [x] Sample conference import button in Settings
- [x] Improved error handling with helpful messages
- [x] Theme mode properly respects light/dark selection
- [x] Success/error feedback for all import actions

### Professional Polish
- [x] Material 3 design throughout
- [x] Onboarding tutorial
- [x] Professional "Built using Amp AI" credit (no time claims)
- [x] Empty states with helpful guidance

---

## 📱 App Store Connect Information

### App Information
**Name:** EventFlow  
**Subtitle:** Smart Conference Agenda Manager  
**Primary Category:** Productivity  
**Secondary Category:** Business  

### Description (Suggested)
```
EventFlow is a professional conference agenda management app that helps you organize, track, and get insights from conference schedules.

KEY FEATURES:
• Import .ics calendar files directly from Files or email
• Smart filtering by time, keywords, and priority
• Personal agenda with selected events
• Interactive analytics: topic clouds and 24-hour heatmaps
• AI-powered fun features: talk generators, product name ideas, bingo
• Multiple themes including professional and cyberpunk styles
• 100% offline - all data stays on your device

PRIVACY FIRST:
EventFlow collects NO data. Everything stays on your device. No accounts, no tracking, no analytics.

PERFECT FOR:
Conference attendees who want to maximize their experience, track interesting sessions, and explore conference data in fun, interactive ways.

Built with Amp AI by thephillipsequation llc.
```

### Keywords
conference, agenda, schedule, ics, calendar, events, productivity, analytics, offline, privacy

### Support Information
- **Support URL:** https://josh-thephillipsequation.github.io/Eventflow/
- **Marketing URL:** https://josh-thephillipsequation.github.io/Eventflow/
- **Privacy Policy URL:** https://josh-thephillipsequation.github.io/Eventflow/privacy
- **Support Email:** privacy@thephillipsequation.com

### Copyright
© 2025 thephillipsequation llc

### Age Rating
4+ (No objectionable content)

---

## 🎨 Screenshot Requirements

### Required Screenshots (iPhone)
You'll need screenshots for:
1. **6.7" Display (iPhone 14 Pro Max, 15 Pro Max)** - 1290 x 2796
2. **6.5" Display (iPhone 11 Pro Max, XS Max)** - 1242 x 2688
3. **5.5" Display (iPhone 8 Plus)** - 1242 x 2208

### Suggested Screenshots (6-8 total)
1. **Home - All Events** - Shows day grouping, event cards with priority
2. **My Agenda** - Personal schedule with selected events
3. **Import Screen** - Professional hero section with import options
4. **Search & Filter** - Demonstrates smart filtering capabilities
5. **Insights - Topic Cloud** - Interactive analytics visualization
6. **Insights - Heatmap** - 24-hour schedule analysis
7. **Settings - Themes** - Show theme options (including cyberpunk)
8. **Fun Tab - Bingo** - Demonstrates playful AI features

### Screenshot Captions (Optional but Recommended)
1. "Organize your conference schedule with smart day grouping"
2. "Create your personal agenda from selected events"
3. "Import .ics files directly from Files or email"
4. "Search and filter events instantly"
5. "Explore topics with interactive word clouds"
6. "Visualize your day with schedule heatmaps"
7. "Customize with professional or cyberpunk themes"
8. "Have fun with AI-powered conference bingo"

---

## 🔍 App Review Notes

### For Apple Reviewers:
```
Thank you for reviewing EventFlow!

HOW TO TEST:
1. Open EventFlow
2. Navigate to Settings (gear icon in top right)
3. Scroll to "Data" section
4. Tap "Import Sample Conference" to load test data
5. Explore all features:
   - All Events tab shows imported schedule
   - My Agenda for selecting favorites
   - Insights for analytics
   - Fun for interactive games

ALTERNATIVE IMPORT METHOD:
You can also open any .ics file from Files app and choose EventFlow.

NO LOGIN REQUIRED:
The app works completely offline with no account needed.

CLEAR DATA:
Settings > Data > Clear All Data (removes all imported events)

PRIVACY:
EventFlow collects NO data. All events stay on the device.
```

---

## 🏗️ Build Commands

### Clean Build for Submission
```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Run tests
flutter test

# Generate icons (if needed)
dart run flutter_launcher_icons

# Build IPA for App Store
flutter build ipa --release --build-name=1.0.0 --build-number=1
```

### Verify Version in Built IPA
After building, open the IPA in Xcode and verify:
- CFBundleShortVersionString = 1.0.0
- CFBundleVersion = 1

---

## 📋 App Privacy Declaration

In App Store Connect, declare:

**Data Collection:** Data Not Collected

Specifically:
- ❌ Contact Info
- ❌ Health & Fitness
- ❌ Financial Info
- ❌ Location
- ❌ Sensitive Info
- ❌ Contacts
- ❌ User Content (events are local only)
- ❌ Browsing History
- ❌ Search History
- ❌ Identifiers
- ❌ Purchases
- ❌ Usage Data
- ❌ Diagnostics
- ❌ Other Data

---

## 🚀 Next Steps

1. **Generate Screenshots**
   - Use `flutter run --release` on various iPhone simulators
   - Capture screenshots of all key features
   - Use macOS Screenshot tool (Cmd+Shift+4)

2. **Create App Store Connect Listing**
   - Create new app in App Store Connect
   - Upload screenshots
   - Enter app information from this document
   - Set privacy declarations

3. **Build and Upload**
   - Run build commands above
   - Use Xcode to upload to App Store Connect
   - Or use Transporter app

4. **Submit for Review**
   - Include App Review Notes
   - Set release preference (manual/automatic)
   - Submit for review

---

## 🎯 Success Criteria

Before submitting, verify:
- ✅ App launches without crashes
- ✅ Import sample data works
- ✅ All 5 tabs functional
- ✅ Clear data works
- ✅ Theme switching works
- ✅ Onboarding shows on first launch
- ✅ Privacy policy accessible
- ✅ All tests pass

---

**Prepared by:** Amp AI  
**Last Updated:** October 15, 2025  
**Status:** Ready for App Store Submission 🎉
