# Cursor Workflow Guide for EventFlow

This document describes how to use Cursor effectively for EventFlow development, including integration with Linear for task management.

## Overview

**Previous System:** AMP AI (deprecated)  
**Current System:** Cursor + Linear  
**Project:** EventFlow - Conference agenda management app  
**Tech Stack:** Flutter/Dart, Material 3, iOS/Android

---

## Cursor Basics for EventFlow

### Key Features

1. **Code Understanding:**
   - Cursor understands the entire codebase context
   - Can reference files using code citations
   - Maintains context across conversations

2. **File Navigation:**
   - Use `Cmd+P` (Mac) or `Ctrl+P` (Windows/Linux) to quickly open files
   - Use `Cmd+Shift+F` to search across codebase
   - Use `Cmd+Click` to jump to definitions

3. **AI Chat:**
   - Access via `Cmd+L` or chat panel
   - Can reference specific files and code sections
   - Maintains conversation context

### Project-Specific Context

Cursor automatically loads:
- `AGENTS_TLDR.md` - Quick reference (high weight)
- `AGENTS.md` - Comprehensive guide (reference)
- `agent_assets/backlog.md` - Current priorities
- `agent_assets/current-status.md` - Project status

**Key Files Cursor Should Know:**
- `lib/main.dart` - App entry point
- `lib/providers/event_provider.dart` - State management
- `lib/screens/` - All UI screens
- `lib/theme/app_theme.dart` - Material 3 theming
- `test/` - Test suite (92+ tests)

---

## Workflow: Linear → Cursor → Implementation

### Option A: Official Integration (Recommended!)

**Step 1: Create Issue in Linear**
- Write detailed description
- Include acceptance criteria
- Add technical context

**Step 2: Assign to Cursor**
- Click assignee dropdown
- Select "Cursor"
- Cursor agent automatically starts!

**Step 3: Monitor Progress**
- Track in Linear (auto-updates)
- Check Cursor web app
- View in IDE

**Step 4: Review PR**
- Cursor creates PR automatically
- Review and merge
- Issue updates to "Done"

