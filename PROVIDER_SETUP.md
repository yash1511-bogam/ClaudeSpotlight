# Claude Provider Setup Guide

ClaudeSpotlight supports three ways to access Claude AI models. Choose the provider that best fits your needs.

## 🧠 Provider Overview

| Provider | Best For | Pricing | Setup Complexity |
|----------|----------|---------|------------------|
| **Anthropic Direct** | Direct API access, latest features | Pay-per-use | ⭐ Easy |
| **Vertex AI (GCP)** | Google Cloud integration, enterprise | GCP billing | ⭐⭐ Moderate |
| **AWS Bedrock** | AWS integration, compliance | AWS billing | ⭐⭐ Moderate |

---

## 1️⃣ Anthropic Direct API (Recommended)

**Status**: ✅ Fully Supported

### Setup

1. **Get API Key**
   - Go to [console.anthropic.com](https://console.anthropic.com)
   - Create an account or sign in
   - Navigate to API Keys
   - Click "Create Key"
   - Copy your key (starts with `sk-ant-`)

2. **Set Environment Variable**
   ```bash
   export ANTHROPIC_API_KEY="sk-ant-your-key-here"
   ```

   For permanent setup:
   ```bash
   echo 'export ANTHROPIC_API_KEY="sk-ant-your-key-here"' >> ~/.zshrc
   source ~/.zshrc
   ```

3. **Launch App**
   - Open ClaudeSpotlight
   - Click the brain icon and select "Anthropic Direct"
   - Start chatting!

### Models Available
- Claude 3.5 Sonnet (default)
- Claude 3 Opus
- Claude 3 Haiku

### Features
- ✅ Streaming responses
- ✅ Full API features
- ✅ Latest models
- ✅ Direct billing control

---

## 2️⃣ Vertex AI (Google Cloud)

**Status**: ⚠️ Configuration Guide (Requires Python/TypeScript SDK)

### Prerequisites
- Google Cloud account
- GCP project with Vertex AI enabled
- gcloud CLI installed

### Setup

1. **Enable Vertex AI**
   ```bash
   gcloud services enable aiplatform.googleapis.com
   ```

2. **Authenticate**
   ```bash
   gcloud auth application-default login
   ```

3. **Set Environment Variables**
   ```bash
   export GCP_PROJECT_ID="your-project-id"
   export GCP_REGION="global"  # or specific region like "us-east1"
   ```

   For permanent setup:
   ```bash
   echo 'export GCP_PROJECT_ID="your-project-id"' >> ~/.zshrc
   echo 'export GCP_REGION="global"' >> ~/.zshrc
   source ~/.zshrc
   ```

### Using with Python SDK

For full Vertex AI support, use the Anthropic Python SDK:

```python
from anthropic import AnthropicVertex

client = AnthropicVertex(
    project_id="your-project-id",
    region="global"  # or specific region
)

message = client.messages.create(
    model="claude-sonnet-4-5@20250929",
    max_tokens=4096,
    messages=[{"role": "user", "content": "Hello!"}]
)
print(message.content)
```

### Available Models

| Model | Vertex AI Model ID |
|-------|-------------------|
| Claude Sonnet 4.5 | claude-sonnet-4-5@20250929 |
| Claude Sonnet 4 | claude-sonnet-4@20250514 |
| Claude Sonnet 3.7 | claude-3-7-sonnet@20250219 |
| Claude Opus 4.1 | claude-opus-4-1@20250805 |
| Claude Haiku 3.5 | claude-3-5-haiku@20241022 |

### Pricing

- **Global endpoints**: Standard pricing
- **Regional endpoints**: +10% premium
- See [GCP Vertex AI Pricing](https://cloud.google.com/vertex-ai/generative-ai/pricing)

### Regions

Available regions:
- `global` (recommended - dynamic routing)
- `us-east1` (US East)
- `europe-west1` (Europe)
- `asia-northeast1` (Asia)

### Swift Integration Notes

The Swift app currently provides configuration guidance. For production use:
1. Set up environment variables as shown
2. Use Python/TypeScript backend with Anthropic SDK
3. Call backend from Swift app via REST API

---

## 3️⃣ AWS Bedrock

**Status**: ⚠️ Configuration Guide (Requires Python/TypeScript SDK)

### Prerequisites
- AWS account
- Bedrock access enabled
- AWS CLI configured
- Subscription to Anthropic models in Bedrock

### Setup

1. **Subscribe to Models**
   - Go to [AWS Bedrock Console](https://console.aws.amazon.com/bedrock/)
   - Navigate to Model Access
   - Request access to Anthropic models
   - Wait for approval (usually immediate)

2. **Configure AWS CLI**
   ```bash
   aws configure
   # Enter your AWS Access Key ID
   # Enter your AWS Secret Access Key
   # Enter default region (e.g., us-west-2)
   ```

3. **Set Environment Variables**
   ```bash
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   export AWS_REGION="us-west-2"
   ```

   For permanent setup:
   ```bash
   echo 'export AWS_ACCESS_KEY_ID="your-access-key"' >> ~/.zshrc
   echo 'export AWS_SECRET_ACCESS_KEY="your-secret-key"' >> ~/.zshrc
   echo 'export AWS_REGION="us-west-2"' >> ~/.zshrc
   source ~/.zshrc
   ```

   **Security Note**: For production, use IAM roles or AWS SSO instead of access keys.

### Using with Python SDK

For full Bedrock support, use the Anthropic Python SDK:

```python
from anthropic import AnthropicBedrock

client = AnthropicBedrock(
    aws_access_key="<access-key>",
    aws_secret_key="<secret-key>",
    aws_region="us-west-2"
)

message = client.messages.create(
    model="global.anthropic.claude-sonnet-4-5-20250929-v1:0",
    max_tokens=4096,
    messages=[{"role": "user", "content": "Hello!"}]
)
print(message.content)
```

### Available Models

| Model | Bedrock Model ID |
|-------|-----------------|
| Claude Sonnet 4.5 (Global) | global.anthropic.claude-sonnet-4-5-20250929-v1:0 |
| Claude Sonnet 4.5 (Regional) | anthropic.claude-sonnet-4-5-20250929-v1:0 |
| Claude Sonnet 4 | anthropic.claude-sonnet-4-20250514-v1:0 |
| Claude Opus 4.1 | anthropic.claude-opus-4-1-20250805-v1:0 |
| Claude Haiku 3.5 | anthropic.claude-3-5-haiku-20241022-v1:0 |

### Model Availability by Region

| Region | Sonnet 4.5 | Opus 4 | Haiku 3.5 |
|--------|-----------|---------|-----------|
| `global` | ✅ | ✅ | ❌ |
| `us` | ✅ | ✅ | ✅ |
| `eu` | ✅ | ❌ | ❌ |
| `apac` | ✅ | ✅ | ✅ |

### Pricing

- **Global endpoints**: Standard pricing
- **Regional endpoints (CRIS)**: +10% premium
- See [AWS Bedrock Pricing](https://aws.amazon.com/bedrock/pricing/)

### Supported Regions

- `us-west-2` (recommended)
- `us-east-1`
- `eu-west-1`
- `ap-southeast-1`

### Swift Integration Notes

The Swift app currently provides configuration guidance. For production use:
1. Set up AWS credentials securely
2. Use Python/TypeScript backend with Anthropic SDK
3. Call backend from Swift app via REST API

---

## 🔄 Switching Providers

In ClaudeSpotlight:
1. Click the provider icon (left of search bar)
2. Select your desired provider from the menu
3. Ensure environment variables are set
4. Start chatting!

The app remembers your last selected provider.

---

## 🔒 Security Best Practices

### API Keys
- ✅ Store in environment variables
- ✅ Use `.env` files for local development
- ✅ Never commit keys to git
- ❌ Don't hardcode in source code

### AWS Credentials
- ✅ Use IAM roles when possible
- ✅ Use temporary credentials (STS)
- ✅ Enable MFA for root account
- ✅ Use AWS SSO for team access
- ❌ Don't share access keys
- ❌ Don't use root credentials

### GCP Credentials
- ✅ Use service accounts
- ✅ Use `gcloud auth application-default login`
- ✅ Limit service account permissions
- ✅ Enable audit logging
- ❌ Don't commit service account JSON files

---

## 🐛 Troubleshooting

### Anthropic Direct

**"API key not configured"**
```bash
# Check if set
echo $ANTHROPIC_API_KEY

# If empty, set it
export ANTHROPIC_API_KEY="your-key"
```

**"Unauthorized" errors**
- Verify key is valid at console.anthropic.com
- Check for typos in environment variable
- Ensure no extra spaces or quotes

### Vertex AI

**"Project ID not found"**
```bash
# Verify project
gcloud projects list

# Set project
export GCP_PROJECT_ID="your-project-id"
```

**"Permission denied"**
```bash
# Re-authenticate
gcloud auth application-default login

# Verify permissions
gcloud projects get-iam-policy $GCP_PROJECT_ID
```

### AWS Bedrock

**"Model not found"**
- Go to Bedrock console
- Check Model Access
- Request access if needed
- Wait for approval

**"Access denied"**
```bash
# Verify credentials
aws sts get-caller-identity

# Check IAM permissions
aws iam list-attached-user-policies --user-name YOUR_USERNAME
```

---

## 📚 Additional Resources

### Anthropic
- [Anthropic Console](https://console.anthropic.com)
- [API Documentation](https://docs.anthropic.com)
- [Pricing](https://www.anthropic.com/pricing)

### Vertex AI
- [Vertex AI Console](https://console.cloud.google.com/vertex-ai)
- [Claude on Vertex AI Docs](https://docs.anthropic.com/en/api/claude-on-vertex-ai)
- [Vertex AI Pricing](https://cloud.google.com/vertex-ai/generative-ai/pricing)

### AWS Bedrock
- [Bedrock Console](https://console.aws.amazon.com/bedrock/)
- [Claude on Bedrock Docs](https://docs.anthropic.com/en/api/claude-on-amazon-bedrock)
- [Bedrock Pricing](https://aws.amazon.com/bedrock/pricing/)

---

## 💡 Tips

1. **Start with Anthropic Direct** - Easiest to set up, no cloud account needed
2. **Use Vertex AI** if you're already on GCP and want unified billing
3. **Use Bedrock** if you're in the AWS ecosystem
4. **Global endpoints** provide best availability and no premium cost
5. **Regional endpoints** required for data residency/compliance
6. **Monitor costs** - Set up billing alerts in your cloud console

---

**Need help?** Open an issue on GitHub or check the main README.md
