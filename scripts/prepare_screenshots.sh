#!/bin/bash

# Script to organize and rename screenshots for App Store Connect
# App Store requires specific dimensions and naming

cd "$(dirname "$0")/.."

# Create App Store screenshots directory
mkdir -p app_store_screenshots

echo "Organizing screenshots for App Store Connect..."

# Copy and rename screenshots with descriptive names
# These are already properly sized iPhone screenshots

# Onboarding screens (1-5)
cp "img/IMG_1265.jpeg" "app_store_screenshots/01_onboarding_welcome.jpeg"
cp "img/IMG_1266.jpeg" "app_store_screenshots/02_onboarding_import.jpeg"
cp "img/IMG_1267.jpeg" "app_store_screenshots/03_onboarding_filtering.jpeg"
cp "img/IMG_1268.jpeg" "app_store_screenshots/04_onboarding_ai_fun.jpeg"
cp "img/IMG_1269.jpeg" "app_store_screenshots/05_onboarding_insights.jpeg"

# Main app screens
cp "img/IMG_1270.jpeg" "app_store_screenshots/06_main_all_events.jpeg"
cp "img/IMG_1271.jpeg" "app_store_screenshots/07_my_agenda.jpeg"
cp "img/IMG_1272.jpeg" "app_store_screenshots/08_insights_analytics.jpeg"
cp "img/IMG_1273.PNG" "app_store_screenshots/09_fun_bingo.png"
cp "img/IMG_1274.jpeg" "app_store_screenshots/10_fun_talk_generator.jpeg"

echo ""
echo "✅ Screenshots organized in app_store_screenshots/"
echo ""
echo "RECOMMENDED SUBMISSION ORDER:"
echo "1. 06_main_all_events.jpeg - Main feature: Event browsing"
echo "2. 07_my_agenda.jpeg - Personal agenda view"
echo "3. 08_insights_analytics.jpeg - Analytics features"
echo "4. 09_fun_bingo.png - Fun interactive features"
echo "5. 10_fun_talk_generator.jpeg - AI-powered content"
echo "6. 03_onboarding_filtering.jpeg - Smart filtering"
echo ""
echo "WHAT YOU HAVE:"
echo "- iPhone screenshots (appear to be proper resolution)"
echo "- 10 total screenshots (App Store allows up to 10)"
echo "- Good variety showing all major features"
echo ""
echo "NEXT STEPS:"
echo "1. Check screenshot dimensions with: file app_store_screenshots/*.{jpeg,png}"
echo "2. Upload 6-8 best screenshots to App Store Connect"
echo "3. Add captions in App Store Connect (optional but recommended)"
echo ""
echo "SUGGESTED CAPTIONS:"
echo "1. 'Browse conference events with smart day grouping and priority'"
echo "2. 'Build your personal agenda with selected events'"
echo "3. 'Explore insights with topic clouds and schedule heatmaps'"
echo "4. 'Play interactive conference bingo'"
echo "5. 'Generate AI-powered talk proposals'"
echo "6. 'Filter events by time, priority, and keywords'"
