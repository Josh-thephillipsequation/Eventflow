#!/bin/bash
# Run GitHub Actions CI pipeline locally before pushing
# This ensures all tests pass before triggering remote CI

echo "🧪 Running EventFlow CI Pipeline Locally"
echo "========================================="

# Create reports directory
mkdir -p test_reports coverage

# Track failures
FAILURES_FILE="test_reports/failures.txt"
rm -f "$FAILURES_FILE"

echo "📋 Step 1: Code Formatting Check"
if ! dart format --output=none --set-exit-if-changed .; then
    echo "❌ Format check failed" >> "$FAILURES_FILE"
    echo "❌ Code formatting issues detected"
else
    echo "✅ Code formatting passed"
fi

echo ""
echo "📋 Step 2: Static Analysis"
if ! flutter analyze --fatal-infos > test_reports/analysis.txt 2>&1; then
    echo "❌ Analysis failed" >> "$FAILURES_FILE"
    echo "❌ Static analysis issues detected"
    echo "   Check test_reports/analysis.txt for details"
else
    echo "✅ Static analysis passed"
fi

echo ""
echo "📋 Step 3: Unit & Widget Tests with Coverage"
if ! flutter test --coverage --reporter json > test_reports/test_results.json 2>&1; then
    echo "❌ Tests failed" >> "$FAILURES_FILE"
    echo "❌ Test failures detected"
    echo "   Check test_reports/test_results.json for details"
else
    echo "✅ All tests passed"
fi

echo ""
echo "📋 Step 4: Coverage Report Generation"
if [ -f coverage/lcov.info ]; then
    if command -v lcov >/dev/null 2>&1; then
        lcov --summary coverage/lcov.info > test_reports/coverage_summary.txt 2>&1
        echo "✅ Coverage report generated"
    else
        echo "⚠️  lcov not installed - coverage summary skipped"
        echo "   Install with: brew install lcov (macOS) or apt-get install lcov (Linux)"
    fi
else
    echo "⚠️  No coverage data generated"
fi

echo ""
echo "📋 Step 5: Build Verification"
echo "   Testing iOS build (no codesign)..."
if flutter build ios --no-codesign --debug >/dev/null 2>&1; then
    echo "✅ iOS build succeeded"
else
    echo "❌ iOS build failed"
    echo "❌ Build failed" >> "$FAILURES_FILE"
fi

echo "   Testing Android build..."
if flutter build apk --debug >/dev/null 2>&1; then
    echo "✅ Android build succeeded"
else
    echo "❌ Android build failed"  
    echo "❌ Build failed" >> "$FAILURES_FILE"
fi

echo ""
echo "📊 CI Results Summary"
echo "===================="

if [ -f "$FAILURES_FILE" ]; then
    echo "❌ CI would FAIL - Issues detected:"
    cat "$FAILURES_FILE"
    echo ""
    echo "🔧 Fix these issues before pushing:"
    echo "   1. Check test_reports/ directory for detailed error logs"
    echo "   2. Run individual commands to isolate problems"
    echo "   3. Fix issues systematically"
    echo "   4. Re-run this script to verify fixes"
    echo ""
    echo "🚨 DO NOT PUSH until all issues are resolved!"
    exit 1
else
    echo "✅ All CI checks passed!"
    echo "🚀 Safe to push - GitHub Actions should succeed"
    echo ""
    echo "📋 Summary:"
    echo "   ✅ Code formatting clean"
    echo "   ✅ Static analysis clean"
    echo "   ✅ All tests passing"
    echo "   ✅ iOS/Android builds working"
    echo ""
    echo "🎯 Ready for: git push origin [branch-name]"
    exit 0
fi
