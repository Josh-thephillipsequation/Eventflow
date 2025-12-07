# Cursor Web Agents: How They Work

## Overview

**Cursor Web Agents** are cloud-based AI agents that work on tasks assigned from Linear. They operate differently from the local Cursor IDE agent (me) that you're talking to right now.

---

## How Web Agents Access Code

### ❌ **They DON'T Access Your Local Repository**

Web agents **cannot** access files on your local machine. They only work with:
- **Remote GitHub repositories** (pushed code)
- **GitHub API** (issues, PRs, branches)
- **Linear API** (issue details, status updates)

### ✅ **They DO Require GitHub Pushes**

**Yes, you MUST push local work to GitHub** for web agents to see it:

1. **Local Changes → Push to GitHub → Web Agent Sees It**
   ```
   Your Local Repo → git push → GitHub → Web Agent Access
   ```

2. **Workflow:**
   - You work locally in Cursor IDE (with me, the local agent)
   - You push changes to GitHub
   - You assign Linear issue to Cursor web agent
   - Web agent reads from GitHub (not your local files)
   - Web agent creates PR with changes
   - You review and merge

### 🔄 **Two Types of Cursor Agents**

| Type | Where It Runs | Access | Use Case |
|------|--------------|--------|----------|
| **Local Agent** (me) | Your IDE | Local files + GitHub | Real-time coding help, file editing |
| **Web Agent** | Cursor Cloud | GitHub only | Automated task completion, PR creation |

---

## How Web Agents Work

### Step-by-Step Process

1. **You Assign Issue in Linear:**
   - Create/update Linear issue
   - Assign to "Cursor" (web agent)
   - Issue must have clear description

2. **Web Agent Starts:**
   - Reads issue from Linear API
   - Clones repository from GitHub
   - Reads codebase from GitHub (not local)
   - Understands context from issue description

3. **Web Agent Works:**
   - Creates new branch
   - Makes code changes
   - Commits changes
   - Pushes to GitHub

4. **Web Agent Completes:**
   - Creates Pull Request
   - Links PR to Linear issue
   - Updates Linear issue status
   - Notifies you

5. **You Review:**
   - Review PR in GitHub
   - Test changes locally
   - Merge if approved
   - Linear issue auto-updates to "Done"

---

## GitHub MCP Server

### What Is It?

The **GitHub MCP Server** allows Cursor (both local and web agents) to interact with GitHub through the Model Context Protocol (MCP). This gives agents the ability to:
- Read repository contents
- Create/update issues
- Create/manage PRs
- Access commit history
- Read file contents

### Current Status

You mentioned you have a GitHub MCP server but aren't sure if it works. Let's verify!

### How to Check If It Works

**Option 1: Check MCP Resources**
- I can list available MCP resources (I tried earlier, found none)
- If GitHub MCP is working, I should see GitHub-related resources

**Option 2: Test GitHub MCP Functions**
- Try to read a file from GitHub
- Try to list repository contents
- Try to create a test issue

**Option 3: Check Cursor Settings**
- Cursor Settings → Features → MCP
- Look for GitHub MCP server configuration
- Verify it's enabled and configured

### Setup Requirements

If GitHub MCP isn't working, you need:

1. **GitHub Personal Access Token (PAT):**
   - Go to GitHub → Settings → Developer settings → Personal access tokens
   - Create token with `repo` scope (for private repos)
   - Or `public_repo` scope (for public repos)

2. **Configure in Cursor:**
   - Add GitHub MCP server to Cursor settings
   - Provide PAT as authentication
   - Point to your repository

3. **Verify Connection:**
   - Test with simple operations
   - Check for errors in Cursor logs

---

## Workflow Comparison

### Local Agent Workflow (Current - Me)

```
You → Cursor IDE → Local Agent (me) → Edit Local Files → You Commit/Push
```

**Advantages:**
- ✅ Instant access to local files
- ✅ No need to push first
- ✅ Real-time collaboration
- ✅ Can see uncommitted changes