**Official Docs:** [linear.app/integrations/cursor](https://linear.app/integrations/cursor)

### Option B: Manual Workflow (If Needed)

**Step 1: Get Task from Linear**

1. **Open Linear:**
   - Check assigned issues or pick from backlog
   - Review issue description, acceptance criteria, labels

2. **Copy Issue Context:**
   - Issue title and ID
   - Description and acceptance criteria
   - Priority and labels
   - Estimated effort

3. **Share with Cursor:**
   - Open Cursor chat (`Cmd+L`)
   - Paste issue details
   - Ask: "I need to implement [issue title]. Here's the Linear issue: [paste details]"

### Step 2: Plan with Cursor

**Example Prompt:**
```
I need to implement M29: Sample Test Data System.

From Linear:
- Priority: P0
- Estimate: 2-3 hours
- Description: Pre-loaded demo conference data for easy app exploration
- Acceptance Criteria:
  - Realistic conference schedule with multiple days
  - Include speakers for events
  - Variety of topics and locations
  - Accessible from Settings or first-time user flow

Can you:
1. Review the current codebase structure
2. Identify where sample data should be stored
3. Create a plan for implementation
4. Show me the relevant files I'll need to modify
```

### Step 3: Implementation

1. **Create Branch:**
   ```bash
   git checkout -b feature/sample-test-data
   ```

2. **Work with Cursor:**
   - Ask Cursor to implement specific parts
   - Use code citations to reference existing patterns
   - Request code reviews before committing

3. **Test:**
   ```bash
   flutter test
   flutter analyze --fatal-infos
   ```

4. **Verify:**
   - Run tests locally
   - Check CI passes
   - Test on device if UI changes

### Step 4: Update Linear

1. **Mark Progress:**
   - Update issue status: In Progress → In Review → Done
   - Add comments with implementation notes
   - Link PR when created

2. **Close Issue:**
   - Mark as Done when merged
   - Add completion notes
   - Update roadmap if needed

---

## Cursor Commands & Shortcuts

### Essential Shortcuts

- `Cmd+L` - Open AI chat
- `Cmd+K` - Inline AI edit (select code first)
- `Cmd+Shift+L` - Composer (multi-file edits)
- `Cmd+P` - Quick file open
- `Cmd+Shift+F` - Search codebase
- `Cmd+Click` - Go to definition

### Useful Chat Prompts

**Code Understanding:**
```
How does the EventProvider manage state? Show me the key methods.
```

**Implementation Help:**
```
I need to add a new filter option. Looking at the existing filter implementation in [file], can you help me add [specific feature]?
```

**Code Review:**
```
Review this code for:
1. Material 3 design consistency
2. Error handling
3. Test coverage needs
```

**Refactoring:**
```
Refactor this function to follow the patterns used in [other file]. Make sure it's testable.
```

---

## Integration with Linear

### Linear Issue Format for Cursor

When creating Linear issues, include:

1. **Clear Title:** Descriptive and specific
2. **Detailed Description:** What needs to be done
3. **Acceptance Criteria:** Checklist of requirements
4. **Technical Notes:** Implementation hints
5. **Labels:** Priority, type, area
6. **Branch Name:** Suggested git branch

**Example Good Issue:**
```
Title: Sample Test Data System
Priority: P0
Labels: p0, feature, ui

Description:
Pre-loaded demo conference data for easy app exploration.

Acceptance Criteria:
- [ ] Realistic conference schedule with multiple days
- [ ] Include speakers for events
- [ ] Accessible from Settings

Technical Notes:
- Use existing ICS file format
- Store in assets/calendars/
- Include 20-30 events

Branch: feature/sample-test-data
```

### Linear CLI Integration (Optional)

If you have Linear CLI set up:

```bash
# List issues
linear list

# Get issue details
linear show ISSUE-123

# Create issue from command line
linear create "Title" --priority p0 --label feature
```

### Webhook Integration (Future)

Set up Linear webhooks to:
- Auto-create GitHub branches from Linear issues
- Update Linear when PRs are merged
- Sync status between Linear and GitHub

---

## Testing Workflow

### Before Committing

1. **Run Tests:**
   ```bash
   flutter test
   ```

2. **Check Analysis:**
   ```bash
   flutter analyze --fatal-infos
   ```

3. **Format Code:**
   ```bash
   dart format lib test
   ```

4. **Run CI Locally:**
   ```bash
   ./scripts/run_ci_locally.sh
   ```

### With Cursor

Ask Cursor:
```
Before I commit, can you:
1. Review my changes for common issues
2. Suggest any missing tests
3. Check for Material 3 consistency
4. Verify error handling
```

---

## Code Style & Patterns

### Material 3 First

Always ask Cursor to:
- Use Material 3 components
- Follow theme from `lib/theme/app_theme.dart`
- Use semantic color roles
- Maintain consistent spacing (8px multiples)

**Example:**
```
Create a new screen following Material 3 design. Use the theme from app_theme.dart and follow the patterns in [existing screen].
```

### State Management

- Use `EventProvider` for global state
- Use `StatefulWidget` for local state
- Use `Consumer<EventProvider>` for reactive UI

**Example:**
```
Add a new filter option to EventProvider. Follow the existing filter pattern and make sure it works with the current UI.
```

### Testing

- Write tests alongside code
- Use existing test patterns
- Mock SharedPreferences for provider tests

**Example:**
```
Write tests for this new feature. Follow the patterns in test/unit/event_provider_test.dart.
```

---

## Common Workflows

### Adding a New Feature

1. **Get Issue from Linear**
2. **Plan with Cursor:**
   ```
   I need to implement [feature]. Review the codebase and create an implementation plan.
   ```
3. **Create Branch:** `feature/feature-name`
4. **Implement with Cursor's help**
5. **Write Tests**
6. **Run CI**
7. **Update Linear**

### Fixing a Bug

1. **Get Issue from Linear**
2. **Reproduce Issue**
3. **Ask Cursor:**
   ```
   This bug is happening: [description]. Can you help me find where in the code this might be occurring?
   ```
4. **Fix with Cursor**
5. **Add Test for Bug**
6. **Update Linear**

### Refactoring

1. **Identify Code to Refactor**
2. **Ask Cursor:**
   ```
   Refactor [file/function] to follow [pattern]. Make sure all tests still pass.
   ```
3. **Review Changes**
4. **Run Tests**
5. **Update Documentation**

---

## Troubleshooting

### Cursor Not Understanding Context

- **Solution:** Explicitly reference files:
  ```
  Looking at lib/providers/event_provider.dart, how does [feature] work?
  ```

### Code Citations Not Working

- **Solution:** Use file paths directly:
  ```
  In lib/screens/all_events_screen.dart, I need to add [feature]
  ```

### Integration Issues

- **Check:** Linear issue format
- **Verify:** Branch naming matches Linear
- **Update:** current-status.md with progress

---

## Best Practices

1. **Always Start with Linear:**
   - Get issue context
   - Understand requirements
   - Check dependencies

2. **Use Cursor for Planning:**
   - Ask for implementation plans
   - Request code reviews
   - Get suggestions

3. **Test Early and Often:**
   - Write tests as you code
   - Run tests before committing
   - Fix failures immediately

4. **Update Linear Regularly:**
   - Mark progress
   - Add notes
   - Link PRs

5. **Follow Existing Patterns:**
   - Use Cursor to understand existing code
   - Follow Material 3 design
   - Maintain consistency

---

## Migration from AMP

### Key Differences

| AMP | Cursor |
|-----|--------|
| Separate agent system | Integrated IDE |
| Manual file references | Automatic context |
| Limited code understanding | Full codebase awareness |
| External workflow | Native workflow |

### What Changed

- **No more:** Manual file pasting
- **No more:** Separate agent commands
- **Now:** Direct code editing in IDE
- **Now:** Automatic context loading
- **Now:** Better code understanding

### What Stayed the Same

- Linear for task management
- GitHub for version control
- Flutter/Dart stack
- Material 3 design
- Testing requirements

---

## Next Steps

1. **Set Up Linear Integration:**
   - Create Linear project
   - Import backlog (see `linear-migration-guide.md`)
   - Set up labels and priorities

2. **Familiarize with Cursor:**
   - Try basic commands
   - Test code understanding
   - Practice with small changes

3. **Establish Workflow:**
   - Linear → Cursor → Implementation
   - Regular updates
   - Test before commit

4. **Iterate:**
   - Refine workflow
   - Add automation
   - Improve documentation

---

**Last Updated:** 2025-01-XX  
**Status:** Active workflow  
**Maintained By:** Development team

