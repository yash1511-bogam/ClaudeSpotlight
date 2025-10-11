# Claude Spotlight

A native macOS app that brings Claude AI to your desktop with an authentic Spotlight-like interface, built with the latest macOS technologies.

## 🎉 What's New (Latest Update)

### Major Enhancements
- ✨ **Complete UI Overhaul** - Redesigned with Apple's latest HIG for macOS Sequoia
- 🪟 **True Spotlight Experience** - Window now appears centered at top of screen, just like native Spotlight
- 🎨 **Modern Materials** - Updated to use ultra-thin material blur effects
- 📱 **Enhanced Design** - Refined spacing, borders, and SF Symbols throughout
- ⌨️ **Better Shortcuts** - Escape key support and improved keyboard handling
- 🚀 **macOS 15+ SDK** - Built with latest Swift 6.0 and macOS Sequoia SDK
- 🏗️ **Architecture Update** - Migrated from NSPopover to custom NSPanel for authentic behavior
- 🔐 **Concurrency Safety** - Full Swift 6 concurrency support with @MainActor

### Technical Improvements
- Replaced popover-based window with floating NSPanel
- Positioned window programmatically at screen center-top
- Updated Package.swift to Swift 6.0 tools version
- Applied proper MainActor isolation for thread safety
- Enhanced visual hierarchy with modern rounded corners and translucent effects
- Improved message bubbles with icons and better contrast

## ✨ Features

### Core Functionality
- 🎯 **True Spotlight-Style Interface** - Floating window positioned center-top of screen, just like macOS Spotlight
- 🪟 **Native macOS App** - Fully integrated with macOS, appears above all windows
- 🧠 **Multiple Claude Providers** - Anthropic Direct, Vertex AI, AWS Bedrock
- ⌨️ **Global Keyboard Shortcut** - Press **⌘⇧Space** anywhere to invoke (same as Spotlight)
- 💬 **Streaming Responses** - Real-time interaction with Claude AI
- 🚀 **Launch at Login** - Automatically starts with your Mac

### Modern macOS Design
- 🎨 **Apple HIG Compliant** - Follows Apple's Human Interface Guidelines for macOS Sequoia
- ✨ **Ultra-Thin Material** - Modern translucent blur effects using latest macOS materials
- 🖼️ **Dynamic Window** - Automatically expands when showing responses
- 🎭 **Borderless Floating Panel** - Clean, distraction-free interface
- 📱 **SF Symbols** - Native iconography throughout

### Advanced Features  
- ⚡ **Inline Terminal Command Execution** - Run suggested bash/shell commands safely
- 🛡️ **Smart Security** - Multi-level danger detection (Safe/Warning/Dangerous)
- 📊 **Live Command Output** - View execution results with exit codes
- 🔄 **Easy Provider Switching** - Switch between AI providers on the fly
- ⌨️ **Escape to Close** - Quick dismiss with Esc key

## 📋 Requirements

- **macOS 15.0 (Sequoia)** or later - Built with latest SDK
- **Xcode 16.0** or later - Swift 6.0 support
- **Apple Silicon or Intel Mac** - Universal support
- **API credentials** for chosen provider:
  - Anthropic Direct: API key
  - Vertex AI: GCP project credentials  
  - AWS Bedrock: AWS credentials

## Setup

### Quick Start (Anthropic Direct - Recommended)

