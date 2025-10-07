import Foundation
import SwiftUI
import SwiftAnthropic

enum ClaudeProvider: String, CaseIterable, Codable {
    case anthropic = "Anthropic Direct"
    case vertexAI = "Vertex AI (Google Cloud)"
    case bedrock = "AWS Bedrock"
    
    var icon: String {
        switch self {
        case .anthropic: return "brain.head.profile"
        case .vertexAI: return "cloud"
        case .bedrock: return "cube.transparent"
        }
    }
}

enum MessageRole {
    case user
    case assistant
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let role: MessageRole
    let content: String
    var executableCommands: [ExecutableCommand] = []
}

class AppState: ObservableObject {
    @Published var isWindowVisible = false
    @Published var selectedProvider: ClaudeProvider {
        didSet {
            UserDefaults.standard.set(selectedProvider.rawValue, forKey: "selectedProvider")
        }
    }
    
    init() {
        if let savedProvider = UserDefaults.standard.string(forKey: "selectedProvider"),
           let provider = ClaudeProvider(rawValue: savedProvider) {
            self.selectedProvider = provider
        } else {
            self.selectedProvider = .anthropic
        }
    }
}

@MainActor
class ClaudeViewModel: ObservableObject {
    @Published var inputText = ""
    @Published var response = ""
    @Published var isLoading = false
    @Published var messages: [ChatMessage] = []
    @Published var currentProvider: ClaudeProvider
    @Published var commandExecutionEnabled = true
    
    private var anthropicService: AnthropicService?
    private let commandExecutor = CommandExecutor.shared
    
    init(provider: ClaudeProvider = .anthropic) {
        self.currentProvider = provider
        self.anthropicService = AnthropicService(provider: provider)
    }
    
    func updateProvider(_ provider: ClaudeProvider) {
        self.currentProvider = provider
        self.anthropicService = AnthropicService(provider: provider)
    }
    
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard anthropicService != nil else {
            let errorMsg = getProviderErrorMessage()
            messages.append(ChatMessage(role: .assistant, content: errorMsg))
            response = errorMsg
            return
        }
        
        let userMessage = inputText
        messages.append(ChatMessage(role: .user, content: userMessage))
        inputText = ""
        isLoading = true
        
        Task {
            let result = await anthropicService?.sendMessage(userMessage)
            if let result = result {
                let commands = commandExecutor.extractCommands(from: result)
                var message = ChatMessage(role: .assistant, content: result)
                message.executableCommands = commands
                messages.append(message)
                response = result
            }
            isLoading = false
        }
    }
    
    func executeCommand(_ command: ExecutableCommand, messageId: UUID) {
        guard let messageIndex = messages.firstIndex(where: { $0.id == messageId }) else { return }
        guard let commandIndex = messages[messageIndex].executableCommands.firstIndex(where: { $0.id == command.id }) else { return }
        
        messages[messageIndex].executableCommands[commandIndex].isExecuting = true
        
        commandExecutor.execute(command.command) { [weak self] output, exitCode in
            guard let self = self else { return }
            
            Task { @MainActor in
                if let msgIndex = self.messages.firstIndex(where: { $0.id == messageId }),
                   let cmdIndex = self.messages[msgIndex].executableCommands.firstIndex(where: { $0.id == command.id }) {
                    self.messages[msgIndex].executableCommands[cmdIndex].isExecuting = false
                    self.messages[msgIndex].executableCommands[cmdIndex].output = output
                    self.messages[msgIndex].executableCommands[cmdIndex].exitCode = Int(exitCode)
                }
            }
        }
    }
    
    private func getProviderErrorMessage() -> String {
        switch currentProvider {
        case .anthropic:
            return "Error: ANTHROPIC_API_KEY not configured. Set it as environment variable."
        case .vertexAI:
            return "Error: Vertex AI not configured. Set GCP_PROJECT_ID and GCP_REGION environment variables."
        case .bedrock:
            return "Error: AWS Bedrock not configured. Set AWS credentials (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION)."
        }
    }
}

class AnthropicService {
    private let provider: ClaudeProvider
    private var anthropicClient: SwiftAnthropic.AnthropicService?
    private var isConfigured: Bool = false
    
