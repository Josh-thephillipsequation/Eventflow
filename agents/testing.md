---
ai.include_by_default: false  
ai.profiles: [testing]
ai.weight: 0.3
---

# Testing Strategy and Patterns

## Test Organization
- **Widget tests** for UI components
- **Unit tests** for business logic 
- **Integration tests** for key user flows
- **17+ tests** currently implemented

## Test Commands
```bash
# Run all tests
flutter test

# Run specific test
flutter test test/widget_test.dart

# Generate coverage
flutter test --coverage
```

## Testing Workflow
1. **Human-in-the-loop testing**: Deploy to iPhone after each feature
2. **Device command**: `flutter run --release -d "00008140-0002248A0E12801C"`
3. **CI validation**: No feature complete until CI tests pass
4. **Local validation**: Run `./scripts/run_ci_locally.sh` before push

## Testing Best Practices
- **Test-driven development**: Write tests for new features
- **Widget testing**: Test UI components and user interactions
- **Mock dependencies**: Use mocks for external services
- **Coverage targets**: Maintain high test coverage
- **Real device testing**: Always test on actual iPhone before completion

## Test File Structure
```
test/
├── widget_test.dart        # Main widget tests
├── unit/                   # Unit tests for models/providers
├── integration/            # End-to-end flow tests
└── mocks/                  # Test mocks and fixtures
```

## Common Test Patterns
- **Provider testing**: Test state management with `ChangeNotifierProvider`
- **Widget testing**: Use `testWidgets` for UI component verification
- **Mock calendar data**: Create test ICS files for import testing
- **Time zone testing**: Verify timezone handling across regions
