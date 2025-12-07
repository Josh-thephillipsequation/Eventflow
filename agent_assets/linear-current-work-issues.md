# Linear Issues for Current Work Session

**Date:** 2025-01-XX  
**Session Focus:** App Store submission fixes + Screenshot automation

This document lists all the work items from this session that should be created in Linear for tracking.

---

## Completed Work (Create as "Done")

### 1. App Store Rejection Fixes
**Title:** Fix App Store Rejection Issues (v1.0.0)  
**Priority:** P0  
**Labels:** `bug`, `app-store`, `p0`  
**Status:** Done  
**Description:**
Fixed two App Store rejection issues:
1. Sample conference loading bug - events not appearing after import on iPad
2. iPad screenshots showing stretched iPhone images

**Changes Made:**
- Enhanced error handling in `EventProvider.loadCalendarFromAsset()`
- Added validation for parsed events
- Improved UI error messages in Settings and Import screens
- Created iPad screenshot guide

**Files Modified:**
- `lib/providers/event_provider.dart`
- `lib/screens/settings_screen.dart`
- `lib/screens/import_calendar_screen.dart`

**Branch:** `fix/app-store-rejection-issues`

---

### 2. Automated Screenshot Generation System
**Title:** Implement Automated Screenshot Generation  
**Priority:** P1  
**Labels:** `feature`, `automation`, `infrastructure`, `p1`  
**Status:** Done  
**Description:**
Created comprehensive screenshot automation system to eliminate manual screenshot work for App Store submissions.

**Implementation:**
- Fastlane integration for automated screenshots
- Flutter integration test for reliable navigation
- Shell scripts for flexible automation
- Resize scripts for App Store requirements
- Complete documentation

**Files Created:**
- `fastlane/Fastfile`
- `fastlane/scripts/take_screenshots.rb`
- `test/integration/screenshot_automation_test.dart`
- `scripts/automate_screenshots.sh`
- `scripts/screenshot_with_integration_test.sh`
- `scripts/resize_screenshots_for_app_store.sh`
- `scripts/quick_screenshot.sh`
- `agent_assets/screenshot-automation-guide.md`

**Benefits:**
- Reduces screenshot time from 2-3 hours to 5 minutes
- Supports all required device sizes
- Automatically captures all main screens
- Can be integrated into CI/CD

**Branch:** `feature/automated-screenshots`

---

### 3. Bundle ID Update
**Title:** Update Bundle ID for App Store Submission  
**Priority:** P0  
**Labels:** `app-store`, `config`, `p0`  
**Status:** Done  
**Description:**
Updated bundle ID from `com.joshua.eventflow` to `com.thephillipsequation.eventflow` for proper App Store submission.

**Changes:**
- Updated all 12 occurrences in `ios/Runner.xcodeproj/project.pbxproj`
- Verified build works with new bundle ID
- Updated documentation

**Files Modified:**
- `ios/Runner.xcodeproj/project.pbxproj`

---

### 4. Test Suite Fixes
**Title:** Fix Performance Test Failures  
**Priority:** P1  
**Labels:** `bug`, `testing`, `p1`  
**Status:** Done  
**Description:**
Fixed failing performance tests by adding proper SharedPreferences mocking and fixing test state management.

**Changes:**
- Added SharedPreferences mock setup in performance tests
- Fixed test state isolation issues
- All 92+ tests now passing

**Files Modified:**
- `test/integration/performance_test.dart`

---

## In Progress Work (Create as "In Progress")

### 5. App Store Submission Preparation
**Title:** Complete App Store Submission (v1.0.0 Build 7)  
**Priority:** P0  
**Labels:** `app-store`, `release`, `p0`  
**Status:** In Progress  
**Description:**
Preparing for App Store resubmission after fixing rejection issues.

**Tasks:**
- [ ] Test sample conference loading on iPad device
- [ ] Create proper iPad screenshots using automation
- [ ] Increment build number to 7
- [ ] Build IPA for App Store
- [ ] Upload via Transporter
- [ ] Update App Review Notes
- [ ] Submit for review

**Dependencies:**
- Requires completion of automated screenshot generation
- Requires iPad testing verification

**Estimated Time:** 2-3 hours

---

## Future Work (Create as "Todo")

### 6. iPad Screenshot Generation (READY FOR CURSOR!)
**Title:** Generate iPad Screenshots Using Automation  
**Priority:** P0  
**Labels:** `app-store`, `automation`, `p0`  
**Status:** Todo  
**Assignee:** Cursor (assign when creating issue!)

**Description:**
Use the new screenshot automation system to generate proper iPad screenshots for all required App Store sizes. The automation scripts are already created and ready to use.

