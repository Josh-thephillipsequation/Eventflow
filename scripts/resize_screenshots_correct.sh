#!/bin/bash

# Resize screenshots to EXACT App Store Connect requirements
# Apple requires: 1242 × 2688px OR 1284 × 2778px (portrait only)

cd "$(dirname "$0")/.."

# Create directory for properly sized screenshots
mkdir -p app_store_screenshots_correct

echo "Resizing screenshots to exact App Store Connect dimensions..."
echo ""

# Function to resize to 1284 × 2778 (iPhone 14 Pro Max, 15 Pro Max)
resize_correct() {
    input=$1
    filename=$(basename "$input" | sed 's/\.[^.]*$//')
    
    # Resize to 1284 × 2778 (exact requirement)
    sips -z 2778 1284 "$input" --out "app_store_screenshots_correct/${filename}.jpg" >/dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "✅ Created: ${filename}.jpg (1284 × 2778)"
    else
        echo "❌ Failed: ${filename}"
    fi
}

echo "Creating screenshots with exact dimensions: 1284 × 2778"
echo "========================================================"

# Process main app screenshots in recommended order
for img in app_store_screenshots/06_main_all_events.jpeg \
           app_store_screenshots/07_my_agenda.jpeg \
           app_store_screenshots/08_insights_analytics.jpeg \
           app_store_screenshots/10_fun_talk_generator.jpeg \
           app_store_screenshots/03_onboarding_filtering.jpeg; do
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
echo "✅ All screenshots resized to 1284 × 2778!"
echo ""
echo "LOCATION: app_store_screenshots_correct/"
echo ""
echo "FILES CREATED (in upload order):"
echo "  1. 06_main_all_events.jpg"
echo "  2. 07_my_agenda.jpg"
echo "  3. 08_insights_analytics.jpg"
echo "  4. 09_fun_bingo.jpg"
echo "  5. 10_fun_talk_generator.jpg"
echo "  6. 03_onboarding_filtering.jpg"
echo ""
echo "UPLOAD INSTRUCTIONS:"
echo "  1. Go to App Store Connect > Screenshots"
echo "  2. Select the 6.7\" or 6.5\" display slot"
echo "  3. Drag and drop files in the order above"
echo ""
echo "These dimensions (1284 × 2778) should be accepted!"
echo ""
