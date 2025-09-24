#!/bin/bash
# Generate App Store Screenshots Script
# Automates screenshot generation for App Store submission

set -e

echo "📱 EventFlow Screenshot Generation"
echo "================================="

# Create screenshots directory
mkdir -p screenshots/app-store/{iphone-6.7,iphone-6.5,iphone-5.5,ipad-12.9,ipad-10.5}

echo "📸 Screenshot Requirements:"
echo "iPhone 6.7\" (1290×2796): 3-10 screenshots"
echo "iPhone 6.5\" (1242×2688): 3-10 screenshots" 
echo "iPhone 5.5\" (1242×2208): 3-10 screenshots"
echo "iPad 12.9\" (2048×2732): 3-10 screenshots"
echo "iPad 10.5\" (1668×2224): 3-10 screenshots"
echo ""

# Generate screenshot templates
cat > screenshots/app-store/screenshot-checklist.md << 'EOF'
# EventFlow App Store Screenshots Checklist

## Required Screenshots

### iPhone 6.7" (iPhone 14 Pro Max) - 1290×2796
- [ ] Main agenda screen with imported events
- [ ] Import calendar screen with demo URL
- [ ] Event details view
- [ ] Search/filter functionality
- [ ] Settings/About screen

### iPhone 6.5" (iPhone XS Max) - 1242×2688  
- [ ] Main agenda screen with imported events
- [ ] Import calendar screen with demo URL
- [ ] Event details view
- [ ] Search/filter functionality
- [ ] Settings/About screen

### iPhone 5.5" (iPhone 8 Plus) - 1242×2208
- [ ] Main agenda screen with imported events
- [ ] Import calendar screen with demo URL
- [ ] Event details view

### iPad 12.9" - 2048×2732
- [ ] Main agenda screen (landscape)
- [ ] Import calendar screen (landscape)
- [ ] Event details view (landscape)

### iPad 10.5" - 1668×2224
- [ ] Main agenda screen (landscape)
- [ ] Import calendar screen (landscape)
- [ ] Event details view (landscape)

## Screenshot Guidelines
1. Use the demo calendar URL: webcal://etlslasvegas2025.sched.com/all.ics
2. Show EventFlow branding and clean Material 3 design
3. Include diverse event types and times
4. Highlight key features: import, search, agenda management
5. Use high-quality, realistic content
6. Avoid personal information in screenshots

## Tools for Screenshot Generation
- iOS Simulator (built into Xcode)
- Device Screenshots via Xcode Device Window
- Third-party tools like Screenshot Path or App Store Screenshot

## Next Steps
1. Run EventFlow in iOS Simulator
2. Import the demo calendar
3. Take screenshots of key screens
4. Optimize and crop to exact dimensions
5. Upload to App Store Connect
EOF

echo "✅ Screenshot directories and checklist created"
echo "📁 Location: screenshots/app-store/"
echo ""
echo "📋 Next Steps for Screenshots:"
echo "1. Run 'flutter run -d [simulator-id]' for each device size"
echo "2. Import demo calendar: webcal://etlslasvegas2025.sched.com/all.ics"
echo "3. Take screenshots using Simulator > Device > Screenshot"
echo "4. Save to appropriate device folder"
echo ""
