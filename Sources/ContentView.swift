import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ClaudeViewModel()
    @StateObject private var appState = AppState()
    @FocusState private var isInputFocused: Bool
    @State private var showProviderMenu = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Input bar with modern design
            HStack(spacing: 16) {
                // Provider selector
                Menu {
                    ForEach(ClaudeProvider.allCases, id: \.self) { provider in
                        Button {
                            appState.selectedProvider = provider
                            viewModel.updateProvider(provider)
                        } label: {
                            HStack {
                                Image(systemName: provider.icon)
                                Text(provider.rawValue)
                                if appState.selectedProvider == provider {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: appState.selectedProvider.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.purple)
                        .frame(width: 32, height: 32)
                }
                .menuStyle(.borderlessButton)
                .buttonStyle(.plain)
                
                // Search field
                TextField("Ask Claude...", text: $viewModel.inputText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 16))
                    .focused($isInputFocused)
                    .onSubmit {
                        viewModel.sendMessage()
                    }
                
                // Loading indicator
                if viewModel.isLoading {
                    ProgressView()
                        .controlSize(.small)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )
            
            // Messages area (expands when needed)
            if !viewModel.response.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message, viewModel: viewModel)
                        }
                    }
                    .padding(20)
                }
                .frame(maxHeight: 500)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                )
                .padding(.top, 8)
            }
        }
        .frame(minWidth: 640, maxWidth: 640)
        .padding(12)
        .onAppear {
            isInputFocused = true
            viewModel.updateProvider(appState.selectedProvider)
        }
        .onChange(of: viewModel.response) {
            // Expand window when response arrives
            if !viewModel.response.isEmpty {
                if let window = NSApp.windows.first {
                    let newHeight: CGFloat = 600
                    var frame = window.frame
                    frame.size.height = newHeight
                    window.setFrame(frame, display: true, animate: true)
                }
            }
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    @ObservedObject var viewModel: ClaudeViewModel
    @State private var showCommandConfirmation = false
    @State private var selectedCommand: ExecutableCommand?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Message header
            HStack(spacing: 6) {
                Image(systemName: message.role == .user ? "person.circle.fill" : "sparkles")
                    .foregroundStyle(message.role == .user ? .blue : .purple)
                    .font(.system(size: 14))
                
                Text(message.role == .user ? "You" : "Claude")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            
            // Message content
            Text(message.content)
                .font(.system(size: 14))
                .textSelection(.enabled)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(message.role == .user 
                            ? Color.blue.opacity(0.08)
                            : Color.purple.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            message.role == .user 
                                ? Color.blue.opacity(0.2)
                                : Color.purple.opacity(0.2),
                            lineWidth: 1
                        )
                )
            
            if !message.executableCommands.isEmpty && message.role == .assistant {
                ForEach(message.executableCommands) { command in
                    CommandExecutionView(
                        command: command,
                        onExecute: {
                            selectedCommand = command
                            showCommandConfirmation = true
                        }
                    )
                }
            }
        }
        .alert("Execute Command?", isPresented: $showCommandConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Execute", role: .destructive) {
                if let cmd = selectedCommand {
                    viewModel.executeCommand(cmd, messageId: message.id)
                }
            }
        } message: {
            if let cmd = selectedCommand {
                let dangerLevel = CommandExecutor.shared.analyzeDangerLevel(cmd.command)
                Text("\(CommandExecutor.shared.getDangerWarningMessage(dangerLevel))\n\nCommand: \(cmd.command)")
            }
        }
    }
}

struct CommandExecutionView: View {
    let command: ExecutableCommand
    let onExecute: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Command header
            HStack(spacing: 8) {
                Image(systemName: "terminal.fill")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                
                Text(command.language.uppercased())
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                // Danger level indicator
                let dangerLevel = CommandExecutor.shared.analyzeDangerLevel(command.command)
                Image(systemName: dangerLevel.icon)
                    .font(.system(size: 11))
                    .foregroundStyle(dangerLevel == .safe ? .green : dangerLevel == .warning ? .orange : .red)
                
                // Status/Action button
                if command.isExecuting {
                    ProgressView()
                        .controlSize(.mini)
                } else if command.output != nil {
                    Image(systemName: command.exitCode == 0 ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundStyle(command.exitCode == 0 ? .green : .red)
                        .font(.system(size: 12))
                } else {
                    Button("Run") {
                        onExecute()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.mini)
                }
            }
            
            // Command text
            Text(command.command)
                .font(.system(size: 12, design: .monospaced))
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.primary.opacity(0.05))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                )
            
            // Command output
            if let output = command.output {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                        
                        Text("Output")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.secondary)
                        
                        if let exitCode = command.exitCode {
                            Text("• Exit code: \(exitCode)")
                                .font(.system(size: 10))
                                .foregroundStyle(.tertiary)
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(output)
                            .font(.system(size: 11, design: .monospaced))
                            .textSelection(.enabled)
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxHeight: 150)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.primary.opacity(0.03))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                    )
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.secondary.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.secondary.opacity(0.15), lineWidth: 1)
        )
    }
}
