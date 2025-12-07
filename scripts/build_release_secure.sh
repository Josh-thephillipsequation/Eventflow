#!/bin/bash
set -e

echo "🔒 Building secure release with obfuscation..."

# Create symbols directory
mkdir -p build/symbols

# Build iOS with obfuscation
flutter build ios --release \
  --obfuscate \
  --split-debug-info=build/symbols

echo "✅ iOS build complete with obfuscation"
echo "📦 Debug symbols saved to build/symbols/"
echo ""
echo "⚠️  IMPORTANT: Archive symbols for crash reporting"
echo "   tar -czf symbols-$(grep 'version:' pubspec.yaml | awk '{print $2}').tar.gz build/symbols/"
