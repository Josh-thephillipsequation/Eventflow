---
ai.include_by_default: false  
ai.profiles: [ci]
ai.weight: 0.3
---

# CI/CD and Testing Automation

**Mission Critical Pipeline**: Agent Changes → Local Testing → GitHub Actions → iOS Build → TestFlight → App Store

## Current Status
- ✅ CI/testing foundation implemented and working
- ✅ All tests passing (92+ tests)
- ✅ Code analysis clean
- ✅ Build verification working
- 🚧 iOS build automation with signing (future enhancement)
- 🚧 TestFlight integration (future enhancement)
- 🚧 App Store Connect automation (future enhancement)

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
- **Test before commit**: Always run `flutter test` and `flutter analyze`
- **Material 3 consistency**: Verify design follows theme guidelines
- **Update Linear**: Mark issues as done when CI passes

## Pipeline Enhancement Opportunities

### Future Enhancements (Post v1.0)
1. **Automated iOS Build with Signing**
   - Add code signing to CI
   - Automatic TestFlight uploads
   - Requires Apple Developer certificates in secrets

2. **TestFlight Integration**
   - Auto-upload builds to TestFlight
   - Notify team on new builds
   - Track beta feedback

3. **App Store Connect Automation**
   - Auto-submit for review
   - Version management
   - Release automation

4. **Enhanced Reporting**
   - Coverage reports in PR comments
   - Test result summaries
   - Build status notifications

## Key Files
- **CI Feedback:** `AGENT_FEEDBACK.md` (current test failures)
- **Local CI:** `./scripts/run_ci_locally.sh` (run before pushing)
- **Validation:** `./scripts/validate_handoff.sh` (must show 99%+)
