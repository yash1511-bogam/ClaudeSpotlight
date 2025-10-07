# Security Documentation

## Overview

ClaudeSpotlight includes terminal command execution features. This document outlines the security measures implemented and best practices for users.

## Security Features

### 🔒 Command Execution Security

#### 1. **User Confirmation Required**
- **No automatic execution**: All commands require explicit user confirmation
- **Confirmation dialog**: Shows command details before execution
- **Danger level indicator**: Visual warning system for risky commands

#### 2. **Danger Level Analysis**

Commands are analyzed and categorized into three levels:

**🟢 SAFE** - Low risk commands
- Read-only operations (ls, cat, pwd, etc.)
- Safe information gathering
- No system modification

**🟡 WARNING** - Moderate risk commands
- Require elevated privileges (sudo)
- Modify files or directories (rm, chmod, chown)
- Process management (kill, pkill)
- System control (shutdown, reboot)

**🔴 DANGEROUS** - High risk commands
- Destructive operations (rm -rf /, mkfs)
- Fork bombs and malicious patterns
- Direct disk operations (dd if=)
- Piped remote execution (curl | sh)

#### 3. **Pattern Detection**

The app detects dangerous patterns including:
```
rm -rf /        # Root deletion
rm -rf ~        # Home deletion
:(){ :|:& };:   # Fork bomb
mkfs            # Filesystem formatting
dd if=/dev/zero # Disk wiping
curl.*|.*sh     # Remote script execution
sudo rm -rf     # Elevated destructive commands
```

### 🔐 API Key Security

#### Environment Variables Only
```bash
# ✅ CORRECT - Use environment variables
export ANTHROPIC_API_KEY="sk-ant-..."
export AWS_ACCESS_KEY_ID="AKIA..."
export AWS_SECRET_ACCESS_KEY="..."
export GCP_PROJECT_ID="my-project"
```

```swift
// ❌ WRONG - Never hardcode
let apiKey = "sk-ant-hardcoded-key"  // NEVER DO THIS
```

#### Security Measures
- ✅ All credentials from environment variables
- ✅ No credentials in source code
- ✅ No credentials in git history
- ✅ `.gitignore` excludes sensitive files
- ✅ No logging of credentials
- ✅ Credentials never displayed in UI

### 🛡️ Data Privacy

#### Local Processing
- All messages stored in memory only
- No persistent chat history
- No data sent to third parties (except chosen Claude provider)
- App closes = data cleared

#### No Telemetry
- No analytics tracking
- No usage statistics collection
- No crash reporting to external services
- Completely private operation

## Security Best Practices

### For Users

#### 1. **Review Commands Before Execution**
```bash
# Always read the full command
# Understand what it does
# Check for suspicious patterns
```

#### 2. **Never Execute Untrusted Commands**
- Don't blindly run commands from unknown sources
- Verify commands match your intent
- Be skeptical of complex one-liners
- Question commands with pipes and redirects

#### 3. **Use Principle of Least Privilege**
```bash
# ✅ GOOD - Run as regular user
ls -la

# ⚠️ CAREFUL - Only use sudo when necessary
sudo apt update

# ❌ DANGEROUS - Never run destructive commands
sudo rm -rf /
```

#### 4. **Protect Your Credentials**
```bash
# ✅ GOOD - Store in shell profile
echo 'export ANTHROPIC_API_KEY="..."' >> ~/.zshrc

# ⚠️ CAREFUL - Temporary (lost on reboot)
export ANTHROPIC_API_KEY="..."

# ❌ BAD - Never put in scripts or commit to git
ANTHROPIC_API_KEY="..." # in a script file
```

#### 5. **Regular Security Audits**
- Review environment variables periodically
- Rotate API keys regularly
- Check for unauthorized access in provider consoles
- Monitor billing for unusual activity

### For Developers

#### 1. **Credential Management**
```swift
// ✅ CORRECT - From environment
let apiKey = ProcessInfo.processInfo.environment["ANTHROPIC_API_KEY"]

// ❌ WRONG - Hardcoded
let apiKey = "sk-ant-xxxxx"

// ❌ WRONG - From UserDefaults (persists)
UserDefaults.standard.string(forKey: "apiKey")
```

#### 2. **Command Execution Safety**
```swift
// ✅ CORRECT - Analyze danger level
let dangerLevel = CommandExecutor.shared.analyzeDangerLevel(command)

// ✅ CORRECT - Require confirmation
showConfirmationDialog(command, dangerLevel)

// ✅ CORRECT - Sandbox when possible
// Use Process with limited capabilities

// ❌ WRONG - Auto-execute
CommandExecutor.execute(command) // without confirmation
```

