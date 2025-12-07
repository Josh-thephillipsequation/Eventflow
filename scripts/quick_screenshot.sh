#!/bin/bash
# Quick screenshot automation - simplest method
# Uses Flutter's built-in screenshot capability via simctl

set -e

DEVICE="${1:-iPhone 15 Pro Max}"
SCREENSHOT_DIR="screenshots/quick_${DEVICE// /_}"

echo "📸 Quick Screenshot: $DEVICE"
echo "============================"

# Boot simulator
echo "Booting simulator..."
xcrun simctl boot "$DEVICE" 2>/dev/null || echo "Already booted"
open -a Simulator
sleep 5

# Build and run
echo "Building app..."
flutter build ios --simulator --debug

echo "Launching app..."
flutter run -d "$DEVICE" --release &
FLUTTER_PID=$!
sleep 10

# Create directory
mkdir -p "$SCREENSHOT_DIR"

echo ""
echo "📸 Ready to take screenshots!"
echo "Navigate through the app, then press Enter to take a screenshot"
echo "Type 'done' when finished"
echo ""

counter=1
while true; do
  read -p "Screenshot name (or 'done'): " name
  if [ "$name" = "done" ]; then
    break
  fi
  
  if [ -z "$name" ]; then
    name="screenshot_$(printf "%02d" $counter)"
    counter=$((counter + 1))
  fi
  
  output="$SCREENSHOT_DIR/${name}.png"
  xcrun simctl io booted screenshot --type=png "$output"
  
  if [ -f "$output" ]; then
    echo "✅ Saved: $output"
  else
    echo "❌ Failed"
  fi
done

# Stop app
pkill -f "flutter run" || true

echo ""
echo "✅ Screenshots saved in: $SCREENSHOT_DIR"

