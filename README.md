# Claude Spotlight

A Mac app that brings Claude Code to your desktop with a Spotlight-like interface.

## Features

- 🎯 Spotlight-style floating window interface
- 🧠 Multiple Claude providers: Anthropic Direct, Vertex AI, AWS Bedrock
- ⌨️ Global keyboard shortcut (⌘⇧Space)
- 🚀 Launch at login support
- 💬 Streaming responses for real-time interaction
- 🎨 Beautiful native macOS design with blur effects
- 🔄 Easy provider switching with dropdown menu

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later
- API key/credentials for chosen provider:
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

3. Build the app using Xcode:
   - Open ClaudeSpotlight.xcodeproj in Xcode
   - Select "ClaudeSpotlight" scheme
   - Build and run (⌘R)

### Alternative Providers

For **Vertex AI** or **AWS Bedrock** setup, see [PROVIDER_SETUP.md](PROVIDER_SETUP.md)

## Building from Command Line

```bash
cd ClaudeSpotlight
swift build -c release
```

## Usage

1. Launch the app - it will appear in your menu bar with a provider icon
2. Click the menu bar icon or press **⌘⇧Space** to open the search window
3. (Optional) Click the provider icon to switch between Anthropic/Vertex/Bedrock
4. Type your question or code request
5. Press Enter to send to Claude
6. View streaming responses in real-time

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

## Technology Stack

- **SwiftUI** - Modern declarative UI framework
- **SwiftAnthropic** - Anthropic API client for Swift
- **ServiceManagement** - Launch at login functionality
- **AppKit** - Native macOS window management

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
