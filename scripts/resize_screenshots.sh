#!/bin/bash

# Resize screenshots to exact App Store Connect requirements using sips (built-in macOS tool)

cd "$(dirname "$0")/.."

# Create directory for properly sized screenshots
mkdir -p app_store_screenshots_final

echo "Resizing screenshots to App Store Connect requirements..."
echo ""

# App Store requires EXACT dimensions:
# 6.7" Display (iPhone 14 Pro Max, 15 Pro Max): 1290 x 2796
# 6.5" Display (iPhone 11 Pro Max, XS Max): 1242 x 2688

# We'll create both sizes to be safe

# Function to resize to 6.5" (1242 x 2688)
resize_65() {
    input=$1
    filename=$(basename "$input" | sed 's/\.[^.]*$//')
    
    # Resize to 1242 x 2688 (6.5" display)
    sips -z 2688 1242 "$input" --out "app_store_screenshots_final/${filename}_6.5inch.jpg" >/dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "✅ Created: ${filename}_6.5inch.jpg (1242 x 2688)"
    else
        echo "❌ Failed: ${filename}"
    fi
}

# Function to resize to 6.7" (1290 x 2796)  
resize_67() {
    input=$1
    filename=$(basename "$input" | sed 's/\.[^.]*$//')
    
    # Resize to 1290 x 2796 (6.7" display)
    sips -z 2796 1290 "$input" --out "app_store_screenshots_final/${filename}_6.7inch.jpg" >/dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "✅ Created: ${filename}_6.7inch.jpg (1290 x 2796)"
    else
        echo "❌ Failed: ${filename}"
    fi
}

echo "Creating 6.5\" iPhone screenshots (1242 x 2688)..."
echo "================================================"

# Process main app screenshots (skip onboarding for now, focus on best 6)
for img in app_store_screenshots/06_main_all_events.jpeg \
           app_store_screenshots/07_my_agenda.jpeg \
           app_store_screenshots/08_insights_analytics.jpeg \
           app_store_screenshots/10_fun_talk_generator.jpeg \
           app_store_screenshots/03_onboarding_filtering.jpeg; do
    if [ -f "$img" ]; then
        resize_65 "$img"
    fi
done

# Handle PNG file separately (bingo)
if [ -f "app_store_screenshots/09_fun_bingo.png" ]; then
    resize_65 "app_store_screenshots/09_fun_bingo.png"
fi

echo ""
echo "Creating 6.7\" iPhone screenshots (1290 x 2796)..."
echo "================================================"

for img in app_store_screenshots/06_main_all_events.jpeg \
           app_store_screenshots/07_my_agenda.jpeg \
           app_store_screenshots/08_insights_analytics.jpeg \
           app_store_screenshots/10_fun_talk_generator.jpeg \
           app_store_screenshots/03_onboarding_filtering.jpeg; do
    if [ -f "$img" ]; then
        resize_67 "$img"
    fi
done

if [ -f "app_store_screenshots/09_fun_bingo.png" ]; then
    resize_67 "app_store_screenshots/09_fun_bingo.png"
fi

echo ""
echo "================================================"
echo "✅ Screenshots resized and ready!"
echo ""
echo "FINAL SCREENSHOTS LOCATION:"
echo "  app_store_screenshots_final/"
echo ""
echo "TWO SETS CREATED:"
echo "  1. *_6.5inch.jpg (1242 x 2688) - for 6.5\" display"
echo "  2. *_6.7inch.jpg (1290 x 2796) - for 6.7\" display"
echo ""
echo "UPLOAD TO APP STORE CONNECT:"
echo "  1. Go to App Store Connect > Screenshots"
echo "  2. Choose the display size Apple is asking for"
echo "  3. Upload the matching files (*_6.5inch or *_6.7inch)"
echo ""
echo "RECOMMENDED ORDER:"
echo "  1. 06_main_all_events - Main feature"
echo "  2. 07_my_agenda - Personal agenda"
echo "  3. 08_insights_analytics - Analytics"
echo "  4. 09_fun_bingo - Fun features"
echo "  5. 10_fun_talk_generator - AI features"
echo "  6. 03_onboarding_filtering - Filtering"
echo ""
