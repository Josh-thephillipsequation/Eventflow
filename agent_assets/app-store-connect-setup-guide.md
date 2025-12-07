# App Store Connect Setup Guide for EventFlow

**Version:** 1.0.0 (Build 6)  
**Bundle ID:** `com.thephillipsequation.eventflow`  
**Date:** 2025-01-XX

## Quick Checklist

- [ ] Create app listing in App Store Connect
- [ ] Upload app metadata
- [ ] Upload screenshots (10 images from `app_store_final/`)
- [ ] Configure privacy settings
- [ ] Add app review information
- [ ] Build and upload IPA
- [ ] Submit for review

---

## Step 1: Create App Listing

1. Log into [App Store Connect](https://appstoreconnect.apple.com)
2. Click **"My Apps"** → **"+"** → **"New App"**
3. Fill in:
   - **Platform:** iOS
   - **Name:** EventFlow
   - **Primary Language:** English (U.S.)
   - **Bundle ID:** `com.thephillipsequation.eventflow` (must be registered in Apple Developer Portal first)
   - **SKU:** `eventflow-001` (or any unique identifier)
   - **User Access:** Full Access (or as needed)

4. Click **"Create"**

---

## Step 2: App Information

Navigate to **App Information** section:

### Basic Information
- **Name:** EventFlow
- **Subtitle:** Smart Conference Schedule Manager
- **Category:** 
  - Primary: Productivity
  - Secondary: Business
- **Content Rights:** I have the rights to use this content

### Age Rating
- Click **"Edit"** next to Age Rating
- Answer questions (all should be "No" for EventFlow)
- Result should be **4+**

---

## Step 3: Pricing and Availability

1. Click **"Pricing and Availability"**
2. Set **Price:** Free
3. Set **Availability:** All countries (or select specific)
4. Click **"Save"**

---

## Step 4: Prepare for Submission

### 4.1 App Privacy

1. Click **"App Privacy"** → **"Get Started"**
2. Select **"Data Not Collected"**
3. Answer all questions as "No" - EventFlow collects no data
4. Click **"Save"**

### 4.2 Version Information

1. Click **"+"** next to iOS App to create version 1.0.0
2. Fill in **What's New in This Version:**
```
🎉 Welcome to EventFlow!

✨ Initial Release Features:
• Import conference calendars from .ics files or URLs
• Beautiful Material 3 design interface
• Smart event filtering and search
• Personal agenda creation
• Interactive analytics with topic clouds and heatmaps
• AI-powered fun features: talk generators, product names, bingo
• Offline access to your schedule
• Clean, intuitive user experience

Perfect for conference attendees, event organizers, and anyone who wants to stay on top of their schedule. Download EventFlow and transform how you manage events!
```

3. **Promotional Text (Optional):** Leave blank or add marketing copy
4. **Description:** Use full description from `app-store-metadata.json`:
```
EventFlow revolutionizes how you manage conference schedules. Whether attending tech conferences, academic symposiums, or business events, EventFlow transforms complex schedules into your personalized agenda.

🎯 KEY FEATURES
• Import calendars from any .ics URL or file
• Smart event filtering and search
• Clean, Material 3 design interface
• Offline access to your schedule
• Personal agenda creation
• Session tracking and notes
• Interactive analytics with topic clouds and 24-hour heatmaps
• AI-powered fun features: talk generators, product names, conference bingo

✨ PERFECT FOR
• Conference attendees
• Event organizers
• Business professionals
• Students and academics
• Anyone managing complex schedules

🏆 WHY EVENTFLOW?
• Lightning-fast calendar import
• Intuitive event management
• Beautiful, modern design
• Completely private - your data stays on your device
• No ads, no subscriptions

Developed by thephillipsequation llc, EventFlow brings professional-grade schedule management to your fingertips. Download now and never miss another important session!
```

5. **Keywords:** `calendar,conference,schedule,agenda,events,ics,import,planner,organizer,sessions`

6. **Support URL:** `https://josh-thephillipsequation.github.io/Eventflow/`
7. **Marketing URL:** `https://josh-thephillipsequation.github.io/Eventflow/`
8. **Privacy Policy URL:** `https://josh-thephillipsequation.github.io/Eventflow/privacy`

### 4.3 Screenshots

**Required Sizes:**
- 6.7" Display (iPhone 14 Pro Max, 15 Pro Max): 1290 x 2796 pixels
- 6.5" Display (iPhone 11 Pro Max, XS Max): 1242 x 2688 pixels  
- 5.5" Display (iPhone 8 Plus): 1242 x 2208 pixels

**Upload Order (from `app_store_final/CAPTIONS.txt`):**
1. `06_screenshot.jpg` - Main events view
2. `07_screenshot.jpg` - My agenda
3. `08_screenshot.jpg` - Insights/analytics
4. `09_screenshot.jpg` - Fun bingo
5. `10_screenshot.jpg` - Talk generator
6. `03_screenshot.jpg` - Filtering
7. `01_screenshot.jpg` - Welcome (optional)
8. `02_screenshot.jpg` - Import guide (optional)

**Note:** Current screenshots in `app_store_final/` are 1284 × 2778 pixels. You may need to resize for different display sizes or use the same images for all sizes if they meet minimum requirements.

### 4.4 App Review Information

1. Scroll to **"App Review Information"**
2. **Contact Information:**
   - First Name: [Your First Name]
   - Last Name: [Your Last Name]
   - Phone: [Your Phone]
   - Email: `privacy@thephillipsequation.com`

3. **Demo Account:** Not required (app works offline)

4. **Notes:**
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

5. **Advertising Identifier:** No (EventFlow doesn't use advertising)

---

## Step 5: Build and Upload

### 5.1 Build IPA

Run these commands in the project directory:

```bash
# Clean and prepare
flutter clean
flutter pub get
flutter test  # Verify all tests pass
flutter analyze --fatal-infos

# Build for App Store
flutter build ipa --release --build-name=1.0.0 --build-number=6
```

The IPA will be created at: `build/ios/ipa/EventFlow.ipa`

### 5.2 Archive in Xcode (Alternative Method)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **"Any iOS Device"** as target (not a simulator)
3. Go to **Product** → **Archive**
4. Wait for archive to complete
5. In Organizer window:
   - Click **"Distribute App"**
   - Select **"App Store Connect"**
   - Click **"Next"**
   - Select **"Upload"**
   - Click **"Next"**
   - Review options (usually defaults are fine)
   - Click **"Upload"**

### 5.3 Wait for Processing

- Processing usually takes 10-30 minutes
- Check App Store Connect → **"TestFlight"** or **"App Store"** → **"iOS App"** → **"Build"** section
- Once processed, select the build in the version information

---

## Step 6: Submit for Review

1. In App Store Connect, go to your app version
2. Scroll to **"Build"** section
3. Select the processed build (1.0.0 (6))
4. Review all sections:
   - [ ] App Information complete
   - [ ] Screenshots uploaded
   - [ ] Privacy policy accessible
   - [ ] Build selected
   - [ ] Version information complete
   - [ ] Export compliance answered (if prompted)

5. Click **"Add for Review"** or **"Submit for Review"**
6. Select release option:
   - **Manual:** You control when it goes live
   - **Automatic:** Goes live immediately after approval
7. Click **"Submit"**

---

## Step 7: Monitor Review

1. Check App Store Connect daily for status updates
2. Typical review time: 1-7 days
3. If rejected:
   - Read rejection reasons carefully
   - Address issues
   - Resubmit with explanation

---

## Troubleshooting

### Bundle ID Not Found
- Ensure bundle ID is registered in [Apple Developer Portal](https://developer.apple.com/account/resources/identifiers/list)
- Bundle ID must match exactly: `com.thephillipsequation.eventflow`

### Build Processing Failed
- Check email from App Store Connect for details
- Common issues: missing icons, invalid entitlements, code signing
- Verify Info.plist has all required keys

### Screenshot Size Issues
- Use macOS Preview or online tools to resize
- Minimum sizes must be met for each display size
- All screenshots should be in portrait orientation

---

## Next Steps After Approval

1. **Monitor Launch:**
   - Check App Store listing
   - Monitor for user reviews
   - Watch for crash reports (if analytics added later)

2. **Marketing:**
   - Share on social media
   - Update website
   - Reach out to potential users

3. **Iterate:**
   - Plan v1.1 features (see roadmap)
   - Gather user feedback
   - Plan TestFlight beta for future releases

---

**Last Updated:** 2025-01-XX  
**Status:** Ready for App Store Connect setup

