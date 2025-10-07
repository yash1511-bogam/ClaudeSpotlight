# ClaudeSpotlight Architecture

## Overview

ClaudeSpotlight is a native macOS application built with SwiftUI that provides a Spotlight-like interface for interacting with Claude AI.

## System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     macOS System                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │              NSStatusBar (Menu Bar)               │  │
│  └─────────────────┬────────────────────────────────┘  │
│                    │                                     │
│  ┌─────────────────▼────────────────────────────────┐  │
│  │             ClaudeSpotlight App                   │  │
│  │                                                    │  │
│  │  ┌──────────────────────────────────────────┐   │  │
│  │  │         AppDelegate                      │   │  │
│  │  │  - Window Management                     │   │  │
│  │  │  - Global Shortcuts                      │   │  │
│  │  │  - Event Monitoring                      │   │  │
│  │  └──────────────┬───────────────────────────┘   │  │
│  │                 │                                 │  │
│  │  ┌──────────────▼───────────────────────────┐   │  │
│  │  │         ContentView (SwiftUI)            │   │  │
│  │  │  - Search Bar UI                         │   │  │
│  │  │  - Chat Bubbles                          │   │  │
│  │  │  - Visual Effects                        │   │  │
│  │  └──────────────┬───────────────────────────┘   │  │
│  │                 │                                 │  │
│  │  ┌──────────────▼───────────────────────────┐   │  │
│  │  │         ClaudeViewModel                  │   │  │
│  │  │  - Message State                         │   │  │
│  │  │  - API Coordination                      │   │  │
│  │  └──────────────┬───────────────────────────┘   │  │
│  │                 │                                 │  │
│  │  ┌──────────────▼───────────────────────────┐   │  │
│  │  │       AnthropicService                   │   │  │
│  │  │  - API Communication                     │   │  │
│  │  │  - Streaming Handler                     │   │  │
│  │  └──────────────┬───────────────────────────┘   │  │
│  └─────────────────┼────────────────────────────────┘  │
│                    │                                     │
│                    │ HTTPS                               │
└────────────────────┼─────────────────────────────────────┘
                     │
                     ▼
         ┌────────────────────────┐
         │   Anthropic Claude API  │
         │   (api.anthropic.com)   │
         └────────────────────────┘
```

## Component Details

### 1. ClaudeSpotlightApp.swift

**Purpose**: Main app entry point and lifecycle management

**Key Components**:
- `@main struct ClaudeSpotlightApp`: SwiftUI app definition
- `AppDelegate`: NSApplicationDelegate for AppKit integration

**Responsibilities**:
- App initialization
- Menu bar icon setup
- Launch at login configuration
- Settings scene management

### 2. AppDelegate

**Purpose**: Bridge between AppKit and SwiftUI for native macOS features

**Key Features**:
- **Status Item Management**: Creates and manages menu bar icon
- **Popover Control**: Shows/hides floating window
- **Global Shortcuts**: Listens for ⌘⇧Space keyboard combination
- **Event Monitoring**: Detects clicks outside popover to close it
- **Launch at Login**: Registers with SMAppService

**Key Methods**:
```swift
func togglePopover()        // Show/hide window
func showPopover()          // Display window
func closePopover()         // Hide window
func setupGlobalKeyboardShortcut() // Register hotkey
func enableLaunchAtLogin()  // Configure auto-launch
```

### 3. ContentView.swift

**Purpose**: Main UI layout and user interaction

**Components**:
- **Search Bar**: Text input with focus management
- **Message List**: Scrollable chat history
- **Message Bubbles**: Individual message display
- **Visual Effects**: Blur and transparency effects

**UI Hierarchy**:
```
VStack
├── HStack (Search Bar)
│   ├── Brain Icon
│   ├── TextField
│   └── ProgressView (loading)
└── ScrollView (Messages)
    └── VStack (Message Bubbles)
