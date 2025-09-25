---
ai:
  include_by_default: false
  weight: 0.2
---

# 🚨 Amp: Live GitHub Actions Failure - Fix Required

## Real CI Failure Report - 2025-09-24

### GitHub Actions Failure Details
- **Repository**: Josh-thephillipsequation/Eventflow
- **Branch**: feature/core-ci-testing-foundation
- **Status**: ❌ FAILED at dependency resolution
- **Error Type**: Dependency version conflict

### Specific Error Message
```
Because every version of flutter_test from sdk depends on path 1.9.0 and 
flutter_native_splash 2.4.6 depends on path ^1.9.1, flutter_test from sdk 
is incompatible with flutter_native_splash 2.4.6.

So, because conference_agenda_tracker depends on both flutter_native_splash ^2.4.6 
and flutter_test from sdk, version solving failed.
```

### Root Cause Analysis
- **flutter_test** (SDK) requires `path 1.9.0` exactly
- **flutter_native_splash 2.4.6** requires `path ^1.9.1` (1.9.1 or higher)
- **Version conflict** prevents dependency resolution
- **Suggested fix**: Downgrade flutter_native_splash to ^2.4.4

## 🎯 Amp Instructions

### Fix Command (Provided by GitHub Actions)
```bash
flutter pub add flutter_native_splash:^2.4.4
```

### Verification Steps
```bash
# 1. Fix the dependency version
flutter pub add flutter_native_splash:^2.4.4

# 2. Verify dependencies resolve
flutter pub get

# 3. Run local CI to confirm fix
./scripts/run_ci_locally.sh

# 4. Test that splash screen still works
flutter test test/widget_test.dart
```

### Files to Check
- **pubspec.yaml** - Update flutter_native_splash version constraint
- **pubspec.lock** - Verify new versions resolved correctly

## ✅ Success Criteria
- [ ] Dependencies resolve without conflicts: `flutter pub get`
- [ ] All tests pass: `flutter test`
- [ ] Static analysis clean: `flutter analyze`
- [ ] Local CI script passes: `./scripts/run_ci_locally.sh`
- [ ] Splash screen functionality preserved

**Amp**: This is a simple dependency version fix. Please update pubspec.yaml and verify the fix works.
