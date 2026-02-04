#!/usr/bin/env node

const { Server } = require("@modelcontextprotocol/sdk/server/index.js");
const { StdioServerTransport } = require("@modelcontextprotocol/sdk/server/stdio.js");

const botToken = process.env.SLACK_BOT_TOKEN;

const headers = {
  Authorization: `Bearer ${botToken}`,
  "Content-Type": "application/json",
};

// Slack API helpers
async function deleteMessage(channel_id, ts) {
  const response = await fetch("https://slack.com/api/chat.delete", {
    method: "POST",
    headers,
    body: JSON.stringify({ channel: channel_id, ts }),
  });
  return response.json();
}

async function updateMessage(channel_id, ts, text) {
  const response = await fetch("https://slack.com/api/chat.update", {
    method: "POST",
    headers,
    body: JSON.stringify({ channel: channel_id, ts, text }),
  });
  return response.json();
}

// Tool definitions
const tools = [
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
          description: "The timestamp (ts) of the message to delete (e.g., '1234567890.123456')",
        },
      },
      required: ["channel_id", "ts"],
    },
  },
  {
    name: "slack_update_message",
    description: "Update/edit an existing message in a Slack channel or DM",
    inputSchema: {
      type: "object",
      properties: {
        channel_id: {
          type: "string",
          description: "The ID of the channel/DM containing the message",
        },
        ts: {
          type: "string",
          description: "The timestamp (ts) of the message to update (e.g., '1234567890.123456')",
        },
        text: {
          type: "string",
          description: "The new text content for the message",
        },
      },
      required: ["channel_id", "ts", "text"],
    },
  },
];

// Tool handlers
async function handleToolCall(name, args) {
  switch (name) {
    case "slack_delete_message": {
      const { channel_id, ts } = args;
      if (!channel_id || !ts) {
        throw new Error("Missing required arguments: channel_id and ts");
      }
      return await deleteMessage(channel_id, ts);
    }
    case "slack_update_message": {
      const { channel_id, ts, text } = args;
      if (!channel_id || !ts || !text) {
        throw new Error("Missing required arguments: channel_id, ts, and text");
      }
      return await updateMessage(channel_id, ts, text);
    }
    default:
      throw new Error(`Unknown tool: ${name}`);
  }
}

async function main() {
  if (!botToken) {
    console.error("Error: SLACK_BOT_TOKEN environment variable is required");
    process.exit(1);
  }

  const server = new Server(
    { name: "Cursor Slack Chat", version: "1.0.0" },
    { capabilities: { tools: {} } }
  );

  server.setRequestHandler({ method: "tools/list" }, async () => ({
    tools,
  }));

  server.setRequestHandler({ method: "tools/call" }, async (request) => {
    const { name, arguments: args } = request.params;
    try {
      const response = await handleToolCall(name, args);
      return { content: [{ type: "text", text: JSON.stringify(response) }] };
    } catch (error) {
      return {
        content: [{ type: "text", text: JSON.stringify({ error: error.message }) }],
      };
    }
  });

  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("MCP Server Slack Extended running on stdio");
}

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
