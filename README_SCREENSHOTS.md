# 📸 Automated Screenshot Generation

**No more manual screenshots!** This project includes automated screenshot generation for all App Store requirements.

## Quick Start

### Option 1: Integration Tests (Recommended - Most Reliable)
```bash
./scripts/screenshot_with_integration_test.sh
```

### Option 2: Fastlane (Best for CI/CD)
```bash
fastlane ios screenshots
```

### Option 3: Shell Scripts (Simple & Flexible)
```bash
./scripts/automate_screenshots.sh
```

## What Gets Captured

Automatically captures screenshots for:
- ✅ iPhone 15 Pro Max (6.7")
- ✅ iPhone 15 Pro (6.1")
- ✅ iPhone 14 Pro Max (6.7")
- ✅ iPhone 11 Pro Max (6.5")
- ✅ iPad Pro 12.9"
- ✅ iPad Pro 11"
- ✅ iPad Air 5th gen

Screenshots include:
1. Import Screen
2. All Events
3. My Agenda
4. Insights
5. Fun Tab
6. Settings

## Full Documentation

See `agent_assets/screenshot-automation-guide.md` for complete details.

## Resize for App Store

After generating, resize to exact App Store dimensions:
```bash
./scripts/resize_screenshots_for_app_store.sh
```

## Upload to App Store Connect

**Via Fastlane:**
```bash
fastlane ios upload_screenshots
```

**Or manually:**
- Go to App Store Connect
- Upload from `screenshots/app_store_ready/` directory

---

**Time saved:** ~2-3 hours per release → **5 minutes automated** 🚀

