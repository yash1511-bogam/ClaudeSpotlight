#!/bin/bash

# Build ClaudeSpotlight as a macOS .app bundle
# This script builds the executable with Swift Package Manager and packages it into a .app

set -e

echo "🚀 Building ClaudeSpotlight.app..."
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="ClaudeSpotlight"
BUNDLE_ID="com.claude.spotlight"
BUILD_DIR=".build"
APP_DIR="$BUILD_DIR/$APP_NAME.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

# Clean previous build
echo -e "${BLUE}Cleaning previous build...${NC}"
rm -rf "$APP_DIR"
rm -rf "$BUILD_DIR/release" "$BUILD_DIR/debug"

# Build with Swift Package Manager
echo -e "${BLUE}Building executable with Swift Package Manager...${NC}"
swift build -c release 2>&1 | grep -v "disk I/O error" || true

# Check if executable exists (build may succeed despite database errors)
if [ ! -f "$BUILD_DIR/arm64-apple-macosx/release/$APP_NAME" ] && [ ! -f "$BUILD_DIR/release/$APP_NAME" ]; then
    echo -e "${RED}❌ Build failed - executable not found!${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Build succeeded${NC}"

# Create .app bundle structure
echo -e "${BLUE}Creating .app bundle structure...${NC}"
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# Copy executable
echo -e "${BLUE}Copying executable...${NC}"
if [ -f "$BUILD_DIR/release/$APP_NAME" ]; then
    cp "$BUILD_DIR/release/$APP_NAME" "$MACOS_DIR/"
    chmod +x "$MACOS_DIR/$APP_NAME"
elif [ -f "$BUILD_DIR/arm64-apple-macosx/release/$APP_NAME" ]; then
    cp "$BUILD_DIR/arm64-apple-macosx/release/$APP_NAME" "$MACOS_DIR/"
    chmod +x "$MACOS_DIR/$APP_NAME"
else
    echo -e "${RED}❌ Could not find built executable!${NC}"
    echo "Looked in:"
    echo "  $BUILD_DIR/release/$APP_NAME"
    echo "  $BUILD_DIR/arm64-apple-macosx/release/$APP_NAME"
    exit 1
fi

# Create Info.plist
echo -e "${BLUE}Creating Info.plist...${NC}"
cat > "$CONTENTS_DIR/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleExecutable</key>
	<string>$APP_NAME</string>
	<key>CFBundleIdentifier</key>
	<string>$BUNDLE_ID</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>$APP_NAME</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>1.0.0</string>
	<key>CFBundleVersion</key>
	<string>1</string>
	<key>LSMinimumSystemVersion</key>
	<string>15.0</string>
	<key>LSUIElement</key>
	<true/>
	<key>NSHumanReadableCopyright</key>
	<string>Copyright © 2024</string>
	<key>NSPrincipalClass</key>
	<string>NSApplication</string>
	<key>NSSupportsAutomaticTermination</key>
	<true/>
	<key>NSSupportsSuddenTermination</key>
	<true/>
	<key>NSHighResolutionCapable</key>
	<true/>
</dict>
</plist>
EOF

# Create PkgInfo
echo -e "${BLUE}Creating PkgInfo...${NC}"
echo -n "APPL????" > "$CONTENTS_DIR/PkgInfo"

# Copy entitlements (for reference, not embedded in unsigned app)
if [ -f "Sources/ClaudeSpotlight.entitlements" ]; then
    cp "Sources/ClaudeSpotlight.entitlements" "$RESOURCES_DIR/"
fi

# Try to code sign (optional, will skip if no signing identity)
echo -e "${BLUE}Attempting to code sign...${NC}"
if codesign -s - --force --deep "$APP_DIR" 2>/dev/null; then
    echo -e "${GREEN}✓ Ad-hoc code signing successful${NC}"
else
    echo -e "${BLUE}⚠ Could not code sign (this is OK for local testing)${NC}"
fi

echo ""
echo -e "${GREEN}✅ Success! ClaudeSpotlight.app created at:${NC}"
echo -e "${GREEN}   $APP_DIR${NC}"
echo ""
echo "To run the app:"
echo -e "  ${BLUE}open $APP_DIR${NC}"
echo ""
echo "To install to Applications:"
echo -e "  ${BLUE}cp -r $APP_DIR /Applications/${NC}"
echo ""
echo "To run with environment variables:"
echo -e "  ${BLUE}ANTHROPIC_API_KEY=your-key $APP_DIR/Contents/MacOS/$APP_NAME${NC}"
echo ""