#### 3. **Input Validation**
```swift
// ✅ CORRECT - Sanitize and validate
let trimmed = command.trimmingCharacters(in: .whitespacesAndNewlines)
guard !trimmed.isEmpty else { return }

// ✅ CORRECT - Check for dangerous patterns
if isDangerous(command) {
    showWarning()
}
```

#### 4. **Error Handling**
```swift
// ✅ CORRECT - Never expose sensitive data in errors
catch {
    return "Error: Authentication failed"
}

// ❌ WRONG - Leaking credentials
catch {
    return "Error: Failed with key \(apiKey)" // NEVER
}
```

## Detected Vulnerabilities

### Dangerous Command Patterns

| Pattern | Risk | Example | Protection |
|---------|------|---------|------------|
| `rm -rf /` | 🔴 Extreme | System deletion | Blocked with warning |
| `:(){ :\|:& };:` | 🔴 Extreme | Fork bomb | Blocked with warning |
| `mkfs` | 🔴 Extreme | Format disk | Blocked with warning |
| `sudo rm -rf` | 🟡 High | Elevated deletion | Warning shown |
| `curl \| sh` | 🟡 High | Remote execution | Warning shown |
| `shutdown` | 🟡 Moderate | System control | Warning shown |

## Incident Response

### If You Accidentally Executed a Dangerous Command

1. **Immediately**: Press Ctrl+C to cancel (if still running)
2. **Assess**: Check what damage occurred
3. **Backup**: If data loss, stop all write operations
4. **Restore**: From backups if available
5. **Report**: Open GitHub issue with details (redact sensitive info)

### If API Key is Compromised

1. **Immediately**: Revoke the key in provider console
2. **Generate**: Create a new API key
3. **Update**: Change environment variable
4. **Monitor**: Check billing for unauthorized usage
5. **Review**: Audit recent activity in provider logs

## Security Checklist

### Before Each Use
- [ ] Understand what you're asking Claude
- [ ] Review generated commands before running
- [ ] Check danger level indicators
- [ ] Verify command matches your intent
- [ ] Have backups for critical data

### Weekly
- [ ] Review provider billing/usage
- [ ] Check for unusual activity
- [ ] Update app if new version available

### Monthly
- [ ] Rotate API keys
- [ ] Review granted permissions
- [ ] Audit environment variables
- [ ] Update dependencies

### Setup
- [ ] API keys stored in environment variables only
- [ ] Never committed credentials to git
- [ ] Strong passwords on provider accounts
- [ ] 2FA enabled on provider accounts
- [ ] Backup important data regularly

## Reporting Security Issues

Found a security vulnerability? Please report it responsibly:

1. **DO NOT** open a public GitHub issue
2. **Email**: Contact maintainers privately (see GitHub profile)
3. **Include**:
   - Description of vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

We take security seriously and will respond promptly to legitimate concerns.

## Security Audit History

| Date | Version | Audit Type | Findings | Status |
|------|---------|------------|----------|--------|
| 2024-10 | 1.0.0 | Code review | No hardcoded credentials | ✅ Pass |
| 2024-10 | 1.1.0 | Multi-provider | Credentials via env vars | ✅ Pass |
| 2024-10 | 1.2.0 | Command execution | Confirmation required | ✅ Pass |

## Code Security Features

### CommandExecutor.swift
```swift
// Pattern-based danger detection
private let dangerousPatterns = [
    "rm -rf /",
    ":(){ :|:& };:",
    // ... more patterns
]

// Danger level analysis
func analyzeDangerLevel(_ command: String) -> CommandDangerLevel {
    // Checks against known dangerous patterns
}
```

### ClaudeViewModel.swift
```swift
// No auto-execution
func executeCommand(_ command: ExecutableCommand, messageId: UUID) {
    // Only called after user confirmation
}
```

### ContentView.swift
```swift
// Confirmation dialog with danger warning
.alert("Execute Command?", isPresented: $showCommandConfirmation) {
    Button("Cancel", role: .cancel) { }
    Button("Execute", role: .destructive) { /* ... */ }
}
```

## Compliance

### Data Handling
- **GDPR**: No user data collection or storage
- **CCPA**: No personal information sale or sharing
- **SOC 2**: No third-party data processing (except chosen AI provider)

### API Provider Compliance
- **Anthropic**: Subject to Anthropic's terms of service
- **Google Cloud**: Subject to GCP terms of service
- **AWS**: Subject to AWS terms of service

## Disclaimer

⚠️ **User Responsibility**: While we implement security measures, users are ultimately responsible for:
- Commands they choose to execute
- API keys and credentials management
- Compliance with their organization's policies
- Data they input into the system

**Use at your own risk. Always review commands before execution.**

## License

This security documentation is part of ClaudeSpotlight and is covered under the MIT License.

---

**Last Updated**: October 2024  
**Version**: 1.2.0  
**Security Level**: Active Development
