#!/bin/bash
set -e

# Load credentials from .env (never output them)
if [ ! -f .env ]; then
    echo "Error: .env file not found"
    exit 1
fi

source .env

# Find the IPA file
IPA_PATH=$(ls build/ios/ipa/*.ipa | head -1)

if [ -z "$IPA_PATH" ]; then
    echo "Error: No IPA file found in build/ios/ipa/"
    exit 1
fi

echo "Uploading $IPA_PATH to App Store Connect..."
echo "This may take a few minutes..."

# Upload to App Store Connect (credentials not echoed)
xcrun altool --upload-app \
    --type ios \
    --file "$IPA_PATH" \
    --username "$APPLE_ID" \
    --password "$APPLE_APP_SPECIFIC_PASSWORD"

echo "✓ Upload complete!"