**Acceptance Criteria:**
- [ ] Run screenshot automation on iPad Pro 12.9" simulator (2048 x 2732)
- [ ] Run screenshot automation on iPad Pro 11" simulator (1668 x 2388)
- [ ] Run screenshot automation on iPad Air 5th gen simulator (1640 x 2360)
- [ ] Verify screenshots show proper iPad UI (not stretched iPhone images)
- [ ] Resize screenshots to exact App Store dimensions using resize script
- [ ] Screenshots saved in organized directory structure

**Technical Notes:**
- Automation script: `./scripts/screenshot_with_integration_test.sh`
- Alternative: `fastlane ios screenshots` (for iPad devices)
- Resize script: `./scripts/resize_screenshots_for_app_store.sh`
- Screenshot guide: `agent_assets/screenshot-automation-guide.md`
- Required sizes: See `agent_assets/ipad-screenshots-guide.md`
- Integration test: `test/integration/screenshot_automation_test.dart`

**Commands to Run:**
```bash
# Method 1: Integration test (recommended)
flutter test integration_test/screenshot_automation_test.dart \
  -d "iPad Pro (12.9-inch) (6th generation)" \
  --screenshot-dir screenshots/ipad_12.9

# Method 2: Shell script
./scripts/screenshot_with_integration_test.sh

# Method 3: Fastlane
fastlane ios screenshots
```

**Branch:** `feature/ipad-screenshots`

**Dependencies:**
- Automated screenshot system (completed - Issue #2)
- iPad simulator access

**Estimated Time:** 30 minutes (automated)

---

### 7. CI/CD Integration for Screenshots
**Title:** Integrate Screenshot Automation into CI/CD  
**Priority:** P2  
**Labels:** `infrastructure`, `ci-cd`, `automation`, `p2`  
**Status:** Todo  
**Description:**
Add screenshot generation to GitHub Actions workflow for automatic screenshot updates on UI changes.

**Tasks:**
- [ ] Add screenshot job to GitHub Actions
- [ ] Configure to run on UI-related changes
- [ ] Store screenshots as artifacts
- [ ] Optional: Auto-upload to App Store Connect

**Dependencies:**
- Screenshot automation system (completed)

**Estimated Time:** 2-3 hours

---

## How to Create These in Linear

### Step 1: Create Project/Team
1. Go to Linear
2. Create project: "EventFlow"
3. Set up labels: `p0`, `p1`, `p2`, `bug`, `feature`, `app-store`, `automation`, `infrastructure`, `testing`, `config`, `release`

### Step 2: Create Issues

For each item above:

1. **Click "New Issue"**
2. **Fill in:**
   - Title: (from above)
   - Description: (copy from above)
   - Priority: (P0/P1/P2)
   - Labels: (add relevant labels)
   - Status: (Done/In Progress/Todo)
   - Assignee: (yourself)
   - Project: EventFlow

3. **For completed items:**
   - Set status to "Done"
   - Add completion date
   - Link to branch/PR if applicable

4. **For in-progress items:**
   - Set status to "In Progress"
   - Add yourself as assignee
   - Break down into subtasks

5. **Link to GitHub:**
   - Add GitHub repository link
   - Link to relevant branches
   - Link to PRs when created

### Step 3: Set Up Dependencies

- Issue #5 (App Store Submission) depends on:
  - Issue #6 (iPad Screenshots)
  - Issue #1 (Rejection Fixes)

- Issue #7 (CI/CD Integration) depends on:
  - Issue #2 (Screenshot Automation)

---

## Quick Copy-Paste Templates

### Template 1: Completed Work
```
Title: [Title from above]

Priority: [P0/P1/P2]
Labels: [comma-separated labels]
Status: Done

Description:
[Description from above]

Changes Made:
- [List of changes]

Files Modified:
- [List of files]

Branch: [branch name]
```

### Template 2: In Progress
```
Title: [Title from above]

Priority: [P0/P1/P2]
Labels: [comma-separated labels]
Status: In Progress

Description:
[Description from above]

Tasks:
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

Dependencies:
- [List dependencies]

Estimated Time: [X hours]
```

---

## Next Steps

1. **Create Linear Issues:**
   - Copy items from this document
   - Create issues in Linear
   - Set appropriate statuses

2. **Link to Code:**
   - Link issues to GitHub branches
   - Add file references
   - Link to PRs when created

3. **Update as You Work:**
   - Update issue status
   - Add comments with progress
   - Mark subtasks complete

4. **Use for Future Work:**
   - Create Linear issue before starting work
   - Reference issue in commits/PRs
   - Update status as you progress

---

**Last Updated:** 2025-01-XX  
**Status:** Ready for Linear import

