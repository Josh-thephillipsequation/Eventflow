---
ai.include_by_default: false  
ai.profiles: [ci]
ai.weight: 0.3
---

# CI/CD and Testing Automation

**Mission Critical Pipeline**: Agent Changes → Local Testing → GitHub Actions → iOS Build → TestFlight → App Store

## Current Status
- ✅ Basic CI/testing foundation implemented
- ⚠️ CI feedback loop needs full automation (M21)
- ⚠️ Test failures must be resolved (M22) 
- 🚧 iOS build automation needed (M23)
- 🚧 App Store Connect integration needed (M24)

## GitHub Actions Configuration
- **Workflow:** `.github/workflows/flutter.yml`
- **Webhook Server:** VS Code → Command Palette → "Start Webhook Server for Amp"
- **Auto Feedback:** `python3 scripts/auto_ci_feedback.py`

## CI Commands

### Local CI Testing (CRITICAL)
```bash
# REQUIRED: Run GitHub Actions locally before pushing
./scripts/run_ci_locally.sh

# Or run individual CI steps manually:
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos
flutter test --coverage
flutter build ios --no-codesign --debug
flutter build apk --debug
```

### Code Quality
```bash
flutter analyze
dart format lib/ test/
flutter pub get
flutter clean
```

### Build & Deploy
```bash
# PREFERRED: Deploy to iPhone for testing
flutter run --release -d "00008140-0002248A0E12801C"

# Release builds
flutter build ios --release
flutter build apk --release
```

## CI/CD Rules
- **CRITICAL: No feature is complete unless CI tests pass**
- **Run GitHub Actions locally before pushing**
- **Human-in-the-loop testing**: Deploy each feature to iPhone before next feature
- **Agent feedback loop**: Check `AGENT_FEEDBACK.md` for current failures

## Key Files
- **CI Feedback:** `AGENT_FEEDBACK.md` (current test failures)
- **Local CI:** `./scripts/run_ci_locally.sh` (run before pushing)
- **Validation:** `./scripts/validate_handoff.sh` (must show 99%+)
