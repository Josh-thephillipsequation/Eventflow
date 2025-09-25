---
ai.include_by_default: true
ai.profiles: [default, ci, testing, design]
ai.weight: 1.0
---

# EventFlow - AI Agent Quick Reference

**App:** EventFlow (Flutter iOS/Android conference agenda tracker)  
**Company:** thephillipsequation llc  
**Mission:** M21-M24 - Automated CI/CD pipeline from agent changes to App Store

## 🚨 Current Focus: CI/CD Pipeline Automation
Building mission-critical automation: Agent Changes → Testing → GitHub Actions → iOS Build → App Store

## Essential Commands

```bash
# Deploy to iPhone (human-in-the-loop testing)
flutter run --release -d "00008140-0002248A0E12801C"

# Run all tests with coverage
flutter test --coverage

# Code analysis
flutter analyze --fatal-infos

# Run CI locally before pushing
./scripts/run_ci_locally.sh

# iOS release build
flutter build ios --release
```

## Quick Navigation

- **CI/Testing:** `agents/ci.md` - GitHub Actions, test failures, automation
- **Design System:** `agents/design.md` - Material 3, UX patterns, components
- **iOS Development:** `agents/ios.md` - Code signing, deployment, App Store
- **Testing Strategy:** `agents/testing.md` - Widget tests, integration tests
- **Current Sprint:** `signals/current-status-slim.md` - Live dev status

## Project Structure
- `lib/` - Flutter source code (Material 3 UI)
- `agent_assets/` - Planning docs, backlog, specifications
- `test/` - Widget and unit tests (17+ tests)
- `scripts/` - CI automation scripts

**CRITICAL:** Check `AGENT_FEEDBACK.md` for current test failures before starting work.

**Backlog:** Always update `agent_assets/backlog.md` first when adding features.
