import Foundation

struct ExecutableCommand: Identifiable {
    let id = UUID()
    let command: String
    let language: String
    var isExecuting = false
    var output: String?
    var exitCode: Int?
}

enum CommandDangerLevel {
    case safe
    case warning
    case dangerous
    
    var color: String {
        switch self {
        case .safe: return "green"
        case .warning: return "yellow"
        case .dangerous: return "red"
        }
    }
    
    var icon: String {
        switch self {
        case .safe: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .dangerous: return "xmark.octagon.fill"
        }
    }
}

@MainActor
class CommandExecutor {
    static let shared = CommandExecutor()
    
    private let dangerousPatterns = [
        "rm -rf /",
        "rm -rf ~",
        "rm -rf /*",
        "rm -rf $HOME",
        ":(){ :|:& };:",
        "mkfs",
        "dd if=",
        "> /dev/sda",
        "mv / ",
        "chmod -R 777 /",
        "wget.*|.*sh",
        "curl.*|.*sh",
        "eval.*curl",
        "eval.*wget"
    ]
    
    private let warningPatterns = [
        "sudo",
        "rm -rf",
        "rm -r",
        "chmod -R",
        "chown -R",
        "kill -9",
        "pkill",
        "shutdown",
        "reboot",
        "halt",
        "init 0",
        "init 6"
    ]
    
    private init() {}
    
    func analyzeDangerLevel(_ command: String) -> CommandDangerLevel {
        let trimmed = command.trimmingCharacters(in: .whitespacesAndNewlines)
        
        for pattern in dangerousPatterns {
            if trimmed.range(of: pattern, options: .regularExpression) != nil {
                return .dangerous
            }
        }
        
        for pattern in warningPatterns {
            if trimmed.range(of: pattern, options: .regularExpression) != nil {
                return .warning
            }
        }
        
        return .safe
    }
    
    func extractCommands(from text: String) -> [ExecutableCommand] {
        var commands: [ExecutableCommand] = []
        let codeBlockPattern = #"```(bash|sh|shell|zsh|terminal)\n([\s\S]*?)```"#
        
        guard let regex = try? NSRegularExpression(pattern: codeBlockPattern, options: []) else {
            return commands
        }
        
        let matches = regex.matches(in: text, options: [], range: NSRange(text.startIndex..., in: text))
        
        for match in matches {
            if match.numberOfRanges >= 3 {
                if let languageRange = Range(match.range(at: 1), in: text),
                   let commandRange = Range(match.range(at: 2), in: text) {
                    let language = String(text[languageRange])
                    let command = String(text[commandRange]).trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if !command.isEmpty {
                        commands.append(ExecutableCommand(command: command, language: language))
                    }
                }
            }
        }
        
        return commands
    }
    
    func execute(_ command: String, completion: @escaping @Sendable (String, Int32) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let process = Process()
            let outputPipe = Pipe()
            let errorPipe = Pipe()
            
            process.standardOutput = outputPipe
            process.standardError = errorPipe
            process.executableURL = URL(fileURLWithPath: "/bin/zsh")
            process.arguments = ["-c", command]
            
            var output = ""
            var errorOutput = ""
            
            do {
                try process.run()
                
                let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
                let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                
                output = String(data: outputData, encoding: .utf8) ?? ""
                errorOutput = String(data: errorData, encoding: .utf8) ?? ""
                
                process.waitUntilExit()
                
                let exitCode = process.terminationStatus
                let combinedOutput = output + errorOutput
                
                DispatchQueue.main.async {
                    completion(combinedOutput, exitCode)
                }
            } catch {
                DispatchQueue.main.async {
                    completion("Error executing command: \(error.localizedDescription)", -1)
                }
            }
        }
    }
    
    func getDangerWarningMessage(_ level: CommandDangerLevel) -> String {
        switch level {
        case .safe:
            return "This command appears safe to execute."
        case .warning:
            return "⚠️ Warning: This command may modify system files or require elevated privileges."
        case .dangerous:
            return "🛑 DANGER: This command is potentially destructive and may cause data loss or system damage!"
        }
    }
}
