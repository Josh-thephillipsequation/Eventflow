# Linear Issues Ready to Assign to Cursor

**Status:** ✅ Linear-Cursor integration is set up and ready!

These issues are optimized for Cursor agent assignment. Copy them into Linear and assign to Cursor.

---

## Issue 1: Generate iPad Screenshots (PRIORITY - Ready Now!)

**Copy this into Linear:**

```
Title: Generate iPad Screenshots Using Automation

Priority: P0
Labels: app-store, automation, p0
Status: Todo
Assignee: Cursor

Description:
Use the new screenshot automation system to generate proper iPad screenshots for all required App Store sizes. The automation scripts are already created and ready to use.

The App Store rejected our previous submission because iPad screenshots showed stretched iPhone images. We need proper iPad screenshots at exact App Store dimensions.

Acceptance Criteria:
- [ ] Run screenshot automation on iPad Pro 12.9" simulator (2048 x 2732 pixels)
- [ ] Run screenshot automation on iPad Pro 11" simulator (1668 x 2388 pixels)
- [ ] Run screenshot automation on iPad Air 5th gen simulator (1640 x 2360 pixels)
- [ ] Verify screenshots show proper iPad UI (not stretched iPhone images)
- [ ] Resize screenshots to exact App Store dimensions using resize script
- [ ] Screenshots saved in organized directory: screenshots/app_store_ready/

Technical Notes:
- Automation script location: ./scripts/screenshot_with_integration_test.sh
- Alternative method: fastlane ios screenshots (for iPad devices)
- Resize script: ./scripts/resize_screenshots_for_app_store.sh
- Screenshot guide: agent_assets/screenshot-automation-guide.md
- Required sizes: See agent_assets/ipad-screenshots-guide.md
- Integration test file: test/integration/screenshot_automation_test.dart

Commands to Run:
```bash
# Method 1: Integration test (recommended - most reliable)
flutter test integration_test/screenshot_automation_test.dart \
  -d "iPad Pro (12.9-inch) (6th generation)" \
  --screenshot-dir screenshots/ipad_12.9

# Method 2: Shell script automation
./scripts/screenshot_with_integration_test.sh

# Method 3: Fastlane (if installed)
fastlane ios screenshots
```

# After screenshots generated, resize to exact dimensions:
./scripts/resize_screenshots_for_app_store.sh \
  screenshots/automated \
  screenshots/app_store_ready

Files to Reference:
- agent_assets/screenshot-automation-guide.md (complete guide)
- agent_assets/ipad-screenshots-guide.md (iPad-specific requirements)
- scripts/screenshot_with_integration_test.sh (automation script)
- scripts/resize_screenshots_for_app_store.sh (resize script)

Branch: feature/ipad-screenshots
```

**To Assign:**
1. Create issue in Linear (paste above)
2. Click assignee dropdown
3. Select "Cursor"
4. Cursor will automatically start working!

---

## Issue 2: Test Sample Conference Loading on iPad

**Copy this into Linear:**

```
Title: Test Sample Conference Loading on iPad

Priority: P0
Labels: testing, app-store, p0
Status: Todo
Assignee: Cursor

Description:
Verify that the sample conference loading fix works correctly on iPad devices. The App Store rejection mentioned that no events appeared after loading sample conference on iPad Air 5th generation.

We've already fixed the code (see Issue: Fix App Store Rejection Issues), but need to verify it works on actual iPad devices/simulators.

Acceptance Criteria:
- [ ] Test on iPad Air 5th generation simulator (or similar)
- [ ] Navigate to Settings > Data > Import Sample Conference
- [ ] Verify events load successfully
- [ ] Verify events appear in All Events tab
- [ ] Verify events appear in My Agenda (after selecting some)
- [ ] Test error handling (if possible to trigger)
- [ ] Document test results

Technical Notes:
- Fixed code in: lib/providers/event_provider.dart
- Test file: assets/sample_conference.ics
- Related screens: lib/screens/settings_screen.dart, lib/screens/import_calendar_screen.dart
- See: agent_assets/app-store-rejection-fixes.md for fix details

Commands:
```bash
# Run on iPad simulator
flutter run -d "iPad Air (5th generation)"

# Or list available devices
flutter devices
```

Branch: test/ipad-sample-loading
```

---

## Issue 3: Increment Build and Prepare for Resubmission

**Copy this into Linear:**

```
Title: Increment Build Number and Prepare App Store Resubmission

Priority: P0
Labels: app-store, release, p0
Status: Todo
Assignee: Cursor

Description:
Increment build number to 7, build IPA, and prepare for App Store resubmission after fixing rejection issues.

Acceptance Criteria:
- [ ] Update pubspec.yaml: version 1.0.0+7
- [ ] Verify version in iOS project matches
- [ ] Build IPA: flutter build ipa --release --build-name=1.0.0 --build-number=7
- [ ] Verify IPA builds successfully
- [ ] Update App Review Notes with fix details
- [ ] Prepare for Transporter upload

Technical Notes:
- Current version: 1.0.0+6 (in pubspec.yaml)
- Build command: flutter build ipa --release --build-name=1.0.0 --build-number=7
- IPA location: build/ios/ipa/EventFlow.ipa
- App Review Notes: See agent_assets/app-store-rejection-fixes.md
- Upload guide: agent_assets/transporter-upload-guide.md

Files to Update:
- pubspec.yaml (line 4: version: 1.0.0+7)
- agent_assets/app-store-rejection-fixes.md (update App Review Notes section)

Branch: release/v1.0.0-build-7
```

---

## Quick Steps to Assign to Cursor

1. **Open Linear**
2. **Click "New Issue"**
3. **Paste issue template** (from above)
4. **Fill in fields:**
   - Title: (already in template)
   - Description: (already in template)
   - Priority: (already in template)
   - Labels: (already in template)
5. **Click assignee dropdown**
6. **Select "Cursor"** ← This starts the agent!
7. **Save issue**

Cursor will automatically:
- Read the issue description
- Understand the context
- Start working on the task
- Create a PR when complete
- Update Linear with progress

---

## Tips for Best Results

### Write Detailed Descriptions
- Cursor reads the full description
- Include file paths, commands, examples
- Reference existing code patterns

### Use Acceptance Criteria
- Clear checklist of requirements
- Makes success criteria obvious
- Cursor knows when it's done

### Include Technical Context
- Branch naming
- Files to modify
- Commands to run
- Dependencies

### Reference Existing Work
- Link to related issues
- Point to documentation
- Reference similar implementations

---

## Next Steps

1. **Create Issue #1** (iPad Screenshots) - Most urgent
2. **Assign to Cursor** - Watch it work!
3. **Monitor Progress** - Check Linear, Cursor web app, or IDE
4. **Review PR** - When Cursor completes
5. **Repeat** - For other issues

---

**Ready to try?** Create the iPad Screenshots issue and assign it to Cursor! 🚀

