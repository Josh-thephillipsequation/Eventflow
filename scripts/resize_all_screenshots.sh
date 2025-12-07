#!/bin/bash

# Resize ALL screenshots to exact App Store Connect requirements
# Apple requires: 1284 × 2778px (portrait)

cd "$(dirname "$0")/.."

# Create directory for properly sized screenshots
mkdir -p app_store_screenshots_all

echo "Resizing ALL screenshots to exact App Store Connect dimensions..."
echo ""

# Function to resize to 1284 × 2778
resize_correct() {
    input=$1
    filename=$(basename "$input" | sed 's/\.[^.]*$//')
    
    # Resize to 1284 × 2778 (exact requirement)
    sips -z 2778 1284 "$input" --out "app_store_screenshots_all/${filename}.jpg" >/dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "✅ Created: ${filename}.jpg (1284 × 2778)"
    else
        echo "❌ Failed: ${filename}"
    fi
}

echo "Creating screenshots with exact dimensions: 1284 × 2778"
echo "========================================================"

# Process ALL screenshots (onboarding + main app)
for img in app_store_screenshots/01_onboarding_welcome.jpeg \
           app_store_screenshots/02_onboarding_import.jpeg \
           app_store_screenshots/03_onboarding_filtering.jpeg \
           app_store_screenshots/04_onboarding_ai_fun.jpeg \
           app_store_screenshots/05_onboarding_insights.jpeg \
           app_store_screenshots/06_main_all_events.jpeg \
           app_store_screenshots/07_my_agenda.jpeg \
           app_store_screenshots/08_insights_analytics.jpeg \
           app_store_screenshots/10_fun_talk_generator.jpeg; do
    if [ -f "$img" ]; then
        resize_correct "$img"
    fi
done

# Handle PNG file (bingo)
if [ -f "app_store_screenshots/09_fun_bingo.png" ]; then
    resize_correct "app_store_screenshots/09_fun_bingo.png"
fi

echo ""
echo "========================================================"
echo "✅ All 10 screenshots resized to 1284 × 2778!"
echo ""
echo "LOCATION: app_store_screenshots_all/"
echo ""
echo "ALL FILES (10 total):"
echo "  Onboarding (1-5):"
echo "    01_onboarding_welcome.jpg"
echo "    02_onboarding_import.jpg"
echo "    03_onboarding_filtering.jpg"
echo "    04_onboarding_ai_fun.jpg"
echo "    05_onboarding_insights.jpg"
echo ""
echo "  Main App (6-10):"
echo "    06_main_all_events.jpg"
echo "    07_my_agenda.jpg"
echo "    08_insights_analytics.jpg"
echo "    09_fun_bingo.jpg"
echo "    10_fun_talk_generator.jpg"
echo ""
echo "RECOMMENDED UPLOAD ORDER (App Store allows up to 10):"
echo "  Option A - Show app first (recommended):"
echo "    1. 06_main_all_events"
echo "    2. 07_my_agenda"
echo "    3. 08_insights_analytics"
echo "    4. 09_fun_bingo"
echo "    5. 10_fun_talk_generator"
echo "    6. 03_onboarding_filtering"
echo "    7. 01_onboarding_welcome"
echo "    8. 02_onboarding_import"
echo ""
echo "  Option B - Show onboarding first:"
echo "    1-5: All onboarding screens"
echo "    6-10: All main app screens"
echo ""
echo "NOTE: App Store Connect allows up to 10 screenshots."
echo "Upload all 10 or pick your best 6-8!"
echo ""
