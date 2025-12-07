#!/bin/bash
# Helper script to create Linear issues via CLI
# Requires Linear CLI: npm install -g @linear/cli

set -e

echo "📋 Linear Issue Creation Helper"
echo "=============================="
echo ""

# Check if Linear CLI is installed
if ! command -v linear &> /dev/null; then
  echo "❌ Linear CLI not found"
  echo ""
  echo "Install it with:"
  echo "  npm install -g @linear/cli"
  echo ""
  echo "Then authenticate:"
  echo "  linear auth"
  echo ""
  exit 1
fi

# Check authentication
if ! linear whoami &> /dev/null; then
  echo "❌ Not authenticated with Linear"
  echo ""
  echo "Run: linear auth"
  exit 1
fi

echo "✅ Linear CLI ready"
echo ""

# Function to create issue
create_issue() {
  local title=$1
  local description=$2
  local priority=$3
  local labels=$4
  local status=$5
  
  echo "Creating: $title"
  
  linear create "$title" \
    --description "$description" \
    --priority "$priority" \
    --label "$labels" \
    --state "$status" || {
    echo "⚠️  Failed to create issue (may need manual creation)"
    return 1
  }
  
  echo "✅ Created"
  echo ""
}

# Read issues from the markdown file and create them
echo "Creating issues from agent_assets/linear-current-work-issues.md..."
echo ""

# Issue 1: App Store Rejection Fixes
create_issue \
  "Fix App Store Rejection Issues (v1.0.0)" \
  "Fixed two App Store rejection issues:
1. Sample conference loading bug - events not appearing after import on iPad
2. iPad screenshots showing stretched iPhone images

Changes Made:
- Enhanced error handling in EventProvider.loadCalendarFromAsset()
- Added validation for parsed events
- Improved UI error messages in Settings and Import screens
- Created iPad screenshot guide

Files Modified:
- lib/providers/event_provider.dart
- lib/screens/settings_screen.dart
- lib/screens/import_calendar_screen.dart" \
  "p0" \
  "bug,app-store" \
  "Done"

# Issue 2: Automated Screenshots
create_issue \
  "Implement Automated Screenshot Generation" \
  "Created comprehensive screenshot automation system to eliminate manual screenshot work.

Implementation:
- Fastlane integration
- Flutter integration tests
- Shell scripts
- Resize scripts
- Complete documentation

Benefits:
- Reduces screenshot time from 2-3 hours to 5 minutes
- Supports all required device sizes
- Automatically captures all main screens" \
  "p1" \
  "feature,automation,infrastructure" \
  "Done"

# Issue 3: Bundle ID Update
create_issue \
  "Update Bundle ID for App Store Submission" \
  "Updated bundle ID from com.joshua.eventflow to com.thephillipsequation.eventflow.

Changes:
- Updated all 12 occurrences in iOS project
- Verified build works with new bundle ID" \
  "p0" \
  "app-store,config" \
  "Done"

# Issue 4: Test Fixes
create_issue \
  "Fix Performance Test Failures" \
  "Fixed failing performance tests by adding proper SharedPreferences mocking.

All 92+ tests now passing." \
  "p1" \
  "bug,testing" \
  "Done"

# Issue 5: App Store Submission
create_issue \
  "Complete App Store Submission (v1.0.0 Build 7)" \
  "Preparing for App Store resubmission after fixing rejection issues.

Tasks:
- Test sample conference loading on iPad
- Create proper iPad screenshots
- Increment build number to 7
- Build and upload IPA
- Submit for review" \
  "p0" \
  "app-store,release" \
  "In Progress"

# Issue 6: iPad Screenshots
create_issue \
  "Generate iPad Screenshots Using Automation" \
  "Use screenshot automation to generate proper iPad screenshots for all required sizes.

Tasks:
- Run automation on iPad simulators
- Verify screenshots show proper iPad UI
- Resize to exact App Store dimensions
- Upload to App Store Connect" \
  "p0" \
  "app-store,automation" \
  "Todo"

echo "✅ All issues created!"
echo ""
echo "Next steps:"
echo "1. Review issues in Linear"
echo "2. Add any missing details"
echo "3. Link to GitHub branches/PRs"
echo "4. Set up dependencies between issues"

