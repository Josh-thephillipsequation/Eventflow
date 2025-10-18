#!/bin/bash

# EventFlow - Deploy to iPhone for Testing
# Quick deployment script for human-in-the-loop testing

echo "🚀 Deploying EventFlow to iPhone..."
echo ""

# Your iPhone device ID
DEVICE_ID="00008140-0002248A0E12801C"

# Deploy in release mode for real-world testing
flutter run --release -d "$DEVICE_ID"
