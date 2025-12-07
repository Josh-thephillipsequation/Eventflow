#!/bin/bash

# Process iPad screenshots for App Store (2048x2732 for 12.9" iPad Pro)

mkdir -p app_store_screenshots_final

# iPad screenshots (most recent from today)
sips -z 2732 2048 \
    "img/IMG_1273.jpeg" \
    --out "app_store_screenshots_final/01_ipad_12.9inch.jpg"

echo "✓ iPad screenshot processed"
ls -lh app_store_screenshots_final/*ipad*
