import Foundation
import SwiftUI
import SwiftAnthropic

enum MessageRole {
    case user
    case assistant
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let role: MessageRole
    let content: String
}

class AppState: ObservableObject {
    @Published var isWindowVisible = false
}

@MainActor
class ClaudeViewModel: ObservableObject {
    @Published var inputText = ""
    @Published var response = ""
    @Published var isLoading = false
    @Published var messages: [ChatMessage] = []
    
    private var anthropicService: AnthropicService?
    private let apiKey: String
    
    init() {
        if let key = ProcessInfo.processInfo.environment["ANTHROPIC_API_KEY"] {
            self.apiKey = key
            self.anthropicService = AnthropicService(apiKey: key)
        } else {
            self.apiKey = ""
            print("⚠️ ANTHROPIC_API_KEY not found in environment variables")
        }
    }
    
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard anthropicService != nil else {
            response = "Error: API key not configured. Set ANTHROPIC_API_KEY environment variable."
            return
        }
        
        let userMessage = inputText
        messages.append(ChatMessage(role: .user, content: userMessage))
        inputText = ""
        isLoading = true
        
        Task {
            do {
                let result = await anthropicService?.sendMessage(userMessage)
                if let result = result {
                    messages.append(ChatMessage(role: .assistant, content: result))
                    response = result
                }
            }
            isLoading = false
        }
    }
}

class AnthropicService {
    private let service: AnthropicServiceProtocol
    
    init(apiKey: String) {
        self.service = AnthropicServiceFactory.service(apiKey: apiKey)
    }
    
    func sendMessage(_ message: String) async -> String {
        do {
            let parameters = MessageParameter(
                model: .claude3_5_Sonnet,
                messages: [.init(role: .user, content: .text(message))],
                maxTokens: 4096
            )
            
            let stream = try await service.streamMessage(parameters)
            var fullResponse = ""
            
            for try await chunk in stream {
                switch chunk.type {
                case .contentBlockDelta:
                    if let delta = chunk.delta, case .text(let text) = delta {
                        fullResponse += text
                    }
                default:
                    break
                }
            }
            
            return fullResponse.isEmpty ? "No response received" : fullResponse
        } catch {
            return "Error: \(error.localizedDescription)"
        }
    }
}
