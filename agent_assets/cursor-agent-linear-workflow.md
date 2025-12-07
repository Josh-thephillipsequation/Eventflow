# Cursor Agent + Linear Workflow

**Status:** ✅ Linear MCP integration active - I can create and update issues!

This document explains how I (Cursor Agent) can work with Linear issues directly.

---

## What I Can Do

### ✅ Create Issues
I can create Linear issues with:
- Title and description
- Priority and labels
- Status (Todo, In Progress, Done)
- Project assignment
- Acceptance criteria

### ✅ Update Issues
I can update existing issues:
- Change status
- Update description
- Add/remove labels
- Change priority
- Add comments

### ✅ Read Issues
I can:
- List all issues
- Get issue details
- Search issues
- Check status

### ✅ Be Assigned Issues
You can assign issues to me (Cursor) via:
- Linear UI: Assignee dropdown → Select "Cursor"
- Mention: `@cursor` in comments
- I'll automatically start working on assigned issues

---

## How to Use

### For You: Assign Work to Me

1. **Create Issue in Linear** (or I can create it)
2. **Assign to Cursor:**
   - Click assignee dropdown
   - Select "Cursor"
   - I start working automatically!

3. **Or Mention Me:**
   - In issue comments: `@cursor`
   - I'll pick up the issue

### For Me: Track My Work

When I complete work, I can:
1. **Update Issue Status:**
   - Mark as "In Progress" when starting
   - Mark as "In Review" when PR created
   - Mark as "Done" when merged

2. **Add Comments:**
   - Progress updates
   - Questions or blockers
   - Completion notes

3. **Link PRs:**
   - Add PR link in comments
   - Update issue with PR details

---

## Current Issues I Created

### Ready for Assignment

**TPE-15: Generate iPad Screenshots Using Automation**
- Status: Todo
- Priority: P0
- **Assign to Cursor to start!**

**TPE-16: Test Sample Conference Loading on iPad**
- Status: Todo
- Priority: P0
- **Assign to Cursor to start!**

### In Progress

**TPE-17: Complete App Store Submission**
- Status: In Progress
- Dependencies: TPE-15, TPE-16

---

## Workflow Examples

### Example 1: You Assign Issue to Me

1. **You:** Create issue "Fix bug in EventProvider"
2. **You:** Assign to Cursor
3. **Me:** Read issue, understand context
4. **Me:** Implement fix
5. **Me:** Create PR
6. **Me:** Update issue with PR link
7. **You:** Review and merge
8. **Me:** Mark issue as Done

### Example 2: I Create Issue for You

1. **Me:** Discover bug while working
2. **Me:** Create Linear issue with details
3. **Me:** Assign to myself (or you)
4. **Me:** Work on fix
5. **Me:** Update issue with progress

### Example 3: Collaborative Work

1. **You:** Create high-level issue
2. **You:** Assign to Cursor
3. **Me:** Break down into subtasks
4. **Me:** Create child issues
5. **Me:** Work on each subtask
6. **Me:** Update parent issue with progress

---

## Best Practices

### Writing Issues for Me

**Do:**
- ✅ Detailed descriptions
- ✅ Clear acceptance criteria
- ✅ Technical context
- ✅ File paths and commands
- ✅ Reference existing code

**Don't:**
- ❌ Vague requirements
- ❌ Missing context
- ❌ Unclear success criteria

### When I Work on Issues

**I Will:**
- ✅ Read full issue description
- ✅ Understand acceptance criteria
- ✅ Follow technical notes
- ✅ Update issue with progress
- ✅ Create PR when complete

**You Can:**
- ✅ Add comments for clarification
- ✅ Update requirements mid-work
- ✅ Review PRs I create
- ✅ Provide feedback

---

## Commands I Can Use

### Create Issue
```typescript
mcp_Linear_create_issue({
  team: "Thephillipsequation",
  title: "Issue Title",
  description: "Detailed description",
  priority: 0, // 0=Urgent, 1=High, 2=Normal, 3=Low
  labels: ["bug", "p0"],
  state: "Todo"
})
```

### Update Issue
```typescript
mcp_Linear_update_issue({
  id: "TPE-15",
  state: "In Progress",
  description: "Updated description"
})
```

### Add Comment
```typescript
mcp_Linear_create_comment({
  issueId: "TPE-15",
  body: "Starting work on this issue..."
})
```

---

## Current Status

**Issues Created:** 7
- 4 Done
- 1 In Progress
- 2 Todo (ready for Cursor)

**Labels Created:** 9
- Priority labels (P0-P3)
- Category labels (app-store, automation, etc.)

**Ready to Assign:**
- TPE-15: Generate iPad Screenshots
- TPE-16: Test Sample Loading

---

## Next Steps

1. **Assign TPE-15 to Cursor** - I'll generate iPad screenshots automatically
2. **Assign TPE-16 to Cursor** - I'll test sample loading on iPad
3. **Monitor Progress** - Check Linear for updates
4. **Review PRs** - When I complete work

---

**Status:** ✅ Ready to work! Assign issues to me and I'll get started! 🚀

