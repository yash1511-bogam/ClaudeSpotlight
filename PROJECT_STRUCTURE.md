# ClaudeSpotlight Project Structure

```
ClaudeSpotlight/
│
├── 📱 Sources/                          # Main source code
│   ├── ClaudeSpotlightApp.swift        # App entry point & window management
│   │   ├── @main ClaudeSpotlightApp    # SwiftUI App
│   │   ├── AppDelegate                 # AppKit integration
│   │   └── EventMonitor                # Global event handling
│   │
│   ├── ContentView.swift               # Main UI
│   │   ├── ContentView                 # Primary interface
│   │   ├── MessageBubble               # Chat message display
│   │   └── VisualEffectView            # Blur effects
│   │
│   ├── ClaudeViewModel.swift           # Business logic
│   │   ├── ClaudeViewModel             # State management
│   │   ├── ChatMessage                 # Message model
│   │   ├── MessageRole                 # User/Assistant enum
│   │   ├── AppState                    # Global app state
│   │   └── AnthropicService            # API integration
│   │
│   └── Info.plist                      # App configuration
│       ├── CFBundleIdentifier          # com.claude.spotlight
│       ├── LSUIElement                 # Menu bar app mode
│       └── Bundle metadata
│
├── 📦 Package.swift                     # Swift Package Manager config
│   ├── Platform: macOS 13.0+
│   └── Dependency: SwiftAnthropic
│
├── 📚 Documentation/
│   ├── README.md                       # Main documentation
│   │   ├── Features overview
│   │   ├── Requirements
│   │   ├── Setup instructions
│   │   └── Usage guide
│   │
│   ├── QUICKSTART.md                   # 5-minute setup guide
│   │   ├── API key setup
│   │   ├── Environment config
│   │   ├── Build instructions
│   │   └── First use
│   │
│   ├── BUILD_INSTRUCTIONS.md           # Detailed build guide
│   │   ├── Xcode method
│   │   ├── Command line method
│   │   ├── App bundle creation
│   │   └── Troubleshooting
│   │
│   ├── FEATURES.md                     # Feature specifications
│   │   ├── Current features
│   │   ├── Planned features
│   │   ├── Use cases
│   │   └── Version roadmap
│   │
│   ├── ARCHITECTURE.md                 # Technical architecture
│   │   ├── System design
│   │   ├── Component details
│   │   ├── Data flow
│   │   ├── Tech stack
│   │   └── Extension points
│   │
│   └── PROJECT_STRUCTURE.md            # This file
│
├── 🔧 Scripts/
│   ├── run.sh                          # Launch script
│   │   ├── API key check
│   │   ├── Build if needed
│   │   └── Run app
│   │
│   └── create-xcode-project.sh         # Xcode project generator
│       └── Project file template
│
├── 🚫 .gitignore                        # Git ignore rules
│   ├── Build artifacts
│   ├── Xcode files
│   ├── macOS files
│   └── API keys
│
└── 📄 Additional Files/
    ├── .build/                         # Build output (created)
    │   ├── debug/
    │   └── release/
    │       └── ClaudeSpotlight         # Executable
    │
    └── .swiftpm/                       # SPM cache (created)
```

## File Purposes

### Core Application Files

#### ClaudeSpotlightApp.swift (3,190 bytes)
**Role**: Application lifecycle and system integration

**Key Classes**:
- `ClaudeSpotlightApp`: SwiftUI @main entry point
- `AppDelegate`: NSApplicationDelegate implementation
- `EventMonitor`: Global event monitoring

**Features**:
- Menu bar icon setup
- Global keyboard shortcuts (⌘⇧Space)
- Popover window management
- Launch at login configuration
- Event monitoring for window dismissal

#### ContentView.swift (3,007 bytes)
**Role**: User interface and interaction

**Components**:
- Search bar with brain icon
- Message bubble display
- Scrollable chat history
- Visual blur effects
- Loading indicators

**UI Features**:
- Auto-focus on text field
- Enter to submit
- Gradient message bubbles
- Smooth animations
- Responsive layout

#### ClaudeViewModel.swift (2,893 bytes)
**Role**: Business logic and API communication

**Responsibilities**:
- Message state management
- Claude API integration
- Streaming response handling
- Error management
- Loading state coordination

**Models**:
- `ChatMessage`: Message data structure
- `MessageRole`: User/Assistant enum
- `AppState`: Global state container

#### Info.plist (621 bytes)
**Role**: App configuration

**Key Settings**:
- Bundle identifier: `com.claude.spotlight`
- `LSUIElement`: YES (menu bar app)
- Version information
- Permissions configuration

