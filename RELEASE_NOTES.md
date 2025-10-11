# ClaudeSpotlight v1.0.0 - Native macOS App Release 🚀

## What's New

This is the first official release of ClaudeSpotlight as a **native macOS .app bundle**! The app now provides a true Spotlight-like experience with comprehensive security features.

### 🎉 Major Features

- **Native macOS Application** - Fully packaged .app bundle ready to install
- **Spotlight-Style Interface** - Floating window positioned at top-center of screen
- **Global Keyboard Shortcut** - Press `⌘⇧Space` anywhere to invoke
- **Menu Bar Integration** - Runs as accessory app with no Dock icon
- **Multiple AI Providers** - Support for Anthropic Direct, Vertex AI, AWS Bedrock
- **Command Execution** - Run suggested terminal commands with safety checks
- **Streaming Responses** - Real-time token-by-token output

### 🔒 Security Features

- **App Sandbox** - Runs in sandboxed environment for enhanced security
- **Hardened Runtime** - JIT disabled, memory protection, library validation
- **Minimal Permissions** - Network client only, user-selected files
- **Code Signed** - Ad-hoc signed (ready for Developer ID/App Store)
- **Transparent Command Execution** - All commands require explicit confirmation

### 🎨 Design

- **Apple HIG Compliant** - Follows Human Interface Guidelines for macOS Sequoia
- **Ultra-Thin Material** - Modern translucent blur effects
- **SF Symbols** - Native iconography throughout
- **Dynamic Window** - Automatically expands when showing responses

### 🛠️ Technical Details

- Built with Swift 6.0
- macOS 15.0 (Sequoia) SDK
- SwiftUI + AppKit integration
- Full concurrency support with @MainActor
- 1.3 MB executable, 312 KB compressed

## 📦 Installation

### Option 1: Download & Install
1. Download `ClaudeSpotlight-v1.0.0-macOS.zip`
2. Unzip the file
3. Move `ClaudeSpotlight.app` to your Applications folder
4. Set your API key: `export ANTHROPIC_API_KEY="your-key"`
5. Launch the app

### Option 2: Build from Source
```bash
git clone https://github.com/yash1511-bogam/ClaudeSpotlight.git
cd ClaudeSpotlight
./build-app.sh
open .build/ClaudeSpotlight.app
```

## 🔑 Setup

Get your API key from [console.anthropic.com](https://console.anthropic.com) and set it:

```bash
export ANTHROPIC_API_KEY="your-api-key-here"
```

For persistent setup:
```bash
echo 'export ANTHROPIC_API_KEY="your-key"' >> ~/.zshrc
source ~/.zshrc
```

## 🎮 Usage

1. **Launch** - Open the app (it appears in menu bar)
2. **Invoke** - Press `⌘⇧Space` or click menu bar icon
3. **Ask** - Type your question or request
4. **Execute** - Review and run suggested commands with confirmation

## 📝 System Requirements

- macOS 15.0 (Sequoia) or later
- Apple Silicon or Intel Mac
- Internet connection for Claude API

## 🐛 Known Issues

- First launch may require granting accessibility permissions
- Commands executed via Terminal (sandboxing limitation)

## 🙏 Credits

- Built with [SwiftAnthropic](https://github.com/jamesrochabrun/SwiftAnthropic)
- Powered by [Anthropic Claude API](https://www.anthropic.com/)

## 📄 License

MIT License - See LICENSE file for details

---

**Full Changelog**: https://github.com/yash1511-bogam/ClaudeSpotlight/commits/v1.0.0
