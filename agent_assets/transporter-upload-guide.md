# Transporter Upload Guide for EventFlow

**App:** EventFlow v1.0.0 (Build 6)  
**Bundle ID:** `com.thephillipsequation.eventflow`

---

## Step 1: Build IPA for App Store

Run these commands to create the IPA:

```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Verify tests pass
flutter test

# Build IPA for App Store
flutter build ipa --release --build-name=1.0.0 --build-number=6
```

The IPA will be created at:
```
build/ios/ipa/EventFlow.ipa
```

**Note:** This build requires code signing. Make sure you have:
- Valid Apple Developer account
- Code signing certificates installed
- Provisioning profiles configured

---

## Step 2: Open Transporter

1. **Download Transporter** (if not installed):
   - From Mac App Store: Search "Transporter"
   - Or download from [developer.apple.com](https://apps.apple.com/us/app/transporter/id1450874784)

2. **Open Transporter** application

3. **Sign In:**
   - Use your Apple Developer account credentials
   - Same account used for App Store Connect

---

## Step 3: Upload IPA

1. **Add IPA to Transporter:**
   - Click **"+"** button or drag and drop
   - Navigate to: `build/ios/ipa/EventFlow.ipa`
   - Select the IPA file
   - Click **"Add"**

2. **Verify Build Information:**
   - App Name: EventFlow
   - Version: 1.0.0
   - Build: 6
   - Bundle ID: `com.thephillipsequation.eventflow`

3. **Upload:**
   - Click **"Deliver"** button
   - Wait for upload to complete (usually 5-15 minutes depending on file size)
   - You'll see progress in Transporter

4. **Verify Upload:**
   - Check for any errors or warnings
   - Note the upload ID if provided

---

## Step 4: Process in App Store Connect

1. **Wait for Processing:**
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Navigate to your EventFlow app
   - Go to **"TestFlight"** or **"App Store"** → **"iOS App"** → **"Build"** section
   - Processing usually takes 10-30 minutes

2. **Check Status:**
   - Build will show as "Processing" initially
   - When ready, it will show as "Ready to Submit" or similar
   - If there are errors, you'll see them here

3. **Common Processing Issues:**
   - **Missing Compliance:** May need to answer export compliance questions
   - **Invalid Bundle:** Check bundle ID matches App Store Connect
   - **Code Signing:** Verify certificates are valid

---

## Step 5: Add Build to Version

1. **Select Version:**
   - In App Store Connect, go to your app version (1.0.0)
   - Scroll to **"Build"** section

2. **Select Build:**
   - Click **"+"** next to Build
   - Select the processed build (1.0.0 (6))
   - Click **"Done"**

3. **Verify:**
   - Build should now be associated with the version
   - Ready for submission

---

## Step 6: Submit for Review

1. **Final Checklist:**
   - [ ] Build processed and selected
   - [ ] All app information complete
   - [ ] Screenshots uploaded
   - [ ] Privacy policy accessible
   - [ ] Version information (What's New) added
   - [ ] Export compliance answered (if prompted)

2. **Submit:**
   - Click **"Submit for Review"**
   - Select release option:
     - **Manual:** You control when it goes live
     - **Automatic:** Goes live immediately after approval
   - Click **"Submit"**

3. **Confirmation:**
   - You'll see "Waiting for Review" status
   - Apple will send email notifications for status changes

---

## Troubleshooting

### Transporter Won't Open IPA

**Issue:** "Invalid IPA" or similar error

**Solutions:**
- Verify IPA was built with `--release` flag
- Check code signing is valid
- Rebuild IPA: `flutter clean && flutter build ipa --release`

### Upload Fails

**Issue:** Upload fails or times out

**Solutions:**
- Check internet connection
- Try again (transient network issues)
- Verify Apple Developer account is active
- Check for Transporter updates

### Build Not Appearing in App Store Connect

**Issue:** Build uploaded but not showing

**Solutions:**
- Wait 10-30 minutes for processing
- Check email for processing errors
- Verify bundle ID matches exactly
- Check "Expired" builds section

### Processing Errors

**Issue:** Build fails processing

**Common Causes:**
- Invalid code signing
- Missing required Info.plist keys
- Bundle ID mismatch
- Version/build number conflicts

**Solutions:**
- Check email from Apple for specific errors
- Verify all configuration matches
- Rebuild with correct settings

---

## Alternative: Xcode Archive Method

If Transporter doesn't work, you can use Xcode:

1. **Open Project:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Archive:**
   - Select **"Any iOS Device"** as target
   - **Product** → **Archive**
   - Wait for archive to complete

3. **Distribute:**
   - In Organizer window, click **"Distribute App"**
   - Select **"App Store Connect"**
   - Follow prompts to upload

---

## Quick Reference

### Build Command
```bash
flutter build ipa --release --build-name=1.0.0 --build-number=6
```

### IPA Location
```
build/ios/ipa/EventFlow.ipa
```

### Transporter Location
- Mac App Store: "Transporter"
- Or: Applications folder after installation

### App Store Connect
- URL: https://appstoreconnect.apple.com
- Navigate: My Apps → EventFlow → App Store → iOS App

---

## Expected Timeline

- **Build Time:** 2-5 minutes
- **Upload Time:** 5-15 minutes
- **Processing Time:** 10-30 minutes
- **Review Time:** 1-7 days (typical)

**Total to Submission:** ~1 hour (mostly waiting)

---

**Last Updated:** 2025-01-XX  
**Status:** Ready for Transporter upload

