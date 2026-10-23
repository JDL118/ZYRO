const express = require("express");
const app = express();

app.use(express.json({ limit: "1mb" }));
app.use(express.static(__dirname));

app.post("/api/chat", async (req, res) => {
  const message = String(req.body?.message || "").trim();

  if (!message) {
    return res.status(400).json({ error: "Message is required." });
  }

  if (!process.env.GROQ_API_KEY) {
    return res.status(503).json({
      error: "Add GROQ_API_KEY in Render Environment Variables first."
    });
  }

  try {
    const response = await fetch(
      "https://api.groq.com/openai/v1/chat/completions",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${process.env.GROQ_API_KEY}`
        },
        body: JSON.stringify({
          model: "openai/gpt-oss-120b",
          messages: [
            {
              role: "system",
              content: "You are Zyro, a helpful AI assistant. Be friendly, clear, and honest. Do not claim to be ChatGPT or claim capabilities you do not have."
            },
            { role: "user", content: message }
          ],
          temperature: 0.7
        })
      }
    );

    const data = await response.json();

    if (!response.ok) {
      console.error("Groq API error:", data?.error?.message || response.status);
      return res.status(502).json({
        error: "The AI provider returned an error. Check the API key, model availability, and provider limits."
      });
    }

    const answer = data.choices?.[0]?.message?.content;

    if (!answer) {
      return res.status(502).json({
        error: "The AI provider returned an empty response."
      });
    }

    return res.json({ text: answer });
  } catch (error) {
    console.error("Chat request failed:", error.message);
    return res.status(500).json({
      error: "Zyro could not reach the AI provider. Please try again."
    });
  }
});

const port = process.env.PORT || 10000;

app.listen(port, "0.0.0.0", () => {
  console.log(`Zyro listening on port ${port}`);
});
