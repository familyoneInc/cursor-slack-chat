# MCP Server Slack Extended

Extended MCP (Model Context Protocol) server for Slack, adding tools not available in the standard `@modelcontextprotocol/server-slack` package.

This enables **Cursor → Slack** communication, allowing you to message team members and channels directly from Cursor as things come up during development.

## Features

**Additional Tools:**
- `slack_delete_message` - Delete messages from channels or DMs

*More tools coming soon: edit messages, schedule messages, etc.*

## Quick Install

```bash
# Clone and install
git clone https://github.com/familyoneInc/mcp-server-slack-extended.git ~/.cursor/mcp-servers/mcp-server-slack-extended
cd ~/.cursor/mcp-servers/mcp-server-slack-extended
npm install
```

Or run the setup script:
```bash
curl -sL https://raw.githubusercontent.com/familyoneInc/mcp-server-slack-extended/main/setup.sh | bash
```

## Configuration

Add to your `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "slack-extended": {
      "command": "node",
      "args": ["/Users/YOURNAME/.cursor/mcp-servers/mcp-server-slack-extended/index.js"],
      "env": {
        "SLACK_BOT_TOKEN": "xoxb-your-bot-token"
      }
    }
  }
}
```

Then restart Cursor.

## Required Slack Bot Permissions

Your Slack bot token needs these OAuth scopes:
- `chat:write` - Post and delete messages

## Usage

Once configured, Cursor can use these tools:

### Delete a message
```
Delete the message in channel C06QAJ35QPL with timestamp 1770156144.483089
```

## Development

```bash
# Install dependencies
npm install

# Test locally
SLACK_BOT_TOKEN=xoxb-xxx node index.js
```

## License

MIT