```

**Key Features**:
- Auto-focus on appear
- Submit on Enter key
- Text selection in messages
- Dynamic height adjustment

### 4. ClaudeViewModel.swift

**Purpose**: Business logic and state management

**Pattern**: MVVM (Model-View-ViewModel)

**Published Properties**:
```swift
@Published var inputText: String
@Published var response: String
@Published var isLoading: Bool
@Published var messages: [ChatMessage]
```

**Responsibilities**:
- User input handling
- Message state management
- API request coordination
- Error handling
- Loading state management

**Flow**:
```
User Input → sendMessage() → AnthropicService → Stream Response → Update UI
```

### 5. AnthropicService

**Purpose**: Claude API integration and communication

**Key Features**:
- Streaming response handling
- Error management
- Model configuration
- Token limit management

**API Integration**:
```swift
// Uses SwiftAnthropic library
let parameters = MessageParameter(
    model: .claude3_5_Sonnet,
    messages: [...],
    maxTokens: 4096
)
let stream = try await service.streamMessage(parameters)
```

## Data Flow

### User Query Flow

1. **User Action**: Types question and presses Enter
2. **ContentView**: Captures input via `@FocusState` and `onSubmit`
3. **ViewModel**: `sendMessage()` called
   - Creates `ChatMessage` for user
   - Adds to `messages` array
   - Sets `isLoading = true`
4. **AnthropicService**: Sends request to Claude API
   - Configures model parameters
   - Initiates streaming connection
5. **Response Streaming**:
   - Receives chunks from API
   - Accumulates text
   - Updates UI in real-time
6. **Completion**:
   - Creates `ChatMessage` for assistant
   - Adds to `messages` array
   - Sets `isLoading = false`
7. **UI Update**: SwiftUI re-renders with new messages

### Window Display Flow

1. **Trigger**: User presses ⌘⇧Space or clicks menu bar
2. **EventMonitor**: Detects keyboard event
3. **AppDelegate**: `togglePopover()` called
4. **NSPopover**: Shows relative to status item
5. **ContentView**: Appears with auto-focus
6. **Close Trigger**: 
   - Click outside → EventMonitor detects
   - ESC key → Popover behavior
   - AppDelegate closes popover

## Technology Stack

### Core Frameworks

| Framework | Purpose |
|-----------|---------|
| SwiftUI | Modern declarative UI |
| AppKit | macOS-specific features |
| Combine | Reactive programming |
| ServiceManagement | Launch at login |

### Third-Party Dependencies

| Package | Purpose | Version |
|---------|---------|---------|
| SwiftAnthropic | Claude API client | 1.0.0+ |

### APIs

- **Anthropic Claude API**: AI model access
- **Model**: Claude 3.5 Sonnet
- **Max Tokens**: 4096

## State Management

### App-Level State
```swift
@StateObject private var appState = AppState()
// Shared across app for global state
```

### View-Level State
```swift
@StateObject private var viewModel = ClaudeViewModel()
// Isolated to ContentView and its children
```

### UI State
```swift
@FocusState private var isInputFocused: Bool
// Local UI focus management
```

## Security & Privacy

### API Key Management
- Stored in environment variables
- Never hardcoded
- Not persisted to disk
- Loaded at app launch

### Data Privacy
- No local storage of conversations
- No telemetry or analytics
- All communication over HTTPS
- Session-only memory retention

## Performance Optimizations

### Memory
- Lazy loading of views
- Efficient message array updates
- Minimal state retention

### Network
- Streaming responses (no waiting for full response)
- Async/await for non-blocking operations
- Error retry logic (planned)

### UI
- SwiftUI's automatic optimization
- Minimal re-renders with `@Published`
- Efficient view updates

## Extension Points

### Easy to Add
- [ ] Different Claude models
- [ ] Custom system prompts
- [ ] Message persistence
- [ ] Export functionality

### Moderate Difficulty
- [ ] Multiple conversation tabs
- [ ] Plugin system
- [ ] Custom themes
- [ ] Voice input

### Complex
- [ ] Multi-window support
- [ ] Team collaboration
- [ ] Cloud sync
- [ ] Advanced code execution

## Build System

### Package Manager
- Swift Package Manager (SPM)
- Defined in `Package.swift`

### Build Configurations
- Debug: Development with symbols
- Release: Optimized production build

### Distribution
- Direct download (.app bundle)
- Homebrew (planned)
- Mac App Store (future)

## Testing Strategy

### Unit Tests
- ViewModel logic
- Service layer
- Message formatting

### Integration Tests
- API communication
- Streaming handler
- Error scenarios

### UI Tests
- Window appearance
- Keyboard shortcuts
- User interactions

## Future Architecture Considerations

### Scalability
- Multiple API providers
- Conversation persistence layer
- Settings/preferences system

### Maintainability
- Protocol-based design
- Dependency injection
- Modular components

### Extensibility
- Plugin architecture
- Custom tool integration
- Third-party extensions
