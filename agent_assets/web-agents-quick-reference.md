# Cursor Web Agents: Quick Reference

## Your Questions Answered

### Q: How do web agents work?

**A:** Cursor web agents are cloud-based AI agents that:
- Run in Cursor's cloud infrastructure (not on your machine)
- Work on tasks assigned from Linear
- Automatically create PRs when tasks complete
- Update Linear issues with progress

### Q: How do they have access to the local repo?

**A: They DON'T!** Web agents **cannot** access your local repository. They only work with:
- **GitHub repositories** (remote, pushed code)
- **GitHub API** (for reading/writing code)
- **Linear API** (for issue details)

### Q: Do they depend on us having our local work pushed to GitHub?

**A: YES!** Web agents **require** you to push local work to GitHub:
- They clone from GitHub (not your local machine)
- They only see code that's been pushed
- Uncommitted/unpushed changes are invisible to them

### Q: GitHub MCP Server - does it work?

**A: Let's check!** I don't currently see GitHub MCP functions available, which suggests:
- It might not be configured yet
- It might need authentication setup
- It might need to be enabled in Cursor settings

---

## Workflow Diagram

```
┌─────────────────┐
│  You (Local)    │
│  + Local Agent  │  ← Can see local files
└────────┬────────┘
         │
         │ git push
         ▼
┌─────────────────┐
│    GitHub       │  ← Web agents read from here
└────────┬────────┘
         │
         │ Assign issue
         ▼
┌─────────────────┐
│  Linear Issue   │
│  → Assign Cursor│
└────────┬────────┘
         │
         │ Web agent starts
         ▼
┌─────────────────┐
│  Cursor Web     │  ← Clones from GitHub
│  Agent (Cloud)  │  ← Makes changes
└────────┬────────┘
         │
         │ Creates PR
         ▼
┌─────────────────┐
│  GitHub PR      │
│  → You Review   │
└─────────────────┘
```

---

## Key Differences

| Feature | Local Agent (Me) | Web Agent |
|---------|-----------------|-----------|
| **Location** | Your IDE | Cursor Cloud |
| **Access** | Local files + GitHub | GitHub only |
| **When Active** | When you're in IDE | Runs automatically |
| **PR Creation** | Manual (you do it) | Automatic |
| **Linear Updates** | Via MCP (if configured) | Automatic |
| **Sees Uncommitted** | ✅ Yes | ❌ No |

---

## Testing GitHub MCP

To verify if GitHub MCP is working:

1. **Check Cursor Settings:**
   - Cursor → Settings → Features → MCP
   - Look for "GitHub MCP Server"
   - Verify it's enabled

2. **Check Authentication:**
   - Need GitHub Personal Access Token (PAT)
   - Token needs `repo` scope (for private repos)
   - Or `public_repo` scope (for public repos)

3. **Test Access:**
   - Try to list repository contents
   - Try to read a file from GitHub
   - Try to create a test issue

4. **Current Status:**
   - I don't see GitHub MCP functions available
   - This suggests it needs configuration

---

## Recommended Workflow

### For Local Development (Use Me)
1. Work with local agent (me) in Cursor IDE
2. I can see all your local files
3. Make changes, test locally
4. Commit and push when ready

### For Automated Tasks (Use Web Agent)
1. Push all relevant changes to GitHub first
2. Create detailed Linear issue
3. Assign to Cursor web agent
4. Web agent works automatically
5. Review PR when created

---

## Next Steps

1. **Verify GitHub MCP:**
   - Check Cursor settings for MCP configuration
   - Set up GitHub PAT if needed
   - Test GitHub access

2. **Test Web Agent:**
   - Push current work to GitHub
   - Assign a simple Linear issue to Cursor
   - Monitor progress

3. **Optimize:**
   - Use local agent for development
   - Use web agent for automation
   - Keep GitHub in sync

---

**Full Guide:** See `agent_assets/cursor-web-agents-guide.md` for complete details.

