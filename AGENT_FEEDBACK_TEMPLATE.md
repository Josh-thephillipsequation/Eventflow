# Agent Feedback Template

This file provides a template for test reports that can be fed back to agents for automated issue resolution.

## How to Use This Template

When tests fail, copy this template to `AGENT_FEEDBACK.md` in the root directory and fill in the details. Agents can then read this file and automatically fix the issues.

---

# Test Failure Report - [DATE]

## 🚨 Failed Tests Summary

### Test Run Details
- **Branch**: [branch-name]
- **Commit**: [commit-hash]
- **Flutter Version**: [flutter-version]
- **Platform**: [iOS/Android/both]
- **Test Type**: [unit/widget/integration/golden]

### Failures Found
- **Total Tests**: [number]
- **Failed**: [number] 
- **Passed**: [number]
- **Coverage**: [percentage]%

## 📋 Specific Test Failures

### [Test Category - e.g., Widget Tests]

**Test**: `test/widget/event_card_test.dart`
**Error**: [exact error message]
**Expected**: [what should happen]
**Actual**: [what actually happened]
**File**: [file where fix needed]
**Line**: [approximate line number if known]

### [Test Category - e.g., Unit Tests]

**Test**: `test/unit/calendar_service_test.dart`  
**Error**: [exact error message]
**Expected**: [what should happen]
**Actual**: [what actually happened]
**File**: [file where fix needed]

## 📊 Coverage Issues

**Low Coverage Files** (< 80%):
- `lib/models/calendar_event.dart` - [coverage]%
- `lib/services/calendar_service.dart` - [coverage]%

**Missing Tests For**:
- [ ] EventProvider state management
- [ ] ICS parsing edge cases
- [ ] Timezone conversion logic

## 🎯 Agent Instructions

### Priority Actions Needed
1. **Fix failing tests** in order of priority (widget → unit → integration)
2. **Add missing test coverage** for files below 80%
3. **Update golden files** if UI changes are intentional
4. **Run `flutter test --coverage`** to verify fixes

### Command to Run Tests
```bash
# Run all tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget/event_card_test.dart

# Update golden files (if UI changes are intentional)
flutter test --update-goldens
```

### Expected Output Location
- **Test Results**: `test_reports/test_results.json`
- **Coverage Report**: `coverage/lcov.info`
- **Golden Diffs**: `test/golden_failures/`

## ✅ Success Criteria
- [ ] All tests pass
- [ ] Code coverage > 80%
- [ ] No golden test failures (or updated with approval)
- [ ] Build succeeds on iOS and Android
- [ ] No new security vulnerabilities introduced

---

## Notes for Human Reviewer

**What to tell the agent**:
"Please fix the failing tests listed above. Focus on [specific area] first. The test reports are in test_reports/ directory. Run the tests after each fix and update this file with results."

**Context for fixes**:
[Any additional context about recent changes, expected behavior, or specific requirements that might help the agent understand the failures]
