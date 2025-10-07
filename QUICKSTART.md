# Quick Start Guide

Get ClaudeSpotlight running in 5 minutes!

## Step 1: Get API Key (2 minutes)

1. Go to [console.anthropic.com](https://console.anthropic.com)
2. Sign up or log in
3. Navigate to API Keys section
4. Click "Create Key"
5. Copy your API key (starts with `sk-ant-`)

## Step 2: Set Environment Variable (1 minute)

Open Terminal and run:

```bash
echo 'export ANTHROPIC_API_KEY="sk-ant-your-key-here"' >> ~/.zshrc
source ~/.zshrc
```

Or for bash users:

```bash
echo 'export ANTHROPIC_API_KEY="sk-ant-your-key-here"' >> ~/.bash_profile
source ~/.bash_profile
```

**Verify it's set:**
```bash
echo $ANTHROPIC_API_KEY
```

## Step 3: Build the App (2 minutes)

### Option A: Using Xcode (Easiest)

1. Open Xcode
2. File → New → Project
3. Choose: macOS → App
4. Name it: `ClaudeSpotlight`
5. Bundle ID: `com.claude.spotlight`
6. Interface: SwiftUI
7. Click Create

8. Add Package:
   - File → Add Package Dependencies
   - URL: `https://github.com/jamesrochabrun/SwiftAnthropic`
   - Add Package

9. Copy files:
   - Delete default ContentView.swift and ClaudeSpotlightApp.swift
   - Drag all files from `Sources/` into Xcode

10. Configure:
    - Product → Scheme → Edit Scheme
    - Run → Environment Variables → Add
    - Name: `ANTHROPIC_API_KEY`
    - Value: (paste your key)

11. Run:
    - Press ⌘R

### Option B: Command Line

```bash
cd ClaudeSpotlight
swift package resolve
swift build -c release
.build/release/ClaudeSpotlight
```

## Step 4: Use It! (Now!)

1. **Look for the brain icon** in your menu bar
2. **Click it** or press **⌘⇧Space**
3. **Type your question**: "Write a Python function to sort a list"
4. **Press Enter**
5. **Watch Claude respond** in real-time!

## Common Commands to Try

```
"Explain how async/await works in Swift"
"Write a REST API in Python using Flask"
"Debug this code: [paste your code]"
"What's the best way to handle errors in JavaScript?"
"Create a SQL query to join these tables..."
```

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| ⌘⇧Space | Open/Close ClaudeSpotlight |
| Enter | Send message |
| Esc | Close window |
| ⌘Q | Quit app |

## Troubleshooting

### "API key not configured"
```bash
# Check if variable is set
echo $ANTHROPIC_API_KEY

# If empty, set it:
export ANTHROPIC_API_KEY="your-key-here"

# Restart the app
```

### "Module SwiftAnthropic not found"
- In Xcode: File → Add Package Dependencies
- Add: `https://github.com/jamesrochabrun/SwiftAnthropic`

### App doesn't appear in menu bar
- Check Console.app for errors
- Ensure Info.plist has `LSUIElement` = `YES`

### Window doesn't show
- Try clicking menu bar icon
- Try keyboard shortcut: ⌘⇧Space
- Check System Settings → Privacy & Security

## What's Next?

- ⭐ Star the GitHub repo
- 🐛 Report bugs via Issues
- 💡 Suggest features
- 🤝 Contribute improvements

## Need Help?

- 📖 Read full [README.md](README.md)
- 🔧 Check [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)
- ✨ See [FEATURES.md](FEATURES.md)

---

**Tip**: Add to Alfred/Raycast for even faster access!
