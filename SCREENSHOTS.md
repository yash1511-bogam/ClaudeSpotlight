# ClaudeSpotlight Visual Guide

## UI Preview (ASCII Art)

### Menu Bar Icon
```
┌─────────────────────────────────────────────────────────┐
│  🍎 File Edit View ...              🔋 📶 🔔 🧠 ⏰  11:30 │
└─────────────────────────────────────────────────────────┘
                                             ↑
                                    ClaudeSpotlight Icon
```

### Main Window (Closed State)
The app runs silently in the background with just the menu bar icon visible.

### Main Window (Open State)

```
                    ┌────────────────────────────────────────────┐
                    │  ╭──────────────────────────────────────╮  │
                    │  │                                      │  │
                    │  │  🧠  Ask Claude Code...              │  │
                    │  │                                      │  │
                    │  ╰──────────────────────────────────────╯  │
                    └────────────────────────────────────────────┘
                               Floating Search Bar
```

### With User Input

```
┌────────────────────────────────────────────────────────────────┐
│  ╭──────────────────────────────────────────────────────────╮  │
│  │                                                          │  │
│  │  🧠  Explain how async/await works in Swift          ⏳  │
│  │                                                          │  │
│  ╰──────────────────────────────────────────────────────────╯  │
└────────────────────────────────────────────────────────────────┘
                        Loading State
```

### Full Conversation View

```
┌─────────────────────────────────────────────────────────────────────┐
│  ╭───────────────────────────────────────────────────────────────╮  │
│  │                                                               │  │
│  │  🧠  Ask Claude Code...                                       │  │
│  │                                                               │  │
│  ╰───────────────────────────────────────────────────────────────╯  │
│  ─────────────────────────────────────────────────────────────────  │
│  ╭───────────────────────────────────────────────────────────────╮  │
│  │  You                                                          │  │
│  │  ┌─────────────────────────────────────────────────────────┐ │  │
│  │  │ Explain how async/await works in Swift                  │ │  │
│  │  └─────────────────────────────────────────────────────────┘ │  │
│  │                                                               │  │
│  │  Claude                                                       │  │
│  │  ┌─────────────────────────────────────────────────────────┐ │  │
│  │  │ Async/await in Swift is a modern concurrency feature    │ │  │
│  │  │ that makes asynchronous code look and behave like       │ │  │
│  │  │ synchronous code. Here's how it works:                  │ │  │
│  │  │                                                          │ │  │
│  │  │ 1. `async` marks functions that can suspend execution   │ │  │
│  │  │ 2. `await` marks suspension points                      │ │  │
│  │  │ 3. Code runs on cooperative thread pool                 │ │  │
│  │  │                                                          │ │  │
│  │  │ Example:                                                 │ │  │
│  │  │ ```swift                                                 │ │  │
│  │  │ func fetchData() async throws -> Data {                 │ │  │
│  │  │     let data = await URLSession.shared.data(...)        │ │  │
│  │  │     return data                                          │ │  │
│  │  │ }                                                        │ │  │
│  │  │ ```                                                      │ │  │
│  │  └─────────────────────────────────────────────────────────┘ │  │
│  ╰───────────────────────────────────────────────────────────────╯  │
└─────────────────────────────────────────────────────────────────────┘
              Chat Interface with Conversation History
```

## UI Components

### 1. Search Bar
```
╭──────────────────────────────────────────────────────╮
│  🧠  [User types here...]                          ⏳ │
╰──────────────────────────────────────────────────────╯
│   │                                                │
│   └─ Brain Icon                                    └─ Loading Spinner
└─ Translucent Background with Blur
```

### 2. User Message Bubble
```
You
┌─────────────────────────────────────────────────┐
│  Write a Python function to sort a list         │
│                                                  │
└─────────────────────────────────────────────────┘
   Blue tint background (#0000FF with 10% opacity)
```

### 3. Assistant Message Bubble
```
Claude
┌─────────────────────────────────────────────────┐
│  Here's a Python function to sort a list:       │
│                                                  │
│  ```python                                       │
│  def sort_list(items):                           │
│      return sorted(items)                        │
│  ```                                             │
│                                                  │
│  This uses Python's built-in sorted()...        │
└─────────────────────────────────────────────────┘
   Purple tint background (#800080 with 10% opacity)
```

## Window Behavior

### Showing Window
```
Trigger: ⌘⇧Space or Click Menu Icon
       ↓
┌─────────────────┐
│  Status Bar     │
│  ┌───┐          │
│  │🧠 │ ← Click  │
│  └─┬─┘          │
└────┼────────────┘
     ↓
┌────▼─────────────────┐
│  Popover appears     │
│  with animation      │
│  Auto-focus enabled  │
└──────────────────────┘
```

### Hiding Window
```
Triggers:
1. Click outside window
2. Press ESC key
3. Click menu icon again
        ↓
┌───────────────────────┐
│  Window fades out     │
│  with animation       │
└───────────────────────┘
```

## Color Scheme

