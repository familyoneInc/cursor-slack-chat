#!/bin/bash
# Cursor Slack Chat - Setup Script
# Chat with your team on Slack directly from Cursor
#
# Usage:
#   curl -sL https://raw.githubusercontent.com/familyoneInc/cursor-slack-chat/main/setup.sh | bash

set -e

INSTALL_DIR="$HOME/.cursor/mcp-servers/cursor-slack-chat"
MCP_CONFIG="$HOME/.cursor/mcp.json"

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║           🚀 Cursor Slack Chat Installer                  ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Clone or update
if [ -d "$INSTALL_DIR" ]; then
  echo "📦 Updating existing installation..."
  cd "$INSTALL_DIR"
  git pull --quiet
else
  echo "📦 Cloning repository..."
  mkdir -p "$(dirname "$INSTALL_DIR")"
  git clone --quiet https://github.com/familyoneInc/cursor-slack-chat.git "$INSTALL_DIR"
  cd "$INSTALL_DIR"
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install --silent 2>/dev/null

echo ""
echo "✅ Installation complete!"
echo ""

# Generate the config snippet with correct path
CONFIG_SNIPPET=$(cat <<EOF
    "cursor-slack-chat": {
      "command": "node",
      "args": ["$INSTALL_DIR/index.js"],
      "env": {
        "SLACK_BOT_TOKEN": "xoxb-YOUR-BOT-TOKEN-HERE"
      }
    }
EOF
)

# Check if mcp.json exists
if [ -f "$MCP_CONFIG" ]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📝 Add this inside \"mcpServers\" in $MCP_CONFIG:"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📝 Create $MCP_CONFIG with this content:"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "{"
  echo "  \"mcpServers\": {"
fi

echo ""
echo "$CONFIG_SNIPPET"
echo ""

if [ ! -f "$MCP_CONFIG" ]; then
  echo "  }"
  echo "}"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚠️  Replace xoxb-YOUR-BOT-TOKEN-HERE with your team's token"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🔑 Don't have the token? Ask your team admin or check:"
echo "   - Slack app settings: https://api.slack.com/apps"
echo "   - Team password manager"
echo "   - Internal documentation"
echo ""
echo "🔄 After adding the config, restart Cursor to activate."
echo ""