**Limitations:**
- ❌ Can't create PRs automatically
- ❌ Can't update Linear directly (need MCP)
- ❌ Can't work when you're not in IDE

### Web Agent Workflow (Linear Integration)

```
Linear Issue → Assign to Cursor → Web Agent → GitHub Clone → 
Make Changes → Create PR → Update Linear → You Review
```

**Advantages:**
- ✅ Works automatically (no IDE needed)
- ✅ Creates PRs automatically
- ✅ Updates Linear automatically
- ✅ Can work on multiple issues

**Limitations:**
- ❌ Only sees pushed code
- ❌ Can't access local changes
- ❌ Requires GitHub connection
- ❌ May need clearer issue descriptions

---

## Best Practices

### For Local Development (Me)

1. **Work Locally:**
   - Use me for real-time coding help
   - I can see all your local files
   - No need to push first

2. **When to Push:**
   - After completing a feature
   - Before assigning to web agent
   - Before creating PR manually

### For Web Agents

1. **Before Assigning:**
   - ✅ Push all relevant changes to GitHub
   - ✅ Write clear issue descriptions
   - ✅ Include acceptance criteria
   - ✅ Reference existing code patterns

2. **Issue Format:**
   ```markdown
   **Description:**
   [What needs to be built]
   
   **Acceptance Criteria:**
   - [ ] Criterion 1
   - [ ] Criterion 2
   
   **Technical Notes:**
   - File: lib/screens/example.dart
   - Pattern: Follow existing filter implementation
   - Branch: feature/issue-name
   ```

3. **After Assignment:**
   - Monitor Linear for updates
   - Check GitHub for PR creation
   - Review PR when ready
   - Test changes locally before merging

---

## Testing GitHub MCP

Let me try to test if GitHub MCP is working by attempting to access GitHub resources:

**Test 1: List MCP Resources**
- I'll check what MCP resources are available

**Test 2: GitHub API Access**
- Try to read repository information
- Try to list files
- Try to create a test issue (if permissions allow)

**Test 3: Verify Configuration**
- Check if GitHub MCP server is configured
- Verify authentication is working

---

## Troubleshooting

### Web Agent Not Starting

**Possible Causes:**
- Issue description too vague
- GitHub repository not accessible
- Linear integration not properly configured
- Cursor Pro/Ultra plan required

**Solutions:**
- Write more detailed issue descriptions
- Verify GitHub repository is accessible
- Check Linear-Cursor integration status
- Ensure Cursor subscription includes web agents

### GitHub MCP Not Working

**Possible Causes:**
- MCP server not configured
- Missing GitHub PAT
- Incorrect repository URL
- Authentication failed

**Solutions:**
- Configure GitHub MCP in Cursor settings
- Create GitHub PAT with correct scopes
- Verify repository URL is correct
- Test authentication separately

### Web Agent Can't See Changes

**Possible Causes:**
- Changes not pushed to GitHub
- Working on wrong branch
- Repository permissions issue

**Solutions:**
- Push all local changes to GitHub
- Verify branch exists on GitHub
- Check repository access permissions

---

## Next Steps

1. **Verify GitHub MCP:**
   - Check Cursor settings for MCP configuration
   - Test GitHub access
   - Configure if needed

2. **Test Web Agent:**
   - Assign a simple Linear issue to Cursor
   - Monitor progress
   - Review PR when created

3. **Optimize Workflow:**
   - Use local agent (me) for development
   - Use web agent for automated tasks
   - Push regularly to keep GitHub in sync

---

## Summary

- **Web agents** work in the cloud, not locally
- **They require** GitHub pushes to see your code
- **They create PRs** automatically when tasks complete
- **GitHub MCP** enables GitHub API access for agents
- **Local agent (me)** can access local files directly
- **Best practice:** Use local agent for development, web agent for automation

---

**Questions?** Let me know what you'd like to test or configure next!

