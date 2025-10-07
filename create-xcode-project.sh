#!/bin/bash

# Create Xcode project structure for ClaudeSpotlight

PROJECT_NAME="ClaudeSpotlight"
BUNDLE_ID="com.claude.spotlight"

cat > "$PROJECT_NAME.xcodeproj/project.pbxproj" << 'EOF'
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {
		A10000001 /* ClaudeSpotlightApp.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ClaudeSpotlightApp.swift; sourceTree = "<group>"; };
		A10000002 /* ContentView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ContentView.swift; sourceTree = "<group>"; };
		A10000003 /* ClaudeViewModel.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ClaudeViewModel.swift; sourceTree = "<group>"; };
		A10000004 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
		A10000010 /* ClaudeSpotlight.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = ClaudeSpotlight.app; sourceTree = BUILT_PRODUCTS_DIR; };
		A10000020 /* Sources */ = {isa = PBXGroup; children = (A10000001, A10000002, A10000003, A10000004); path = Sources; sourceTree = "<group>"; };
		A10000021 /* Products */ = {isa = PBXGroup; children = (A10000010); name = Products; sourceTree = "<group>"; };
		A10000022 /* Root */ = {isa = PBXGroup; children = (A10000020, A10000021); sourceTree = "<group>"; };
		A10000030 /* PBXNativeTarget */ = {isa = PBXNativeTarget; buildConfigurationList = A10000040; buildPhases = (A10000050, A10000051, A10000052); buildRules = (); dependencies = (); name = ClaudeSpotlight; productName = ClaudeSpotlight; productReference = A10000010; productType = "com.apple.product-type.application"; };
		A10000040 /* XCConfigurationList */ = {isa = XCConfigurationList; buildConfigurations = (A10000041, A10000042); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; };
		A10000041 /* Debug */ = {isa = XCBuildConfiguration; buildSettings = {CODE_SIGN_STYLE = Automatic; INFOPLIST_FILE = Sources/Info.plist; LD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@executable_path/../Frameworks"); MACOSX_DEPLOYMENT_TARGET = 13.0; PRODUCT_BUNDLE_IDENTIFIER = com.claude.spotlight; PRODUCT_NAME = "$(TARGET_NAME)"; SWIFT_VERSION = 5.0;}; name = Debug; };
		A10000042 /* Release */ = {isa = XCBuildConfiguration; buildSettings = {CODE_SIGN_STYLE = Automatic; INFOPLIST_FILE = Sources/Info.plist; LD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@executable_path/../Frameworks"); MACOSX_DEPLOYMENT_TARGET = 13.0; PRODUCT_BUNDLE_IDENTIFIER = com.claude.spotlight; PRODUCT_NAME = "$(TARGET_NAME)"; SWIFT_VERSION = 5.0;}; name = Release; };
		A10000050 /* Sources */ = {isa = PBXSourcesBuildPhase; buildActionMask = 2147483647; files = (); runOnlyForDeploymentPostprocessing = 0; };
		A10000051 /* Frameworks */ = {isa = PBXFrameworksBuildPhase; buildActionMask = 2147483647; files = (); runOnlyForDeploymentPostprocessing = 0; };
		A10000052 /* Resources */ = {isa = PBXResourcesBuildPhase; buildActionMask = 2147483647; files = (); runOnlyForDeploymentPostprocessing = 0; };
		A10000100 /* PBXProject */ = {isa = PBXProject; attributes = {LastSwiftUpdateCheck = 1500; LastUpgradeCheck = 1500; TargetAttributes = {A10000030 = {CreatedOnToolsVersion = 15.0;};};}; buildConfigurationList = A10000040; compatibilityVersion = "Xcode 14.0"; developmentRegion = en; hasScannedForEncodings = 0; knownRegions = (en, Base); mainGroup = A10000022; productRefGroup = A10000021; projectDirPath = ""; projectRoot = ""; targets = (A10000030); };
	};
	rootObject = A10000100;
}
EOF

mkdir -p "$PROJECT_NAME.xcodeproj"

echo "✅ Xcode project structure created"
echo "⚠️  Note: For a complete Xcode project, open Xcode and create a new macOS App project, then copy the source files"
