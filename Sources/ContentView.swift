import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ClaudeViewModel()
    @StateObject private var appState = AppState()
    @FocusState private var isInputFocused: Bool
    @State private var showProviderMenu = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
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
                        .font(.title2)
                        .foregroundColor(.purple)
                }
                .menuStyle(.borderlessButton)
                .frame(width: 30)
                
                TextField("Ask Claude Code...", text: $viewModel.inputText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 18))
                    .focused($isInputFocused)
                    .onSubmit {
                        viewModel.sendMessage()
                    }
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(0.7)
                }
            }
            .padding()
            .background(Color(nsColor: .windowBackgroundColor))
            
            if !viewModel.response.isEmpty {
                Divider()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message, viewModel: viewModel)
                        }
                    }
                    .padding()
                }
                .frame(maxHeight: 500)
            }
        }
        .frame(width: 600)
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 20)
        .onAppear {
            isInputFocused = true
            viewModel.updateProvider(appState.selectedProvider)
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    @ObservedObject var viewModel: ClaudeViewModel
    @State private var showCommandConfirmation = false
    @State private var selectedCommand: ExecutableCommand?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(message.role == .user ? "You" : "Claude")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Text(message.content)
                .font(.system(size: 14))
                .textSelection(.enabled)
                .padding(10)
                .background(
                    message.role == .user 
                        ? Color.blue.opacity(0.1)
                        : Color.purple.opacity(0.1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
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
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "terminal")
                    .font(.caption)
                Text(command.language.uppercased())
                    .font(.caption)
                    .fontWeight(.semibold)
                
                Spacer()
                
                let dangerLevel = CommandExecutor.shared.analyzeDangerLevel(command.command)
                Image(systemName: dangerLevel.icon)
                    .font(.caption)
                    .foregroundColor(dangerLevel == .safe ? .green : dangerLevel == .warning ? .orange : .red)
                
                if command.isExecuting {
                    ProgressView()
                        .scaleEffect(0.6)
                } else if command.output != nil {
                    Image(systemName: command.exitCode == 0 ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(command.exitCode == 0 ? .green : .red)
                        .font(.caption)
                } else {
                    Button("Run") {
                        onExecute()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                }
            }
            
            Text(command.command)
                .font(.system(size: 12, design: .monospaced))
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(nsColor: .textBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
            if let output = command.output {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "arrow.right")
                            .font(.caption2)
                        Text("Output:")
                            .font(.caption)
                            .fontWeight(.semibold)
                        if let exitCode = command.exitCode {
                            Text("(exit code: \(exitCode))")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(output)
                            .font(.system(size: 11, design: .monospaced))
                            .textSelection(.enabled)
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxHeight: 150)
                    .background(Color(nsColor: .textBackgroundColor).opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
        }
        .padding(10)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
