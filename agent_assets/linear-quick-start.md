# Linear Quick Start Guide

**Goal:** Start tracking current work in Linear immediately

---

## Option 1: Manual Creation (5 minutes)

### Step 1: Open Linear
Go to your Linear workspace

### Step 2: Create Issues

Copy and paste these issues one by one:

#### Issue 1: App Store Rejection Fixes ✅
```
Title: Fix App Store Rejection Issues (v1.0.0)
Priority: P0
Labels: bug, app-store
Status: Done

Description:
Fixed sample conference loading bug and created iPad screenshot guide.
See agent_assets/app-store-rejection-fixes.md for details.
```

#### Issue 2: Automated Screenshots ✅
```
Title: Implement Automated Screenshot Generation
Priority: P1
Labels: feature, automation, infrastructure
Status: Done

Description:
Created screenshot automation system (Fastlane + Integration Tests + Scripts).
Reduces screenshot time from 2-3 hours to 5 minutes.
See agent_assets/screenshot-automation-guide.md
```

#### Issue 3: App Store Submission 🔄
```
Title: Complete App Store Submission (v1.0.0 Build 7)
Priority: P0
Labels: app-store, release
Status: In Progress

Description:
Preparing for App Store resubmission.

Tasks:
- [ ] Test sample conference loading on iPad
- [ ] Generate iPad screenshots using automation
- [ ] Increment build number to 7
- [ ] Build and upload IPA
- [ ] Submit for review
```

#### Issue 4: iPad Screenshots 📋
```
Title: Generate iPad Screenshots Using Automation
Priority: P0
Labels: app-store, automation
Status: Todo

Description:
Use new screenshot automation to generate proper iPad screenshots.
```

---

## Option 2: Use Linear CLI (Faster)

### Setup
```bash
npm install -g @linear/cli
linear auth
```

### Create Issues
```bash
./scripts/create_linear_issues.sh
```

Or manually:
```bash
linear create "Fix App Store Rejection Issues" \
  --priority p0 \
  --label bug,app-store \
  --state Done \
  --description "Fixed sample conference loading bug..."
```

---

## Option 3: Import from File

1. Open `agent_assets/linear-current-work-issues.md`
2. Copy issue details
3. Paste into Linear issue creation form
4. Fill in fields

---

## Recommended Workflow with Cursor Integration

### Before Starting Work
1. Create Linear issue with detailed description
2. Include acceptance criteria
3. Add technical context
4. **Assign to Cursor** (instead of yourself!)
5. Cursor agent automatically starts working

### While Cursor Works
1. Monitor progress in Linear
2. Check Cursor web app for activity
3. Review work in IDE if needed
4. Add comments if clarification needed

### When Cursor Completes
1. Review PR created by Cursor
2. Test the implementation
3. Merge if approved
4. Issue auto-updates to "Done"

### Manual Work (If Needed)
If you prefer to work manually:
1. Create Linear issue
2. Work in Cursor IDE (reference issue)
3. Update Linear with progress
4. Link PR when created

---

## Quick Reference

**Create Issue:**
- Linear UI: Click "New Issue"
- CLI: `linear create "Title" --priority p0`

**Update Status:**
- Linear UI: Change status dropdown
- CLI: `linear update ISSUE-123 --state "In Progress"`

**Add Comment:**
- Linear UI: Type in comment box
- CLI: `linear comment ISSUE-123 "Comment text"`

**Link to GitHub:**
- Add GitHub URL in issue description
- Or use Linear's GitHub integration

---

**Time to Set Up:** 5-10 minutes  
**Time Saved:** Hours of tracking and organization

