# Quick Guide: Assigning Issues to Cursor

**You've set up Linear-Cursor integration - here's how to use it!**

---

## Step 1: Create Issue in Linear

1. Open Linear
2. Click "New Issue"
3. Fill in:
   - **Title:** Clear, descriptive title
   - **Description:** Detailed description with context
   - **Acceptance Criteria:** Checklist of requirements
   - **Priority:** P0/P1/P2/P3
   - **Labels:** Add relevant labels

---

## Step 2: Assign to Cursor

### Option A: Assignee Menu (Easiest)
1. In the issue, click the **assignee dropdown**
2. Select **"Cursor"** (or "Cursor Agent")
3. Done! Cursor starts working automatically

### Option B: Mention @cursor
1. In issue comments, type: `@cursor`
2. Or: "Please assign this to @cursor"
3. Cursor picks up the issue

---

## Step 3: Monitor Progress

Track in three places:
- **Linear:** Issue updates automatically
- **Cursor Web App:** See agent activity
- **IDE:** View work in progress

---

## Step 4: Review PR

When Cursor completes:
- PR is created automatically
- PR is linked to Linear issue
- Review and merge
- Issue updates to "Done"

---

## Current Issues Ready for Cursor

### Issue 1: Generate iPad Screenshots
**Ready to assign now!**

```
Title: Generate iPad Screenshots Using Automation

Description:
Use the new screenshot automation system to generate proper iPad screenshots 
for all required App Store sizes.

Acceptance Criteria:
- [ ] Run screenshot automation on iPad Pro 12.9" simulator
- [ ] Run screenshot automation on iPad Pro 11" simulator
- [ ] Run screenshot automation on iPad Air 5th gen simulator
- [ ] Verify screenshots show proper iPad UI (not stretched)
- [ ] Resize screenshots to exact App Store dimensions
- [ ] Upload screenshots to App Store Connect

Technical Notes:
- Use: ./scripts/screenshot_with_integration_test.sh
- Or: fastlane ios screenshots (for iPad devices)
- Screenshot guide: agent_assets/screenshot-automation-guide.md
- Required sizes: See agent_assets/ipad-screenshots-guide.md

Branch: feature/ipad-screenshots
```

**To Assign:**
1. Create this issue in Linear
2. Click assignee → Select "Cursor"
3. Cursor will run the automation and generate screenshots!

---

## Tips for Best Results

### Write Detailed Issues
- Cursor reads the description for context
- Include file paths, patterns, examples
- Reference existing code

### Use Acceptance Criteria
- Clear checklist of requirements
- Makes success criteria obvious
- Helps Cursor know when done

### Include Technical Context
- Branch naming
- Files to modify
- Patterns to follow
- Dependencies

---

## Example: Perfect Issue for Cursor

```markdown
Title: Fix Sample Conference Loading on iPad

Description:
The sample conference import works on iPhone but fails on iPad. After tapping 
"Import Sample Conference" in Settings, no events appear in the All Events tab.

Acceptance Criteria:
- [ ] Sample conference loads successfully on iPad Air 5th gen
- [ ] Events appear in All Events tab after import
- [ ] Error handling shows clear message if import fails
- [ ] Works on both iPhone and iPad

Technical Notes:
- Issue likely in: lib/providers/event_provider.dart
- Method: loadCalendarFromAsset()
- Test file: assets/sample_conference.ics
- Related: lib/screens/settings_screen.dart (import button)
- See: agent_assets/app-store-rejection-fixes.md

Branch: fix/ipad-sample-loading
```

---

**Ready to try?** Create an issue and assign it to Cursor! 🚀

