#!/bin/bash
# Cursor Slack Chat - Setup Script
# Chat with your team on Slack directly from Cursor
#
# Usage:
#   curl -sL https://raw.githubusercontent.com/familyoneInc/cursor-slack-chat/main/setup.sh | bash

set -e

INSTALL_DIR="$HOME/.cursor/mcp-servers/cursor-slack-chat"

echo "🚀 Installing Cursor Slack Chat..."
echo ""

# Clone or update
if [ -d "$INSTALL_DIR" ]; then
  echo "📦 Updating existing installation..."
  cd "$INSTALL_DIR"
  git pull
else
  echo "📦 Cloning repository..."
  mkdir -p "$(dirname "$INSTALL_DIR")"
  git clone https://github.com/familyoneInc/cursor-slack-chat.git "$INSTALL_DIR"
  cd "$INSTALL_DIR"
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install --silent

echo ""
echo "✅ Installation complete!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Next step: Add this to your ~/.cursor/mcp.json"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  \"cursor-slack-chat\": {"
echo "    \"command\": \"node\","
echo "    \"args\": [\"$INSTALL_DIR/index.js\"],"
echo "    \"env\": {"
echo "      \"SLACK_BOT_TOKEN\": \"xoxb-your-bot-token-here\""
echo "    }"
echo "  }"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Then restart Cursor to activate the new tools."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
