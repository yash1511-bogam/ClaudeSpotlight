import SwiftUI
import ServiceManagement

@main
struct ClaudeSpotlightApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var floatingPanel: FloatingPanel?
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Run as accessory app (no dock icon)
        NSApplication.shared.setActivationPolicy(.accessory)
        
        // Create menu bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "brain.head.profile", accessibilityDescription: "Claude Spotlight")
            button.action = #selector(togglePanel)
        }
        
        // Create floating panel
        floatingPanel = FloatingPanel(contentRect: NSRect(x: 0, y: 0, width: 640, height: 80),
                                     styleMask: [.borderless, .nonactivatingPanel],
                                     backing: .buffered,
                                     defer: false)
        
        let contentView = ContentView()
        floatingPanel?.contentViewController = NSHostingController(rootView: contentView)
        
        // Monitor clicks outside to close panel
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let panel = self?.floatingPanel, panel.isVisible {
                self?.hidePanel()
            }
        }
        
        setupGlobalKeyboardShortcut()
        enableLaunchAtLogin()
    }
    
    @MainActor
    @objc func togglePanel() {
        if let panel = floatingPanel {
            if panel.isVisible {
                hidePanel()
            } else {
                showPanel()
            }
        }
    }
    
    @MainActor
    func showPanel() {
        guard let panel = floatingPanel else { return }
        
        // Position panel at center-top of screen (Spotlight style)
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let panelWidth: CGFloat = 640
            let panelHeight: CGFloat = 80
            
            // Center horizontally, position in upper third of screen
            let xPosition = screenFrame.origin.x + (screenFrame.width - panelWidth) / 2
            let yPosition = screenFrame.origin.y + screenFrame.height - panelHeight - 120
            
            panel.setFrame(NSRect(x: xPosition, y: yPosition, width: panelWidth, height: panelHeight), display: true)
        }
        
        panel.orderFrontRegardless()
        panel.makeKey()
        
        // Activate app to ensure key events work
        NSApp.activate(ignoringOtherApps: true)
        
        eventMonitor?.start()
    }
    
    @MainActor
    func hidePanel() {
        floatingPanel?.orderOut(nil)
        eventMonitor?.stop()
    }
    
    func setupGlobalKeyboardShortcut() {
        // Listen for Cmd+Shift+Space (like Spotlight)
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            // Cmd+Shift+Space: keyCode 49 is Space
            if event.modifierFlags.contains([.command, .shift]) && event.keyCode == 49 {
                Task { @MainActor [weak self] in
                    self?.togglePanel()
                }
            }
        }
        
        // Also listen for local key events (when app is active)
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.modifierFlags.contains([.command, .shift]) && event.keyCode == 49 {
                Task { @MainActor [weak self] in
                    self?.togglePanel()
                }
                return nil
            }
            // Escape key to close
            if event.keyCode == 53 {
                Task { @MainActor [weak self] in
                    self?.hidePanel()
                }
                return nil
            }
            return event
        }
    }
    
    func enableLaunchAtLogin() {
        if #available(macOS 13.0, *) {
            try? SMAppService.mainApp.register()
        }
    }
}

// MARK: - Floating Panel (Spotlight-style)
class FloatingPanel: NSPanel {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        // Panel configuration for Spotlight-like behavior
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.isFloatingPanel = true
        self.isMovableByWindowBackground = false
        self.backgroundColor = .clear
        self.isOpaque = false
        self.hasShadow = true
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.standardWindowButton(.closeButton)?.isHidden = true
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true
        
        // Make panel accept key events
        self.hidesOnDeactivate = false
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
}

class EventMonitor {
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent) -> Void
    
    init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent) -> Void) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }
    
    func stop() {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }
    }
}
