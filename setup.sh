#!/bin/bash
# MCP Server Slack Extended - Setup Script
# Enables Cursor → Slack communication
#
# Usage:
#   curl -sL https://raw.githubusercontent.com/familyoneInc/mcp-server-slack-extended/main/setup.sh | bash

set -e

INSTALL_DIR="$HOME/.cursor/mcp-servers/mcp-server-slack-extended"

echo "🚀 Installing MCP Server Slack Extended..."
echo ""

# Clone or update
if [ -d "$INSTALL_DIR" ]; then
  echo "📦 Updating existing installation..."
  cd "$INSTALL_DIR"
  git pull
else
  echo "📦 Cloning repository..."
  mkdir -p "$(dirname "$INSTALL_DIR")"
  git clone https://github.com/familyoneInc/mcp-server-slack-extended.git "$INSTALL_DIR"
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
echo "  \"slack-extended\": {"
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
