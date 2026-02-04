# Cursor Slack Chat

Chat with your team on Slack directly from Cursor. Message team members and channels as things come up during development.

## Features

- `slack_delete_message` - Delete messages from channels or DMs
- `slack_update_message` - Edit existing messages

## Quick Install

```bash
curl -sL https://raw.githubusercontent.com/familyoneInc/cursor-slack-chat/main/setup.sh | bash
```

Or manually:
```bash
git clone https://github.com/familyoneInc/cursor-slack-chat.git ~/.cursor/mcp-servers/cursor-slack-chat
cd ~/.cursor/mcp-servers/cursor-slack-chat
npm install
```

## Configuration

Add to your `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "cursor-slack-chat": {
      "command": "node",
      "args": ["/Users/YOURNAME/.cursor/mcp-servers/cursor-slack-chat/index.js"],
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
