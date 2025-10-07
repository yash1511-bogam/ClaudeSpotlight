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
                            MessageBubble(message: message)
                        }
                    }
                    .padding()
                }
                .frame(maxHeight: 400)
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
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
        }
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
