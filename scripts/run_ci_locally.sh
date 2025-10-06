#!/bin/bash
# Run CI checks locally to match GitHub Actions workflow
# This ensures your code will pass CI before pushing

set -euo pipefail

echo "🔧 EventFlow Local CI Checks"
echo "=============================="
echo ""

# Show versions
echo "📋 Tool Versions:"
dart --version
flutter --version | head -n 1
echo ""

# Check 1: Formatting
echo "✅ Step 1/4: Checking code formatting..."
if dart format --output=none --set-exit-if-changed lib test; then
  echo "   ✓ Format check passed"
else
  echo "   ✗ Format check failed"
  echo "   Fix with: dart format lib test"
  exit 1
fi
echo ""

# Check 2: Static Analysis
echo "✅ Step 2/4: Running static analysis..."
if flutter analyze --fatal-infos; then
  echo "   ✓ Analysis passed"
else
  echo "   ✗ Analysis failed"
  echo "   Review the warnings/errors above"
  exit 1
fi
echo ""

# Check 3: Tests
echo "✅ Step 3/4: Running tests with coverage..."
if flutter test -j 1 --coverage --reporter expanded; then
  echo "   ✓ All tests passed"
else
  echo "   ✗ Tests failed"
  exit 1
fi
echo ""

# Check 4: Coverage Summary
echo "✅ Step 4/4: Generating coverage summary..."
if [ -f coverage/lcov.info ]; then
  if command -v lcov &> /dev/null; then
    lcov --summary coverage/lcov.info 2>&1 | tail -n 3
  else
    echo "   ℹ lcov not installed - skipping coverage summary"
    echo "   Install with: brew install lcov (macOS) or sudo apt-get install lcov (Linux)"
  fi
else
  echo "   ⚠ No coverage data generated"
fi
echo ""

echo "=============================="
echo "🎉 All CI checks passed locally!"
echo "=============================="
echo ""
echo "Your code is ready to push. GitHub Actions should pass ✅"
