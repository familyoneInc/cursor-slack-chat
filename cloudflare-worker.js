// Cloudflare Worker for /cursor-setup Slack command
// This is a SHARED worker - it contains NO secrets
// Each company stores their token in their own Slack workspace Files

export default {
  async fetch(request, env) {
    if (request.method !== "POST") {
      return new Response("OK", { status: 200 });
    }
    
    const response = {
      response_type: "ephemeral",
      blocks: [
        { type: "header", text: { type: "plain_text", text: "Cursor Slack Chat Setup", emoji: true }},
        { type: "section", text: { type: "mrkdwn", text: "*Step 1:* Get your team's bot token" }},
        { type: "section", text: { type: "mrkdwn", text: "Go to *Files* in Slack (click More → Files) and search for `cursor-setup` to find your team's token file." }},
        { type: "section", text: { type: "mrkdwn", text: "*Step 2:* Open Terminal and run:" }},
        { type: "section", text: { type: "mrkdwn", text: "curl -sL https://raw.githubusercontent.com/CanonSystems/cursor-slack-chat/main/setup.sh | bash" }},
        { type: "section", text: { type: "mrkdwn", text: "*Step 3:* When asked if you are the team admin, answer *n*" }},
        { type: "section", text: { type: "mrkdwn", text: "*Step 4:* Paste the token from the file when prompted" }},
        { type: "section", text: { type: "mrkdwn", text: "*Step 5:* Restart Cursor - done!" }},
        { type: "divider" },
        { type: "context", elements: [{ type: "mrkdwn", text: "Docs: https://github.com/CanonSystems/cursor-slack-chat | Admin? Run the script and answer 'y' to set up for your team" }]}
      ]
    };
    
    return new Response(JSON.stringify(response), { 
      headers: { "Content-Type": "application/json" }
    });
  }
};
