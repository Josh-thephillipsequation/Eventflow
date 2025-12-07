# Linear-Cursor Integration Guide

This guide explains how to use the **official Linear-Cursor integration** for automated development workflow.

## Overview

**Official Integration**: [Linear-Cursor Integration](https://linear.app/integrations/cursor)  
**Goal**: Assign Linear issues directly to Cursor cloud agents for automated implementation  
**Workflow**: Linear Issue → Assign to Cursor → Agent Works → PR Created → Issue Updated

## Key Features

- ✅ **Direct Assignment**: Assign any Linear issue to Cursor agent
- ✅ **Cloud Agents**: Cursor spins up cloud agents to work on tasks
- ✅ **Automatic PRs**: Agent creates PRs when tasks complete
- ✅ **Progress Tracking**: Updates flow back to Linear automatically
- ✅ **Multi-Issue Support**: Cursor can work on multiple issues simultaneously
- ✅ **Unified View**: Track progress in Linear, Cursor web app, or IDE

---

## Setup

### 1. Install Cursor Cloud Agent (Admin Required)

**Requirements:**
- Cursor Pro or Ultra plan
- Admin access to workspace

**Steps:**
1. Go to [Linear-Cursor Integration](https://linear.app/integrations/cursor)
2. Click "Install" or "Configure"
3. Follow Cursor's setup instructions
4. Connect your Linear workspace

**Note:** You mentioned you've already added Linear as a team member - the integration should be ready to use!

### 2. Verify Integration

1. Open Linear
2. Go to any issue
3. Check assignee dropdown - you should see "Cursor" as an option
4. Or try mentioning `@cursor` in a comment

### 3. GitHub Integration (Recommended)

1. In Linear: Settings → Integrations → GitHub
2. Connect repository: `Josh-thephillipsequation/Eventflow`
3. Enable:
   - Auto-link issues to PRs
   - Update Linear when PRs are merged
   - Sync status

This ensures PRs created by Cursor are automatically linked to Linear issues.

---

## Workflow: Assign Issues to Cursor

### Method 1: Assign to Cursor Agent (Recommended)

**Step 1: Create or Open Issue in Linear**

Create a new issue or open an existing one with:
- Clear title
- Detailed description
- Acceptance criteria
- Priority and labels

**Step 2: Assign to Cursor**

**Option A: From Assignee Menu**
1. Open the issue in Linear
2. Click the assignee dropdown
3. Select "Cursor" (or "Cursor Agent")
4. Cursor agent automatically starts working

**Option B: Mention @cursor**
1. In issue comments, type: `@cursor`
2. Or mention: "Assign this to @cursor"
3. Cursor agent picks up the issue

**Step 3: Monitor Progress**

Track progress in three places:
- **Linear**: Issue updates automatically
- **Cursor Web App**: See agent activity
- **IDE**: View work in progress

**Step 4: Review PR**

When complete:
- Cursor creates a PR automatically
- PR is linked to Linear issue
- Review and merge as usual
- Issue status updates automatically

### Method 2: Manual Workflow (If Needed)

If you prefer to work manually with Cursor IDE:

**Step 1: Get Issue from Linear**
- Open issue in Linear
- Copy issue details

**Step 2: Work in Cursor IDE**
- Open Cursor chat
- Paste issue details
- Work with Cursor to implement

**Step 3: Update Linear**
- Mark issue as "In Progress"
- Add comments with progress
- Link PR when created

### Pattern 2: Cursor Discovery → Linear Issue

**When:** You discover a bug or need while coding

**Step 1: Document in Cursor**

Ask Cursor to help document:
```
I found this issue: [description]. Can you help me create a clear bug report with:
1. Steps to reproduce
2. Expected behavior
3. Actual behavior
4. Technical details
```

**Step 2: Create Linear Issue**

```bash
# Create issue from command line
linear create "Bug: [Title]" \
  --description "[Description from Cursor]" \
  --priority p1 \
  --label bug

# Or use Linear web UI
```

**Step 3: Link to Code**

In Linear issue, add:
```
Related Code:
- File: lib/providers/event_provider.dart
- Line: 123
- Branch: current-branch
```

---

## Issue Templates for Cursor Agent

### Feature Request Template (Optimized for Cursor)

```markdown
**Title:** [Feature Name]

**Priority:** P0/P1/P2/P3

**Description:**
[What needs to be built - be specific and detailed]

**Acceptance Criteria:**
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

**Technical Context:**
- File to modify: [path]
- Pattern to follow: [reference existing code]
- Dependencies: [other issues or files]
- Branch name: feature/issue-name

**Testing Requirements:**
- [ ] Unit tests needed
- [ ] Widget tests needed
- [ ] Integration tests needed

**Design Notes:**
- Material 3 design required
- Follow existing theme patterns
- See: lib/theme/app_theme.dart
```

**Why This Format:**
- Cursor agent reads issue description for context
- Technical notes help agent understand codebase
- Acceptance criteria define success
- Branch name ensures consistent naming

### Bug Report Template

```markdown
**Title:** Bug: [Short Description]

**Priority:** P0/P1/P2

**Steps to Reproduce:**
1. Step 1
2. Step 2
3. Step 3

**Expected Behavior:**
[What should happen]

**Actual Behavior:**
[What actually happens]

**Technical Details:**
- File: [path]
- Line: [number]
- Error: [if applicable]

**Branch:** fix/issue-name
```

---

## Best Practices for Cursor Agent

### Writing Issues That Cursor Understands

**Do:**
- ✅ Be specific and detailed in descriptions
- ✅ Include acceptance criteria as checklist
- ✅ Reference existing code patterns
- ✅ Specify file paths when known
- ✅ Include branch naming convention
- ✅ Add technical context and constraints

**Don't:**
- ❌ Vague descriptions ("make it better")
- ❌ Missing acceptance criteria
- ❌ No technical context
- ❌ Unclear requirements

### Example: Good Issue for Cursor

```markdown
Title: Add Sample Test Data System

Description:
Pre-loaded demo conference data for easy app exploration. This will help 
users understand the app's capabilities without needing to import their own 
calendar files.

Acceptance Criteria:
- [ ] Realistic conference schedule with multiple days
- [ ] Include speakers for events
- [ ] Variety of topics and locations
- [ ] Accessible from Settings or first-time user flow
- [ ] Clear indication that it's sample data

Technical Notes:
- Use existing ICS file format
- Store in assets/sample_conference.ics (already exists)
- Extend EventProvider.loadCalendarFromAsset() method
- Follow pattern in lib/screens/settings_screen.dart
- See: lib/providers/event_provider.dart for implementation

Branch: feature/sample-test-data
```

### Example: Bad Issue for Cursor

```markdown
Title: Add sample data

Description:
We need sample data for testing.

[Too vague - Cursor won't know what to build]
```

---

## Automation Ideas

### 1. Auto-Create Branch from Linear

**Script:** `scripts/create-branch-from-linear.sh`

```bash
#!/bin/bash
ISSUE_ID=$1
ISSUE=$(linear show $ISSUE_ID)
BRANCH_NAME=$(echo "$ISSUE" | grep "Branch:" | cut -d' ' -f2)
git checkout -b $BRANCH_NAME
```

**Usage:**
```bash
./scripts/create-branch-from-linear.sh ISSUE-123
```

### 2. Auto-Update Linear on Commit

**Git Hook:** `.git/hooks/post-commit`

```bash
#!/bin/bash
BRANCH=$(git branch --show-current)
if [[ $BRANCH == feature/* ]]; then
  ISSUE_ID=$(echo $BRANCH | sed 's/feature\/issue-//')
  linear comment $ISSUE_ID "Committed: $(git log -1 --pretty=%B)"
fi
```

### 3. Link PR to Linear Issue

In PR description:
```
Fixes Linear issue: ISSUE-123

[Description of changes]
```

Linear will auto-link the PR to the issue.

---

## Best Practices

### 1. Issue Formatting

**Always include:**
- Clear title
- Detailed description
- Acceptance criteria (checklist)
- Technical notes
- Suggested branch name
- Priority and labels

### 2. Branch Naming

**Follow pattern:**
- Features: `feature/issue-123` or `feature/feature-name`
- Bugs: `fix/issue-123` or `fix/bug-name`
- Match Linear issue ID when possible

### 3. Regular Updates

**Update Linear:**
- When starting work (In Progress)
- When blocked (add comment)
- When PR created (In Review)
- When merged (Done)

### 4. Use Cursor for Planning

**Before coding:**
- Ask Cursor to review issue
- Get implementation suggestions
- Understand codebase context
- Plan test strategy

### 5. Link Everything

**In Linear:**
- Link to GitHub branches
- Link to PRs
- Link to related issues
- Link to code files

---

## Troubleshooting

### Linear CLI Not Working

**Check:**
```bash
linear whoami  # Verify authentication
linear auth    # Re-authenticate if needed
```

### Cursor Not Understanding Issue

**Solution:**
- Paste full issue description
- Include acceptance criteria
- Reference specific files
- Provide code examples

### Integration Not Syncing

**Check:**
- GitHub integration enabled in Linear
- Repository connected correctly
- PR descriptions include issue references
- Webhooks configured (if using)

---

## Future Enhancements

### 1. Webhook Integration

Set up Linear webhooks to:
- Auto-create GitHub branches
- Update Linear when PRs merge
- Sync status automatically

### 2. Cursor Extension

Create Cursor extension to:
- Read Linear issues directly
- Create issues from Cursor
- Auto-update Linear on commit

### 3. Automated Testing

Link Linear issues to:
- Test files
- Test results
- Coverage reports

---

## Quick Reference

### Linear Commands

```bash
# List issues
linear list

# Show issue
linear show ISSUE-123

# Create issue
linear create "Title" --priority p0 --label feature

# Update issue
linear update ISSUE-123 --state "In Progress"

# Add comment
linear comment ISSUE-123 "Comment text"
```

### Cursor Prompts

```
# Get issue context
"I need to implement Linear issue [ID]. Here's the details: [paste]"

# Plan implementation
"Based on this Linear issue, create an implementation plan"

# Review against issue
"Review my code against Linear issue [ID] acceptance criteria"
```

---

**Last Updated:** 2025-01-XX  
**Status:** Ready for use  
**Next Steps:** Set up Linear CLI, test workflow, create automation scripts