1. Get your Anthropic API key from [console.anthropic.com](https://console.anthropic.com)

2. Set your API key as an environment variable:
   ```bash
   export ANTHROPIC_API_KEY="your-api-key-here"
   ```
   
   For persistent setup, add to `~/.zshrc` or `~/.bash_profile`:
   ```bash
   echo 'export ANTHROPIC_API_KEY="your-api-key-here"' >> ~/.zshrc
   ```

3. Build the .app bundle:
   ```bash
   cd ClaudeSpotlight
   ./build-app.sh
   ```

4. Run or install the app:
   ```bash
   # Run directly
   open .build/ClaudeSpotlight.app
   
   # Or install to Applications folder
   cp -r .build/ClaudeSpotlight.app /Applications/
   ```

### Alternative Providers

For **Vertex AI** or **AWS Bedrock** setup, see [PROVIDER_SETUP.md](PROVIDER_SETUP.md)

## Building

### Option 1: Build .app Bundle (Recommended)

The `build-app.sh` script builds the executable and packages it as a native macOS .app:

```bash
./build-app.sh
```

This creates `.build/ClaudeSpotlight.app` with:
- Proper .app bundle structure
- Info.plist configuration
- Code signing (ad-hoc)
- Entitlements for security
- Menu bar integration

### Option 2: Build with Xcode

```bash
open ClaudeSpotlight.xcodeproj
# Build and run in Xcode (⌘R)
```

### Option 3: Command Line Build (executable only)

```bash
swift build -c release
# Executable: .build/release/ClaudeSpotlight (or .build/arm64-apple-macosx/release/)
```

## Usage

1. Launch the app - it will appear in your menu bar with a provider icon
2. Click the menu bar icon or press **⌘⇧Space** to open the search window
3. (Optional) Click the provider icon to switch between Anthropic/Vertex/Bedrock
4. Type your question or code request
5. Press Enter to send to Claude
6. View streaming responses in real-time

### 🔥 NEW: Command Execution

When Claude suggests terminal commands (in bash/sh/zsh code blocks), they appear as executable:

1. **Review** the command and danger level indicator (🟢 Safe, 🟡 Warning, 🔴 Dangerous)
2. **Click "Run"** to execute
3. **Confirm** in the security dialog
4. **View output** inline with exit code

**Safety Features**:
- ✅ No auto-execution - all commands require confirmation
- ✅ Danger level analysis with visual warnings
- ✅ Blocks known dangerous patterns (rm -rf /, fork bombs, etc.)
- ✅ Shows full command in confirmation dialog

See [SECURITY.md](SECURITY.md) for security details.

## Keyboard Shortcuts

- **⌘⇧Space** - Toggle Claude Spotlight window
- **Enter** - Send message
- **Esc** - Close window

## Launch at Login

The app automatically registers itself to launch at login. To disable:
1. Go to System Settings > General > Login Items
2. Remove "ClaudeSpotlight" from the list

## Project Structure

```
ClaudeSpotlight/
├── Package.swift              # Swift Package Manager configuration
├── Sources/
│   ├── ClaudeSpotlightApp.swift  # Main app and window management
│   ├── ContentView.swift          # UI components
│   ├── ClaudeViewModel.swift      # Claude API integration
│   └── Info.plist                 # App configuration
└── README.md
```

## 🔒 Security Features

### App Sandbox
- **Enabled** - Runs in sandboxed environment for enhanced security
- **Network Access** - Limited to outbound connections for Claude API only
- **File Access** - User-selected files only (no automatic file access)
- **No Server** - Does not accept incoming network connections

### Hardened Runtime
- **JIT Disabled** - No just-in-time compilation allowed
- **Memory Protection** - Unsigned executable memory blocked
- **Library Validation** - Only signed libraries can be loaded
- **Environment Variables** - DYLD variables disabled for security

### Permissions
- **Minimal Scope** - Only requests necessary permissions
- **Apple Events** - Required for Terminal command execution
- **Transparency** - All commands shown before execution
- **User Control** - Explicit confirmation required for all commands

### Code Signing
- Ad-hoc signed by default for local development
- Ready for App Store or Developer ID signing
- Entitlements properly configured

## 🏗️ Architecture & Technology

### Modern macOS Technologies
- **Swift 6.0** - Latest Swift with improved concurrency and safety
- **SwiftUI** - Declarative UI framework for modern macOS apps
- **AppKit Integration** - NSPanel for true Spotlight-like floating windows
- **ServiceManagement** - Native launch at login support

### Window System
- **NSPanel** - Custom floating panel implementation
- **Window Level: .floating** - Appears above all other windows
- **Collection Behavior** - CanJoinAllSpaces + FullScreenAuxiliary
- **Positioning** - Programmatically centered at top of screen
- **Materials** - Ultra-thin material blur effects (macOS 15+)

### API Integration
- **SwiftAnthropic** - Official Anthropic API client for Swift
- **Async/Await** - Modern Swift concurrency
- **MainActor** - Proper UI thread safety
- **Streaming Responses** - Real-time token-by-token output

### Design System
- **Apple HIG Compliant** - Following Human Interface Guidelines
- **SF Symbols** - System iconography
- **Dynamic Type** - Accessibility support
- **Rounded Corners** - Modern 16px corner radius
- **Translucent Materials** - Native blur and vibrancy effects

## Troubleshooting

### API Key Issues
If you see "API key not configured" error:
1. Make sure ANTHROPIC_API_KEY is set in your environment
2. Restart the app after setting the environment variable
3. For Xcode, add the environment variable in scheme settings

### Window Not Appearing
- Check System Settings > Privacy & Security > Accessibility
- Grant necessary permissions to the app

### Launch at Login Not Working
- Ensure app is built with valid code signing
- Check System Settings > General > Login Items

## License

MIT License - feel free to modify and distribute

## Credits

Built with:
- [SwiftAnthropic](https://github.com/jamesrochabrun/SwiftAnthropic) by James Rochabrun
- [Anthropic Claude API](https://www.anthropic.com/)
