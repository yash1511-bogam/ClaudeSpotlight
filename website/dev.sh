#!/bin/bash

echo "🚀 Starting ClaudeSpotlight Website..."
echo ""

# Check if bun is installed
if ! command -v bun &> /dev/null
then
    echo "❌ Bun is not installed. Please install it from https://bun.sh"
    exit 1
fi

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    bun install
    echo ""
fi

echo "✨ Starting development server..."
echo "🌐 Open http://localhost:3000 in your browser"
echo ""

bun dev
