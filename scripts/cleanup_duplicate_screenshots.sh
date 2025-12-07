#!/bin/bash

# Clean up duplicate screenshots from img/ folder
# Keeps only the original files (IMG_1265.jpeg through IMG_1274.jpeg/PNG + video)

cd "$(dirname "$0")/.."

echo "================================================"
echo "CLEANING UP DUPLICATE SCREENSHOTS"
echo "================================================"
echo ""
echo "Keeping only original files:"
echo "  - IMG_1265.jpeg through IMG_1274.jpeg"
echo "  - IMG_1273.PNG"
echo "  - EventflowUxDemo.MP4"
echo ""
echo "Removing duplicates with ' (1)', ' 2', ' 3' in filename..."
echo ""

# Count duplicates first
DUPLICATE_COUNT=$(find img/ -type f \( -name "*\ (1)*" -o -name "*\ 2.*" -o -name "*\ 3.*" \) | wc -l | xargs)

echo "Found $DUPLICATE_COUNT duplicate files"
echo ""

# Remove duplicates
find img/ -type f \( -name "*\ (1)*" -o -name "*\ 2.*" -o -name "*\ 3.*" \) -print -delete

echo ""
echo "================================================"
echo "✅ CLEANUP COMPLETE"
echo "================================================"
echo ""
echo "Remaining files in img/:"
ls -1 img/
echo ""
echo "Total files: $(ls -1 img/ | wc -l | xargs)"
echo ""