    init(provider: ClaudeProvider) {
        self.provider = provider
        
        switch provider {
        case .anthropic:
            if let apiKey = ProcessInfo.processInfo.environment["ANTHROPIC_API_KEY"] {
                self.anthropicClient = AnthropicServiceFactory.service(apiKey: apiKey, betaHeaders: nil)
                self.isConfigured = true
                print("✅ Anthropic Direct API configured")
            } else {
                print("⚠️ ANTHROPIC_API_KEY not found")
            }
            
        case .vertexAI:
            if let projectId = ProcessInfo.processInfo.environment["GCP_PROJECT_ID"] {
                let region = ProcessInfo.processInfo.environment["GCP_REGION"] ?? "global"
                print("✅ Vertex AI configured: \(projectId) in \(region)")
                print("ℹ️  Note: Vertex AI support requires additional setup. See documentation.")
                self.isConfigured = false
            } else {
                print("⚠️ GCP_PROJECT_ID not found. Set GCP_PROJECT_ID and optionally GCP_REGION (defaults to 'global')")
            }
            
        case .bedrock:
            let awsRegion = ProcessInfo.processInfo.environment["AWS_REGION"] ?? "us-west-2"
            if ProcessInfo.processInfo.environment["AWS_ACCESS_KEY_ID"] != nil,
               ProcessInfo.processInfo.environment["AWS_SECRET_ACCESS_KEY"] != nil {
                print("✅ AWS Bedrock credentials found in \(awsRegion)")
                print("ℹ️  Note: Bedrock support requires additional setup. See documentation.")
                self.isConfigured = false
            } else {
                print("⚠️ AWS credentials not found. Set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and optionally AWS_REGION (defaults to 'us-west-2')")
            }
        }
    }
    
    func sendMessage(_ message: String) async -> String {
        switch provider {
        case .anthropic:
            guard let client = anthropicClient else {
                return "Error: Anthropic API client not initialized. Set ANTHROPIC_API_KEY environment variable."
            }
            return await sendAnthropicMessage(message, client: client)
            
        case .vertexAI:
            return """
            ⚠️ Vertex AI Integration
            
            Vertex AI support is configured but requires the Anthropic Python/TypeScript SDK for full functionality.
            
            To use Vertex AI with Claude:
            1. Ensure you have GCP_PROJECT_ID and GCP_REGION environment variables set
            2. Authenticate: gcloud auth application-default login
            3. Use the Python/TypeScript Anthropic SDK with AnthropicVertex client
            
            Model: claude-sonnet-4-5@20250929
            Region: \(ProcessInfo.processInfo.environment["GCP_REGION"] ?? "global")
            Project: \(ProcessInfo.processInfo.environment["GCP_PROJECT_ID"] ?? "not set")
            
            See README for complete setup instructions.
            """
            
        case .bedrock:
            return """
            ⚠️ AWS Bedrock Integration
            
            Bedrock support is configured but requires the Anthropic Python/TypeScript SDK for full functionality.
            
            To use AWS Bedrock with Claude:
            1. Ensure AWS credentials are configured (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION)
            2. Subscribe to Anthropic models in AWS Bedrock console
            3. Use the Python/TypeScript Anthropic SDK with AnthropicBedrock client
            
            Model: global.anthropic.claude-sonnet-4-5-20250929-v1:0
            Region: \(ProcessInfo.processInfo.environment["AWS_REGION"] ?? "us-west-2")
            
            See README for complete setup instructions.
            """
        }
    }
    
    private func sendAnthropicMessage(_ message: String, client: SwiftAnthropic.AnthropicService) async -> String {
        do {
            let parameters = MessageParameter(
                model: .claude35Sonnet,
                messages: [.init(role: .user, content: .text(message))],
                maxTokens: 4096
            )
            
            let stream = try await client.streamMessage(parameters)
            var fullResponse = ""
            
            for try await chunk in stream {
                if chunk.type == "content_block_delta", let delta = chunk.delta, let text = delta.text {
                    fullResponse += text
                }
            }
            
            return fullResponse.isEmpty ? "No response received" : fullResponse
        } catch {
            return "Error: \(error.localizedDescription)"
        }
    }
}
