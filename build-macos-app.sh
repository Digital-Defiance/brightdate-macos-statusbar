#!/bin/bash
# Build the BrightDate StatusBar macOS app and output the .app bundle in Release mode

set -e

SCHEME="BrightDate StatusBar"
CONFIG="Release"
DERIVED_DATA="build"

xcodebuild -scheme "$SCHEME" -configuration "$CONFIG" -derivedDataPath "$DERIVED_DATA"

APP_PATH="$DERIVED_DATA/Build/Products/$CONFIG/$SCHEME.app"

echo "Build complete. App bundle is at: $APP_PATH"
