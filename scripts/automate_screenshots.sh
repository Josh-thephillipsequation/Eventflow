#!/bin/bash
# Automated Screenshot Generation for EventFlow
# This script automates taking screenshots for all required device sizes

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}📸 EventFlow Screenshot Automation${NC}"
echo "=================================="

# Configuration
SCREENSHOTS_DIR="screenshots/automated"
DEVICES=(
  "iPhone 15 Pro Max"
  "iPhone 15 Pro"
  "iPhone 14 Pro Max"
  "iPhone 11 Pro Max"
  "iPad Pro (12.9-inch) (6th generation)"
  "iPad Pro (11-inch) (4th generation)"
  "iPad Air (5th generation)"
)

# Create screenshots directory
mkdir -p "$SCREENSHOTS_DIR"

# Function to take screenshot
take_screenshot() {
  local device=$1
  local name=$2
  local wait_time=${3:-2}
  
  echo -e "${YELLOW}  📸 Taking: $name on $device${NC}"
  
  # Wait for UI to settle
  sleep $wait_time
  
  # Take screenshot using simctl
  local output_path="$SCREENSHOTS_DIR/${device// /_}/$name.png"
  mkdir -p "$(dirname "$output_path")"
  
  xcrun simctl io booted screenshot --type=png "$output_path" 2>/dev/null || {
    echo -e "  ⚠️  Could not take screenshot (simulator may not be running)"
    return 1
  }
  
  if [ -f "$output_path" ]; then
    echo -e "  ${GREEN}✅ Saved: $output_path${NC}"
    return 0
  else
    echo -e "  ❌ Failed to save screenshot"
    return 1
  fi
}

# Function to run app on device
run_on_device() {
  local device=$1
  echo -e "${BLUE}🚀 Starting app on $device...${NC}"
  
  # Boot simulator if not running
  xcrun simctl boot "$device" 2>/dev/null || echo "Simulator already booted"
  
  # Open Simulator app
  open -a Simulator
  
  # Wait for simulator to be ready
  echo "Waiting for simulator to be ready..."
  sleep 5
  
  # Build and run app
  echo "Building app..."
  flutter build ios --simulator --debug
  
  echo "Launching app..."
  flutter run -d "$device" --release &
  FLUTTER_PID=$!
  
  # Wait for app to launch
  echo "Waiting for app to launch..."
  sleep 10
  
  return 0
}

# Function to navigate and take screenshots
take_all_screenshots() {
  local device=$1
  
  echo -e "${BLUE}📱 Taking screenshots for $device${NC}"
  
  # Screenshot sequence
  # Note: These coordinates are approximate and may need adjustment
  # You can use Accessibility Inspector to find exact coordinates
  
  # 1. Import Screen (default)
  take_screenshot "$device" "01_import_screen" 3
  
  # 2. Navigate to All Events tab
  # Tap bottom navigation at position for "All Events" (tab index 1)
  echo "  Navigating to All Events..."
  xcrun simctl io booted tap 200 800 2>/dev/null || true
  sleep 2
  take_screenshot "$device" "02_all_events" 2
  
  # 3. Navigate to My Agenda tab
  echo "  Navigating to My Agenda..."
  xcrun simctl io booted tap 300 800 2>/dev/null || true
  sleep 2
  take_screenshot "$device" "03_my_agenda" 2
  
  # 4. Navigate to Insights tab
  echo "  Navigating to Insights..."
  xcrun simctl io booted tap 400 800 2>/dev/null || true
  sleep 2
  take_screenshot "$device" "04_insights" 3
  
  # 5. Navigate to Fun tab
  echo "  Navigating to Fun..."
  xcrun simctl io booted tap 500 800 2>/dev/null || true
  sleep 2
  take_screenshot "$device" "05_fun_bingo" 2
  
  # 6. Open Settings (tap top right)
  echo "  Opening Settings..."
  xcrun simctl io booted tap 700 100 2>/dev/null || true
  sleep 2
  take_screenshot "$device" "06_settings" 2
}

# Main execution
main() {
  echo -e "${GREEN}Starting screenshot automation...${NC}"
  echo ""
  
  # Check if Flutter is available
  if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first."
    exit 1
  fi
  
  # Check if xcrun is available
  if ! command -v xcrun &> /dev/null; then
    echo "❌ xcrun not found. Please install Xcode Command Line Tools."
    exit 1
  fi
  
  # Process each device
  for device in "${DEVICES[@]}"; do
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Processing: $device${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Run app on device
    if run_on_device "$device"; then
      # Take all screenshots
      take_all_screenshots "$device"
      
      # Stop the app
      echo "Stopping app..."
      pkill -f "flutter run" || true
      sleep 2
    else
      echo -e "${YELLOW}⚠️  Skipping $device (could not start app)${NC}"
    fi
  done
  
  echo ""
  echo -e "${GREEN}✅ Screenshot automation complete!${NC}"
  echo -e "${BLUE}📁 Screenshots saved in: $SCREENSHOTS_DIR${NC}"
  echo ""
  echo "Next steps:"
  echo "1. Review screenshots in $SCREENSHOTS_DIR"
  echo "2. Upload to App Store Connect"
  echo "3. Or use: fastlane deliver --screenshots_path $SCREENSHOTS_DIR"
}

# Run main function
main

