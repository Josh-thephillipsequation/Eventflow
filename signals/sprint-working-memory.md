---
ai:
  include_by_default: true
  weight: 0.9
---

# EventFlow - Sprint Working Memory

## 🎯 Sprint Goals (M21-M24)
**Primary**: Build automated CI/CD pipeline from agent interaction to App Store publication
- M21: Automated CI feedback loop (no manual copying)
- M22: 100% test pass rate (fix EventProvider failures)  
- M23: iOS build automation + code signing
- M24: App Store Connect integration

## 🔄 Active Branches/PRs
- **Current Branch**: `feature/core-ci-testing-foundation`
- **Active PR**: Core CI/Testing Foundation + Interactive Webhook System
- **Status**: Live PR with comprehensive testing infrastructure

## ❌ Current Failing Tests
- **5/10 EventProvider tests**: async loading, state management issues
- **Widget test timing**: splash screen timer conflicts
- **UI overflow**: 12px overflow in import screen during tests
- **Provider lifecycle**: disposal issues in widget tests

## 📱 Next Deployment Target
- **Device**: iPhone via `flutter run --release -d "00008140-0002248A0E12801C"`
- **Validation**: Human-in-the-loop testing after each feature
- **Pipeline Goal**: Zero manual steps from code → App Store

## 🚨 Immediate Blockers
1. **Dependency conflict**: flutter_native_splash version incompatibility
2. **Manual CI feedback**: GitHub Actions not auto-updating AGENT_FEEDBACK.md
3. **Test instability**: Provider tests need async/lifecycle fixes

---
*36-hour Amp AI development story continues - automation pipeline is the next chapter*
