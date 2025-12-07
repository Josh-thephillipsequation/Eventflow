#!/bin/bash

# Prepare all screenshots from img/ folder with proper formatting and captions
# Format: 1284 × 2778 (App Store requirement)

cd "$(dirname "$0")/.."

# Create final directory
mkdir -p app_store_final

echo "================================================"
echo "EVENTFLOW - APP STORE SCREENSHOTS WITH CAPTIONS"
echo "================================================"
echo ""
echo "Formatting all screenshots to 1284 × 2778..."
echo ""

# Screenshot 1: Onboarding Welcome
sips -z 2778 1284 "img/IMG_1265.jpeg" --out "app_store_final/01_welcome.jpg" >/dev/null 2>&1
echo "✅ 01_welcome.jpg"
echo "   Caption: Your personal conference companion - Never miss an important session"

# Screenshot 2: Onboarding Import
sips -z 2778 1284 "img/IMG_1266.jpeg" --out "app_store_final/02_import.jpg" >/dev/null 2>&1
echo "✅ 02_import.jpg"
echo "   Caption: Import schedules from ICS files, URLs, or try sample data"

# Screenshot 3: Onboarding Filtering
sips -z 2778 1284 "img/IMG_1267.jpeg" --out "app_store_final/03_filtering.jpg" >/dev/null 2>&1
echo "✅ 03_filtering.jpg"
echo "   Caption: Filter by time, priority, and search topics or speakers"

# Screenshot 4: Onboarding AI Fun
sips -z 2778 1284 "img/IMG_1268.jpeg" --out "app_store_final/04_ai_fun.jpg" >/dev/null 2>&1
echo "✅ 04_ai_fun.jpg"
echo "   Caption: Generate talk proposals, product names, and play conference bingo"

# Screenshot 5: Onboarding Insights
sips -z 2778 1284 "img/IMG_1269.jpeg" --out "app_store_final/05_insights.jpg" >/dev/null 2>&1
echo "✅ 05_insights.jpg"
echo "   Caption: Explore topic clouds, schedule heatmaps, and discover patterns"

# Screenshot 6: Main Events Screen
sips -z 2778 1284 "img/IMG_1270.jpeg" --out "app_store_final/06_all_events.jpg" >/dev/null 2>&1
echo "✅ 06_all_events.jpg"
echo "   Caption: Browse events with smart day grouping and priority badges"

# Screenshot 7: My Agenda
sips -z 2778 1284 "img/IMG_1271.jpeg" --out "app_store_final/07_my_agenda.jpg" >/dev/null 2>&1
echo "✅ 07_my_agenda.jpg"
echo "   Caption: Build your personal agenda with selected events and statistics"

# Screenshot 8: Insights Analytics
sips -z 2778 1284 "img/IMG_1272.jpeg" --out "app_store_final/08_analytics.jpg" >/dev/null 2>&1
echo "✅ 08_analytics.jpg"
echo "   Caption: Interactive analytics with 24-hour heatmaps and topic exploration"

# Screenshot 9: Conference Bingo
sips -z 2778 1284 "img/IMG_1273.PNG" --out "app_store_final/09_bingo.jpg" >/dev/null 2>&1
echo "✅ 09_bingo.jpg"
echo "   Caption: Play interactive conference bingo with smart buzzword detection"

# Screenshot 10: Talk Generator
sips -z 2778 1284 "img/IMG_1274.jpeg" --out "app_store_final/10_talk_generator.jpg" >/dev/null 2>&1
echo "✅ 10_talk_generator.jpg"
echo "   Caption: AI-powered talk proposal generator for creative inspiration"

echo ""
echo "================================================"
echo "✅ ALL 10 SCREENSHOTS FORMATTED!"
echo "================================================"
echo ""
echo "LOCATION: app_store_final/"
echo "DIMENSIONS: 1284 × 2778 (App Store compliant)"
echo ""
echo "RECOMMENDED UPLOAD ORDER FOR APP STORE:"
echo ""
echo "Option A - Show App Features First (Recommended):"
echo "  1. 06_all_events.jpg"
echo "  2. 07_my_agenda.jpg"
echo "  3. 08_analytics.jpg"
echo "  4. 09_bingo.jpg"
echo "  5. 10_talk_generator.jpg"
echo "  6. 03_filtering.jpg"
echo "  7. 01_welcome.jpg"
echo "  8. 02_import.jpg"
echo ""
echo "Option B - Show User Journey:"
echo "  1-10 in numerical order"
echo ""
echo "CAPTIONS SAVED TO: app_store_final/CAPTIONS.txt"
echo ""

# Create captions file
cat > app_store_final/CAPTIONS.txt << 'EOF'
# EventFlow - App Store Screenshot Captions

Copy and paste these captions into App Store Connect for each screenshot:

## Screenshot 1: 01_welcome.jpg
Your personal conference companion - Never miss an important session

## Screenshot 2: 02_import.jpg
Import schedules from ICS files, URLs, or try sample data

## Screenshot 3: 03_filtering.jpg
Filter by time, priority, and search topics or speakers

## Screenshot 4: 04_ai_fun.jpg
Generate talk proposals, product names, and play conference bingo

## Screenshot 5: 05_insights.jpg
Explore topic clouds, schedule heatmaps, and discover patterns

## Screenshot 6: 06_all_events.jpg
Browse events with smart day grouping and priority badges

## Screenshot 7: 07_my_agenda.jpg
Build your personal agenda with selected events and statistics

## Screenshot 8: 08_analytics.jpg
Interactive analytics with 24-hour heatmaps and topic exploration

## Screenshot 9: 09_bingo.jpg
Play interactive conference bingo with smart buzzword detection

## Screenshot 10: 10_talk_generator.jpg
AI-powered talk proposal generator for creative inspiration

---

## UPLOAD INSTRUCTIONS:

1. Go to App Store Connect > Your App > Screenshots
2. Select the device size (6.7" or 6.5")
3. Drag and drop screenshots in recommended order
4. Add captions under each screenshot (optional but recommended)

## RECOMMENDED ORDER (Shows app features first):
- 06_all_events.jpg (first impression)
- 07_my_agenda.jpg
- 08_analytics.jpg
- 09_bingo.jpg
- 10_talk_generator.jpg
- 03_filtering.jpg
- 01_welcome.jpg (optional - onboarding)
- 02_import.jpg (optional - onboarding)

App Store allows up to 10 screenshots. Use the first 6-8 for best results.
EOF

echo "📄 Captions saved to app_store_final/CAPTIONS.txt"
echo ""
echo "Ready to upload to App Store Connect! 🚀"
echo ""
