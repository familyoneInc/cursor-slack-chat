#!/bin/bash
# Cursor Slack Chat - Setup Script
#
# Usage:
#   curl -sL https://raw.githubusercontent.com/familyoneInc/cursor-slack-chat/main/setup.sh | bash

set -e

INSTALL_DIR="$HOME/.cursor/mcp-servers/cursor-slack-chat"
MCP_CONFIG="$HOME/.cursor/mcp.json"
SETUP_FILE="$HOME/Desktop/cursor-setup.txt"

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║           🚀 Cursor Slack Chat Setup                      ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Ask if this is an admin setup or team member setup
echo "Are you the team admin setting up for the first time? (y/n)"
read -r IS_ADMIN

if [[ "$IS_ADMIN" =~ ^[Yy]$ ]]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "ADMIN SETUP"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "First, create your Slack app:"
  echo "1. Go to https://api.slack.com/apps"
  echo "2. Click 'Create New App' → 'From an app manifest'"
  echo "3. Paste the manifest from:"
  echo "   https://raw.githubusercontent.com/familyoneInc/cursor-slack-chat/main/slack-app-manifest.yaml"
  echo "4. Install to your workspace"
  echo "5. Copy the Bot User OAuth Token (starts with xoxb-)"
  echo ""
  echo "Enter your Slack Bot Token (xoxb-...):"
  read -r BOT_TOKEN
  
  if [[ ! "$BOT_TOKEN" =~ ^xoxb- ]]; then
    echo "⚠️  Warning: Token should start with 'xoxb-'"
  fi
  
  # Generate the setup file for team members
  cat > "$SETUP_FILE" << EOF
🚀 Cursor Slack Chat - Team Setup Instructions

TOKEN: $BOT_TOKEN

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SETUP STEPS:

1. Open Terminal and run:
   curl -sL https://raw.githubusercontent.com/familyoneInc/cursor-slack-chat/main/setup.sh | bash

2. When asked "Are you the team admin?" answer: n

3. When asked for the token, paste:
   $BOT_TOKEN

4. Restart Cursor

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Questions? DM the Cursor bot in Slack or ask your team admin.
EOF

  echo ""
  echo "✅ Created: $SETUP_FILE"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "NEXT STEP: Upload to Slack"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "1. In Slack, click 'More' → 'Files' (or go to Files in sidebar)"
  echo "2. Click '+ New' → upload cursor-setup.txt from your Desktop"
  echo "3. Team members can find it by searching 'cursor-setup' in Files"
  echo ""
  
  # Also set up for the admin
  BOT_TOKEN_FOR_CONFIG="$BOT_TOKEN"
  
else
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "TEAM MEMBER SETUP"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "Get the token from Slack:"
  echo "  → Click 'More' → 'Files' → Search 'cursor-setup'"
  echo "  → Or DM the Cursor bot for instructions"
  echo ""
  echo "Enter your Slack Bot Token (xoxb-...):"
  read -r BOT_TOKEN_FOR_CONFIG
fi

# Clone or update
echo ""
echo "📦 Installing Cursor Slack Chat..."
if [ -d "$INSTALL_DIR" ]; then
  cd "$INSTALL_DIR"
  git pull --quiet 2>/dev/null || true
else
  mkdir -p "$(dirname "$INSTALL_DIR")"
  git clone --quiet https://github.com/familyoneInc/cursor-slack-chat.git "$INSTALL_DIR"
  cd "$INSTALL_DIR"
fi

# Install dependencies
npm install --silent 2>/dev/null

# Update or create mcp.json
CONFIG_ENTRY=$(cat << EOF
    "cursor-slack-chat": {
      "command": "node",
      "args": ["$INSTALL_DIR/index.js"],
      "env": {
        "SLACK_BOT_TOKEN": "$BOT_TOKEN_FOR_CONFIG"
      }
    }
EOF
)

echo ""
echo "✅ Installation complete!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Add this to ~/.cursor/mcp.json inside \"mcpServers\": { }"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "$CONFIG_ENTRY"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 Restart Cursor to activate"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
