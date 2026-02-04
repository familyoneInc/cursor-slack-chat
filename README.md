# Cursor Slack Chat

Chat with your team on Slack directly from Cursor. Message team members and channels as things come up during development.

## Features

- `slack_delete_message` - Delete messages from channels or DMs
- `slack_update_message` - Edit existing messages  
- `slack_get_thread_replies` - Check if someone replied to your message
- `slack_get_channel_history` - See recent messages in a channel

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

## Team Setup

**The team shares ONE Slack bot.** Each person:
1. Runs the install script
2. Uses the same shared `SLACK_BOT_TOKEN` in their config
3. Restarts Cursor

## Required Slack Bot Permissions

Your Slack bot token needs these OAuth scopes:

| Scope | Purpose |
|-------|---------|
| `chat:write` | Post, edit, and delete messages |
| `channels:history` | Read messages in public channels |
| `groups:history` | Read messages in private channels |
| `im:history` | Read direct messages |
| `channels:read` | List public channels |
| `groups:read` | List private channels the bot is in |
| `users:read` | Look up user info |

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
