#!/bin/bash
# Screenshot automation using Flutter integration tests
# This is the most reliable method as it uses actual Flutter navigation

set -e

echo "📸 EventFlow Screenshot Automation (Integration Test Method)"
echo "============================================================"

# Configuration
SCREENSHOTS_DIR="screenshots/integration_test"
DEVICES=(
  "iPhone 15 Pro Max"
  "iPhone 15 Pro"
  "iPhone 14 Pro Max"
  "iPhone 11 Pro Max"
  "iPad Pro (12.9-inch) (6th generation)"
  "iPad Pro (11-inch) (4th generation)"
  "iPad Air (5th generation)"
)

# Create directory
mkdir -p "$SCREENSHOTS_DIR"

# Check if integration_test package is available
if ! grep -q "integration_test:" pubspec.yaml; then
  echo "Adding integration_test dependency..."
  # Add integration_test to pubspec.yaml (you'll need to do this manually or use sed)
  echo "⚠️  Please add integration_test to pubspec.yaml dev_dependencies:"
  echo "  integration_test:"
  echo "    sdk: flutter"
  exit 1
fi

# Function to run integration test on device
run_screenshot_test() {
  local device=$1
  local device_id=$(echo "$device" | tr ' ' '_')
  
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📱 Device: $device"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  # Boot simulator
  echo "Booting simulator..."
  xcrun simctl boot "$device" 2>/dev/null || echo "Simulator already booted"
  open -a Simulator
  sleep 5
  
  # Run integration test
  echo "Running screenshot integration test..."
  flutter test integration_test/screenshot_automation_test.dart \
    -d "$device" \
    --screenshot-dir "$SCREENSHOTS_DIR/$device_id" \
    --release || {
    echo "⚠️  Test failed or screenshots not captured"
    return 1
  }
  
  echo "✅ Screenshots captured for $device"
}

# Main execution
main() {
  echo "Starting integration test screenshot automation..."
  echo ""
  
  # Check dependencies
  if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found"
    exit 1
  fi
  
  # Get dependencies
  echo "Getting Flutter dependencies..."
  flutter pub get
  
  # Process each device
  for device in "${DEVICES[@]}"; do
    run_screenshot_test "$device"
  done
  
  echo ""
  echo "✅ All screenshots captured!"
  echo "📁 Location: $SCREENSHOTS_DIR"
  echo ""
  echo "Next steps:"
  echo "1. Review screenshots"
  echo "2. Resize if needed for specific App Store requirements"
  echo "3. Upload to App Store Connect"
}

main

