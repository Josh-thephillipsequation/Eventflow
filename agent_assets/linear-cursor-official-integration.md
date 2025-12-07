# Linear-Cursor Official Integration Guide

**Official Docs:** [linear.app/integrations/cursor](https://linear.app/integrations/cursor)  
**Status:** ✅ You've already added Linear as a team member - ready to use!

---

## What This Integration Does

The official Linear-Cursor integration allows you to:

1. **Assign issues directly to Cursor** - No manual copying needed
2. **Automatic cloud agents** - Cursor spins up agents to work on tasks
3. **Automatic PRs** - Agent creates PRs when tasks complete
4. **Progress tracking** - Updates flow back to Linear automatically
5. **Multi-issue support** - Cursor can work on multiple issues simultaneously

---

## How to Use

### Assign Issue to Cursor

**Method 1: Assignee Menu**
1. Open any Linear issue
2. Click the **assignee dropdown**
3. Select **"Cursor"** (or "Cursor Agent")
4. Cursor automatically starts working!

**Method 2: Mention @cursor**
1. In issue comments, type: `@cursor`
2. Or write: "Assign this to @cursor"
3. Cursor picks up the issue

### What Happens Next

1. **Cursor Agent Starts:**
   - Reads issue description
   - Understands context from Linear
   - Begins implementation

2. **Progress Updates:**
   - Updates flow to Linear automatically
   - You can see progress in:
     - Linear (issue updates)
     - Cursor web app
     - Your IDE

3. **Completion:**
   - Agent creates a PR
   - PR is linked to Linear issue
   - Issue status updates automatically

---

## Creating Issues for Cursor

### Best Practices

**Write Detailed Descriptions:**
- Be specific about what needs to be built
- Include acceptance criteria
- Reference existing code patterns
- Specify file paths when known

**Include Technical Context:**
- Branch naming convention
- Files to modify
- Patterns to follow
- Dependencies

**Clear Acceptance Criteria:**
- Use checkboxes
- Be specific and testable
- Include edge cases

### Template for Cursor Issues

```markdown
**Description:**
[Detailed description of what needs to be built]

**Acceptance Criteria:**
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

**Technical Notes:**
- File to modify: [path]
- Pattern to follow: [reference]
- Branch: feature/issue-name

**Testing:**
- [ ] Unit tests needed
- [ ] Widget tests needed
```

---

## Current Work Items Ready for Cursor

### Ready to Assign

1. **Generate iPad Screenshots Using Automation**
   - Priority: P0
   - Status: Todo
   - Description: Use screenshot automation to generate proper iPad screenshots
   - Perfect for Cursor - well-defined task with existing automation

2. **Complete App Store Submission**
   - Priority: P0
   - Status: In Progress
   - Description: Final steps for App Store resubmission
   - Can be broken into subtasks for Cursor

### Already Completed (For Reference)

These are done, but good examples of Cursor-ready issues:
- Fix App Store Rejection Issues
- Implement Automated Screenshot Generation
- Update Bundle ID

---

## Workflow Example

### Scenario: Assign "Generate iPad Screenshots" to Cursor

1. **Open Issue in Linear:**
   - Issue: "Generate iPad Screenshots Using Automation"
   - Status: Todo

2. **Assign to Cursor:**
   - Click assignee dropdown
   - Select "Cursor"
   - Issue status changes to "In Progress"

3. **Cursor Works:**
   - Reads issue description
   - Understands: need to run screenshot automation on iPad simulators
   - Executes: `./scripts/screenshot_with_integration_test.sh` for iPad devices
   - Verifies screenshots are proper iPad UI
   - Resizes to App Store dimensions

4. **Completion:**
   - Cursor creates PR with screenshots
   - PR linked to Linear issue
   - Issue marked as "Done" (or "In Review")

5. **You Review:**
   - Check PR in GitHub
   - Verify screenshots look good
   - Merge if approved
   - Issue auto-updates to "Done"

---

## Tips for Success

### 1. Write Clear Issues
- Cursor reads issue description for context
- Be specific and detailed
- Include technical notes

### 2. Use Acceptance Criteria
- Define success clearly
- Use checkboxes
- Make criteria testable

### 3. Reference Existing Code
- Point to similar implementations
- Specify file paths
- Include code patterns to follow

### 4. Break Down Large Issues
- Cursor works best on focused tasks
- Split large features into smaller issues
- Use dependencies to link related work

### 5. Monitor Progress
- Check Linear for updates
- Review Cursor web app
- Watch for PR creation

---

## Troubleshooting

### Cursor Not Appearing in Assignee List

**Solution:**
- Verify integration is installed (admin required)
- Check Cursor Pro/Ultra plan
- Reinstall integration if needed

### Agent Not Starting

**Solution:**
- Check issue has clear description
- Verify issue is not blocked
- Try mentioning `@cursor` in comments

### PR Not Created

**Solution:**
- Check GitHub integration is connected
- Verify repository permissions
- Review Cursor web app for errors

---

## Next Steps

1. **Create Issues in Linear:**
   - Use templates from `linear-current-work-issues.md`
   - Write detailed descriptions
   - Include acceptance criteria

2. **Assign to Cursor:**
   - Use assignee menu or `@cursor` mention
   - Monitor progress
   - Review PRs when complete

3. **Iterate:**
   - Refine issue templates based on results
   - Learn what works best for Cursor
   - Optimize descriptions for better results

---

## Resources

- **Official Docs:** [linear.app/integrations/cursor](https://linear.app/integrations/cursor)
- **Cursor Documentation:** See Cursor's docs for detailed setup
- **Current Work Issues:** `agent_assets/linear-current-work-issues.md`

---

**Status:** ✅ Ready to use - you've already set up Linear as team member!  
**Next:** Create issues and assign to Cursor