### Light Mode
```
Background:     White with blur (#FFFFFF + blur effect)
Search Bar:     System background
User Bubble:    Blue tint (#007AFF with 10% opacity)
Claude Bubble:  Purple tint (#AF52DE with 10% opacity)
Text:           System primary
Icon:           Purple (#AF52DE)
```

### Dark Mode
```
Background:     Dark with blur (#1C1C1E + blur effect)
Search Bar:     System background
User Bubble:    Blue tint (#0A84FF with 10% opacity)
Claude Bubble:  Purple tint (#BF5AF2 with 10% opacity)
Text:           System primary
Icon:           Purple (#BF5AF2)
```

## Animations

### Window Appearance
```
State 0: Hidden
         ↓ 0.2s ease-out
State 1: Fade in (opacity 0 → 1)
         ↓ 0.2s spring
State 2: Scale up (0.95 → 1.0)
         ↓
Final:   Fully visible + focused
```

### Message Sending
```
User types and hits Enter
         ↓
Message appears instantly
         ↓ 0.15s ease-in
Scrolls to bottom
         ↓
Loading indicator shows
         ↓
Response streams in
         ↓ Real-time
Text appears incrementally
         ↓
Loading indicator hides
```

### Typing Indicator
```
⏳ ← Spinning animation (system default)
```

## Responsive Design

### Minimum Width
```
┌────────────────────┐
│  🧠  Ask...     ⏳ │  ← 400px minimum
└────────────────────┘
```

### Comfortable Width
```
┌─────────────────────────────────────────────┐
│  🧠  Ask Claude Code...                  ⏳ │  ← 600px default
└─────────────────────────────────────────────┘
```

### Maximum Width
```
┌──────────────────────────────────────────────────────────┐
│  🧠  Ask Claude Code...                               ⏳ │  ← 800px max
└──────────────────────────────────────────────────────────┘
```

### Height Adjustment
```
Initial:    70px  (search bar only)
            ↓
With 1 msg: 150px
            ↓
With 3 msg: 300px
            ↓
Maximum:    400px (then scrollable)
```

## Keyboard Navigation

```
┌─────────────────────────────────────────┐
│  State: Window Hidden                   │
│  ⌘⇧Space → Show window                  │
└─────────────────────────────────────────┘
         ↓
┌─────────────────────────────────────────┐
│  State: Window Visible                  │
│  Type → Enter text                      │
│  Enter → Send message                   │
│  ESC → Hide window                      │
│  ⌘Q → Quit app                          │
└─────────────────────────────────────────┘
```

## Visual Effects

### Blur Effect (NSVisualEffectView)
```
Material: .hudWindow
Blending: .behindWindow
State:    .active

Result:   Frosted glass appearance
          with dynamic system backdrop
```

### Shadow
```
Radius:   20pt
Opacity:  30%
Offset:   (0, 10)

Creates floating window effect
```

### Corner Radius
```
Window:        12pt (rounded corners)
Message Bubble: 8pt (slightly rounded)
```

## System Integration

```
┌──────────────────────────────────────┐
│  macOS System                        │
│  ┌────────────────────────────────┐  │
│  │  Status Bar (NSStatusBar)     │  │
│  └──────────┬─────────────────────┘  │
│             ↓                         │
│  ┌──────────▼─────────────────────┐  │
│  │  ClaudeSpotlight              │  │
│  │  (NSApplication + SwiftUI)    │  │
│  └──────────┬─────────────────────┘  │
│             ↓                         │
│  ┌──────────▼─────────────────────┐  │
│  │  Popover Window               │  │
│  │  (NSPopover + HostingView)    │  │
│  └───────────────────────────────┘  │
└──────────────────────────────────────┘
```

## Accessibility

- VoiceOver compatible (structure)
- Keyboard-only navigation
- System font sizes respected
- High contrast support (planned)
- Reduced motion support (planned)

## Real-World Usage Example

```
1. User presses ⌘⇧Space
   ┌─────────────────────────────┐
   │  🧠  Ask Claude Code...     │
   └─────────────────────────────┘

2. Types: "debug this react hook"
   ┌────────────────────────────────────┐
   │  🧠  debug this react hook         │
   └────────────────────────────────────┘

3. Presses Enter
   ┌────────────────────────────────────┐
   │  🧠  Ask Claude Code...          ⏳ │
   ├────────────────────────────────────┤
   │  You                               │
   │  ┌──────────────────────────────┐  │
   │  │ debug this react hook        │  │
   │  └──────────────────────────────┘  │
   └────────────────────────────────────┘

4. Claude responds (streaming)
   ┌────────────────────────────────────┐
   │  🧠  Ask Claude Code...            │
   ├────────────────────────────────────┤
   │  You                               │
   │  ┌──────────────────────────────┐  │
   │  │ debug this react hook        │  │
   │  └──────────────────────────────┘  │
   │  Claude                            │
   │  ┌──────────────────────────────┐  │
   │  │ I'll help you debug that...  │  │
   │  │ Common React hook issues:    │  │
   │  │ 1. Dependency array...       │  │
   │  └──────────────────────────────┘  │
   └────────────────────────────────────┘

5. User asks follow-up
   [Conversation continues...]
```

---

**Note**: Actual appearance will match your system theme and settings for the most native macOS experience.
