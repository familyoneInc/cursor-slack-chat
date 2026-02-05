#!/usr/bin/env node

const { Server } = require("@modelcontextprotocol/sdk/server/index.js");
const { StdioServerTransport } = require("@modelcontextprotocol/sdk/server/stdio.js");

const botToken = process.env.SLACK_BOT_TOKEN;

async function deleteMessage(channel_id, ts) {
  const response = await fetch("https://slack.com/api/chat.delete", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${botToken}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      channel: channel_id,
      ts: ts,
    }),
  });
  return response.json();
}

async function updateMessage(channel_id, ts, text) {
  const response = await fetch("https://slack.com/api/chat.update", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${botToken}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      channel: channel_id,
      ts: ts,
      text: text,
    }),
  });
  return response.json();
}

async function listAllChannels(includePrivate = true) {
  const types = includePrivate ? "public_channel,private_channel" : "public_channel";
  const response = await fetch(`https://slack.com/api/conversations.list?types=${types}&limit=200`, {
    headers: {
      Authorization: `Bearer ${botToken}`,
    },
  });
  const data = await response.json();
  if (!data.ok) {
    return data;
  }
  // Return simplified channel list
  return {
    ok: true,
    channels: data.channels.map(c => ({
      id: c.id,
      name: c.name,
      is_private: c.is_private,
      is_member: c.is_member,
      num_members: c.num_members,
    })),
  };
}

async function findChannel(query) {
  const response = await fetch("https://slack.com/api/conversations.list?types=public_channel,private_channel&limit=200", {
    headers: {
      Authorization: `Bearer ${botToken}`,
    },
  });
  const data = await response.json();
  if (!data.ok) {
    return data;
  }
  
  const queryLower = query.toLowerCase();
  const matches = data.channels.filter(c => 
    c.name.toLowerCase().includes(queryLower) ||
    c.id.toLowerCase() === queryLower
  );
  
  return {
    ok: true,
    query: query,
    matches: matches.map(c => ({
      id: c.id,
      name: c.name,
      is_private: c.is_private,
      is_member: c.is_member,
    })),
  };
}

async function getChannelHistory(channel_id, limit = 20) {
  const response = await fetch(`https://slack.com/api/conversations.history?channel=${channel_id}&limit=${limit}`, {
    headers: {
      Authorization: `Bearer ${botToken}`,
    },
  });
  return response.json();
}

async function getThreadReplies(channel_id, thread_ts) {
  const response = await fetch(`https://slack.com/api/conversations.replies?channel=${channel_id}&ts=${thread_ts}`, {
    headers: {
      Authorization: `Bearer ${botToken}`,
    },
  });
  return response.json();
}

async function main() {
  if (!botToken) {
    console.error("Please set SLACK_BOT_TOKEN environment variable");
    process.exit(1);
  }

  const server = new Server(
    { name: "Cursor Slack Chat MCP Server", version: "1.1.0" },
    { capabilities: { tools: {} } }
  );

  server.setRequestHandler({ method: "tools/list" }, async () => ({
    tools: [
      {
        name: "slack_delete_message",
        description: "Delete a message from a Slack channel or DM",
        inputSchema: {
          type: "object",
          properties: {
            channel_id: {
              type: "string",
              description: "The ID of the channel/DM containing the message",
            },
            ts: {
              type: "string",
              description: "The timestamp (ts) of the message to delete",
            },
          },
          required: ["channel_id", "ts"],
        },
      },
      {
        name: "slack_update_message",
        description: "Update/edit an existing message in a Slack channel",
        inputSchema: {
          type: "object",
          properties: {
            channel_id: {
              type: "string",
              description: "The ID of the channel containing the message",
            },
            ts: {
              type: "string",
              description: "The timestamp (ts) of the message to update",
            },
            text: {
              type: "string",
              description: "The new text content for the message",
            },
          },
          required: ["channel_id", "ts", "text"],
        },
      },
      {
        name: "slack_list_all_channels",
        description: "List ALL channels the bot can access, including PRIVATE channels. Use this instead of the built-in slack_list_channels which only shows public channels.",
        inputSchema: {
          type: "object",
          properties: {
            include_private: {
              type: "boolean",
              description: "Include private channels (default: true)",
            },
          },
        },
      },
      {
        name: "slack_find_channel",
        description: "Search for a channel by name (partial match). Searches both public and private channels.",
        inputSchema: {
          type: "object",
          properties: {
            query: {
              type: "string",
              description: "Channel name or partial name to search for",
            },
          },
          required: ["query"],
        },
      },
      {
        name: "slack_get_channel_history_extended",
        description: "Get recent messages from a channel (works with private channels)",
        inputSchema: {
          type: "object",
          properties: {
            channel_id: {
              type: "string",
              description: "The ID of the channel",
            },
            limit: {
              type: "number",
              description: "Number of messages to retrieve (default: 20)",
            },
          },
          required: ["channel_id"],
        },
      },
      {
        name: "slack_get_thread_replies_extended",
        description: "Get all replies in a message thread",
        inputSchema: {
          type: "object",
          properties: {
            channel_id: {
              type: "string",
              description: "The ID of the channel containing the thread",
            },
            thread_ts: {
              type: "string",
              description: "The timestamp of the parent message",
            },
          },
          required: ["channel_id", "thread_ts"],
        },
      },
    ],
  }));

  server.setRequestHandler({ method: "tools/call" }, async (request) => {
    const { name, arguments: args } = request.params;
    
    switch (name) {
      case "slack_delete_message": {
        const { channel_id, ts } = args;
        if (!channel_id || !ts) {
          throw new Error("Missing required arguments: channel_id and ts");
        }
        const response = await deleteMessage(channel_id, ts);
        return { content: [{ type: "text", text: JSON.stringify(response, null, 2) }] };
      }
      
      case "slack_update_message": {
        const { channel_id, ts, text } = args;
        if (!channel_id || !ts || !text) {
          throw new Error("Missing required arguments: channel_id, ts, and text");
        }
        const response = await updateMessage(channel_id, ts, text);
        return { content: [{ type: "text", text: JSON.stringify(response, null, 2) }] };
      }
      
      case "slack_list_all_channels": {
        const includePrivate = args.include_private !== false;
        const response = await listAllChannels(includePrivate);
        return { content: [{ type: "text", text: JSON.stringify(response, null, 2) }] };
      }
      
      case "slack_find_channel": {
        const { query } = args;
        if (!query) {
          throw new Error("Missing required argument: query");
        }
        const response = await findChannel(query);
        return { content: [{ type: "text", text: JSON.stringify(response, null, 2) }] };
      }
      
      case "slack_get_channel_history_extended": {
        const { channel_id, limit } = args;
        if (!channel_id) {
          throw new Error("Missing required argument: channel_id");
        }
        const response = await getChannelHistory(channel_id, limit || 20);
        return { content: [{ type: "text", text: JSON.stringify(response, null, 2) }] };
      }
      
      case "slack_get_thread_replies_extended": {
        const { channel_id, thread_ts } = args;
        if (!channel_id || !thread_ts) {
          throw new Error("Missing required arguments: channel_id and thread_ts");
        }
        const response = await getThreadReplies(channel_id, thread_ts);
        return { content: [{ type: "text", text: JSON.stringify(response, null, 2) }] };
      }
      
      default:
        throw new Error(`Unknown tool: ${name}`);
    }
  });

  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
