# Building ClaudeSpotlight

## Method 1: Using Xcode (Recommended)

1. **Create a new Xcode project:**
   - Open Xcode
   - File > New > Project
   - Choose "macOS" > "App"
   - Product Name: `ClaudeSpotlight`
   - Bundle Identifier: `com.claude.spotlight`
   - Interface: SwiftUI
   - Language: Swift
   - Create

2. **Add SwiftAnthropic Package:**
   - File > Add Package Dependencies
   - Enter URL: `https://github.com/jamesrochabrun/SwiftAnthropic`
   - Select version: Up to Next Major (1.0.0)
   - Add to ClaudeSpotlight target

3. **Replace default files:**
   - Delete the default ContentView.swift and ClaudeSpotlightApp.swift
   - Drag and drop all files from `Sources/` folder into Xcode project

4. **Configure Info.plist:**
   - In project settings, go to Info tab
   - Add "Application is agent (UIElement)" = YES
   - This makes the app run as a menu bar app without dock icon

5. **Set up environment variable:**
   - Edit Scheme (Product > Scheme > Edit Scheme)
   - Go to Run > Arguments > Environment Variables
   - Add: `ANTHROPIC_API_KEY` = `your-api-key-here`

6. **Build and Run:**
   - Press ⌘R to build and run
   - The app will appear in your menu bar

## Method 2: Command Line Build

```bash
# Install dependencies
swift package resolve

# Build
swift build -c release

# The binary will be in:
.build/release/ClaudeSpotlight
```

**Note:** Command line build requires environment variable to be set:
```bash
export ANTHROPIC_API_KEY="your-api-key-here"
.build/release/ClaudeSpotlight
```

## Method 3: Create App Bundle

To create a proper .app bundle:

```bash
# Build release version
swift build -c release

# Create app bundle structure
mkdir -p ClaudeSpotlight.app/Contents/MacOS
mkdir -p ClaudeSpotlight.app/Contents/Resources

# Copy binary
cp .build/release/ClaudeSpotlight ClaudeSpotlight.app/Contents/MacOS/

# Create Info.plist in app bundle
cp Sources/Info.plist ClaudeSpotlight.app/Contents/

# Make executable
chmod +x ClaudeSpotlight.app/Contents/MacOS/ClaudeSpotlight
```

Then you can drag ClaudeSpotlight.app to your Applications folder.

## Code Signing (for distribution)

If you want to distribute the app:

```bash
codesign --force --deep --sign "Developer ID Application: Your Name" ClaudeSpotlight.app
```

## Troubleshooting

### "SwiftAnthropic module not found"
- Make sure you've added the package dependency in Xcode
- Clean build folder (⌘⇧K) and rebuild

### "Permission denied" on launch
- Go to System Settings > Privacy & Security
- Grant necessary permissions

### App doesn't appear in menu bar
- Check that LSUIElement is set to YES in Info.plist
- Make sure app is built successfully without errors

### API key not working
- Verify your API key is valid at console.anthropic.com
- Check environment variable is set correctly
- Restart Xcode after setting environment variables

## Development Tips

- Use Xcode's live preview for faster UI development
- Check Console.app for debug logs
- Use breakpoints in AppDelegate for debugging window behavior
- Test keyboard shortcuts in a real build, not in Xcode debugger

## Next Steps

After building:
1. Test the keyboard shortcut (⌘⇧Space)
2. Try asking Claude various questions
3. Check that launch at login works
4. Customize the UI colors and styling to your preference
