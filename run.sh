#!/bin/bash

# ClaudeSpotlight Launch Script

echo "🧠 ClaudeSpotlight Launcher"
echo "=========================="
echo ""

# Check if API key is set
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "❌ Error: ANTHROPIC_API_KEY not set"
    echo ""
    echo "Please set your API key:"
    echo "  export ANTHROPIC_API_KEY='your-api-key-here'"
    echo ""
    echo "Or add to ~/.zshrc:"
    echo "  echo 'export ANTHROPIC_API_KEY=\"your-key\"' >> ~/.zshrc"
    echo "  source ~/.zshrc"
    exit 1
fi

echo "✅ API key found"
echo ""

# Check if built
if [ ! -f ".build/release/ClaudeSpotlight" ]; then
    echo "🔨 Building ClaudeSpotlight..."
    swift build -c release
    
    if [ $? -ne 0 ]; then
        echo "❌ Build failed"
        exit 1
    fi
    echo "✅ Build successful"
fi

echo ""
echo "🚀 Launching ClaudeSpotlight..."
echo "   - Look for the brain icon in menu bar"
echo "   - Press ⌘⇧Space to open"
echo "   - Press Ctrl+C here to quit"
echo ""

.build/release/ClaudeSpotlight