### Package Management

#### Package.swift (443 bytes)
**Role**: Dependency management

**Configuration**:
- Platform: macOS 13.0+
- Language: Swift 5.9+
- Dependencies:
  - SwiftAnthropic (1.0.0+)

### Documentation Files

#### README.md (3,062 bytes)
Primary documentation with overview, setup, and usage

#### QUICKSTART.md (3,091 bytes)
Fast-track guide for immediate use

#### BUILD_INSTRUCTIONS.md (3,298 bytes)
Comprehensive build documentation

#### FEATURES.md (3,739 bytes)
Feature list and roadmap

#### ARCHITECTURE.md (8,500 bytes)
Technical architecture documentation

#### PROJECT_STRUCTURE.md (This file)
Project organization reference

### Utility Files

#### run.sh (700 bytes)
**Purpose**: Quick launch script
- Checks API key
- Builds if needed
- Launches app

#### .gitignore (610 bytes)
**Purpose**: Version control exclusions
- Build artifacts
- IDE files
- System files
- Sensitive data

## Build Artifacts (Generated)

```
.build/
├── debug/                      # Debug build
│   ├── ClaudeSpotlight        # Debug executable
│   └── *.swiftmodule          # Module files
│
└── release/                    # Release build
    ├── ClaudeSpotlight        # Optimized executable
    └── *.swiftmodule          # Module files
```

## Dependencies (Downloaded)

```
.swiftpm/
└── Package dependencies cache
```

## Total Project Stats

- **Swift Files**: 3
- **Total Lines of Code**: ~250
- **Documentation Files**: 7
- **Total Documentation**: ~20,000 words
- **Dependencies**: 1 (SwiftAnthropic)
- **Supported macOS**: 13.0+

## File Size Distribution

```
Code:        ~9 KB  (Swift source files)
Docs:       ~26 KB  (Markdown documentation)
Config:     ~2 KB   (Package.swift, Info.plist)
Scripts:    ~1 KB   (Shell scripts)
────────────────────
Total:      ~38 KB  (source only, excluding builds)
```

## Development Workflow

### 1. Initial Setup
```
ClaudeSpotlight/
├── Clone or create directory
├── Set ANTHROPIC_API_KEY
└── Open in Xcode or terminal
```

### 2. Development
```
Sources/
├── Edit Swift files
├── Test in Xcode
└── Iterate
```

### 3. Build
```
$ swift build -c release
→ .build/release/ClaudeSpotlight
```

### 4. Run
```
$ ./run.sh
or
$ .build/release/ClaudeSpotlight
```

## Code Organization Principles

### Separation of Concerns
- **App Layer**: Window & lifecycle (AppDelegate)
- **View Layer**: UI components (ContentView)
- **ViewModel Layer**: Business logic (ClaudeViewModel)
- **Service Layer**: API integration (AnthropicService)

### SwiftUI Best Practices
- `@StateObject` for view models
- `@Published` for reactive updates
- `@FocusState` for input management
- Composition over inheritance

### Async/Await
- All API calls use async/await
- Streaming with AsyncSequence
- @MainActor for UI updates

## Extension Guide

### Adding New Features

**New UI Component**:
1. Add to `ContentView.swift`
2. Create new View struct
3. Use existing ViewModel

**New API Feature**:
1. Extend `AnthropicService`
2. Add method to `ClaudeViewModel`
3. Update UI in `ContentView`

**New Settings**:
1. Create `SettingsView.swift`
2. Add `UserDefaults` storage
3. Link in `ClaudeSpotlightApp`

### Testing Structure (Future)

```
Tests/
├── ClaudeSpotlightTests/
│   ├── ViewModelTests.swift
│   ├── ServiceTests.swift
│   └── MockData.swift
└── ClaudeSpotlightUITests/
    ├── WindowTests.swift
    └── InteractionTests.swift
```

## Deployment Structure (Future)

```
ClaudeSpotlight.app/
├── Contents/
│   ├── MacOS/
│   │   └── ClaudeSpotlight         # Binary
│   ├── Resources/
│   │   └── AppIcon.icns           # App icon
│   └── Info.plist                  # Bundle info
```

## Version Control

### Tracked Files
- Source code (Sources/)
- Package manifest (Package.swift)
- Documentation (*.md)
- Scripts (*.sh)
- Configuration (Info.plist)

### Ignored Files
- Build artifacts (.build/)
- Xcode user data (xcuserdata/)
- System files (.DS_Store)
- Package cache (.swiftpm/)

---

**Last Updated**: October 2024  
**Version**: 1.0.0  
**Lines of Code**: ~250  
**Dependencies**: 1
