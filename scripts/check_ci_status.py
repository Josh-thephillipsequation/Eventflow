#!/usr/bin/env python3
"""
GitHub Actions Status Checker for Amp Integration
Polls GitHub Actions API to detect CI failures and generate Amp feedback
"""

import requests
import json
import os
import time
from datetime import datetime

def check_github_actions_status():
    """Check GitHub Actions status for the current repository"""
    try:
        # Get current branch and repo info
        repo = "Josh-thephillipsequation/Eventflow"
        branch = os.popen("git rev-parse --abbrev-ref HEAD").read().strip()
        commit = os.popen("git rev-parse HEAD").read().strip()[:8]
        
        print(f"🔍 Checking CI status for {repo}:{branch} ({commit})")
        
        # GitHub API endpoint for workflow runs
        api_url = f"https://api.github.com/repos/{repo}/actions/runs"
        params = {
            "branch": branch,
            "per_page": 5
        }
        
        response = requests.get(api_url, params=params)
        
        if response.status_code == 200:
            runs = response.json().get('workflow_runs', [])
            
            if not runs:
                print("📭 No recent workflow runs found")
                return
            
            latest_run = runs[0]
            status = latest_run.get('status')
            conclusion = latest_run.get('conclusion')
            
            print(f"📊 Latest run: {status} / {conclusion}")
            
            if conclusion == 'failure':
                print("🚨 CI Failure detected!")
                generate_amp_feedback(latest_run, repo, branch, commit)
            elif conclusion == 'success':
                print("✅ All CI checks passed!")
            else:
                print(f"⏳ CI in progress: {status}")
                
        else:
            print(f"❌ Failed to fetch CI status: {response.status_code}")
            
    except Exception as e:
        print(f"❌ Error checking CI status: {e}")

def generate_amp_feedback(run_data, repo, branch, commit):
    """Generate Amp feedback from CI failure"""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M')
    
    feedback = f"""# 🚨 CI Failure Detected - Amp Please Fix

## GitHub Actions Failure Report - {timestamp}

**Repository**: {repo}
**Branch**: {branch}
**Commit**: {commit}
**Workflow**: {run_data.get('name', 'Unknown')}
**Run URL**: {run_data.get('html_url', 'N/A')}
**Started**: {run_data.get('created_at', 'Unknown')}

## 🎯 Action Required

The CI pipeline has failed. Please:

1. **Check the failing workflow** at: {run_data.get('html_url', 'GitHub Actions')}
2. **Download test artifacts** if available
3. **Run tests locally** to see specific failures: `flutter test`
4. **Fix the failing tests** based on error messages
5. **Verify fixes locally** before pushing
6. **Push updated code** to trigger new CI run

## 🔍 Common Issues to Check

- **Test compilation errors** (method not found, import issues)
- **Widget test failures** (missing UI elements, timing issues)
- **Unit test logic errors** (incorrect expectations, state issues)
- **Build failures** (dependency issues, platform problems)

## ✅ Success Criteria

- [ ] All tests pass locally: `flutter test`
- [ ] Static analysis clean: `flutter analyze`
- [ ] Code formatted: `dart format .`
- [ ] Build succeeds: `flutter build ios --no-codesign`

**Amp**: Please read this report and systematically fix the issues. Run the commands above to verify each fix.
"""
    
    # Write feedback for Amp
    with open('AGENT_FEEDBACK.md', 'w') as f:
        f.write(feedback)
    
    print("✅ Amp feedback generated: AGENT_FEEDBACK.md")
    print("🤖 Ready for Amp to process and fix issues!")

if __name__ == "__main__":
    check_github_actions_status()
