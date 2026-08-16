"use client";

import { useEffect, useRef, useState } from "react";
import MessageBubble, { Message } from "./MessageBubble";
import { sendMessage } from "@/lib/api";

const STARTER_PROMPTS = [
  "What's the weather like in Lisbon next week?",
  "Find me flights from Melbourne to Tokyo on 2026-10-04",
  "What should I see in Kyoto for 2 days?",
];

export default function ChatWindow() {
  const [sessionId] = useState(() => crypto.randomUUID());
  const [messages, setMessages] = useState<Message[]>([
    {
      role: "assistant",
      content:
        "Hi, I'm Wayfinder. Tell me where you're headed and I can check the weather, find flights, or suggest things to do — what's the trip?",
    },
  ]);
  const [input, setInput] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const scrollRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    scrollRef.current?.scrollTo({ top: scrollRef.current.scrollHeight, behavior: "smooth" });
  }, [messages, isLoading]);

  async function handleSend(text: string) {
    const trimmed = text.trim();
    if (!trimmed || isLoading) return;

    setMessages((prev) => [...prev, { role: "user", content: trimmed }]);
    setInput("");
    setIsLoading(true);
    setError(null);

    try {
      const res = await sendMessage(sessionId, trimmed);
      setMessages((prev) => [
        ...prev,
        { role: "assistant", content: res.reply, toolCalls: res.tool_calls },
      ]);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Something went wrong");
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "column",
        height: "100%",
        maxWidth: 720,
        margin: "0 auto",
        padding: "0 20px",
      }}
    >
      <div ref={scrollRef} style={{ flex: 1, overflowY: "auto", paddingTop: 24, paddingBottom: 12 }}>
        {messages.map((m, i) => (
          <MessageBubble key={i} message={m} />
        ))}

        {isLoading && (
          <div style={{ display: "flex", justifyContent: "flex-start", margin: "10px 0" }}>
            <div
              style={{
                background: "var(--color-paper)",
                borderRadius: "2px 10px 10px 10px",
                padding: "12px 16px",
                fontFamily: "var(--font-mono)",
                fontSize: 13,
                color: "var(--color-ink)",
                opacity: 0.7,
              }}
            >
              thinking…
            </div>
          </div>
        )}

        {error && (
          <div style={{ color: "#E77878", fontSize: 13, fontFamily: "var(--font-mono)", margin: "8px 0" }}>
            {error}
          </div>
        )}

        {messages.length === 1 && (
          <div style={{ display: "flex", flexWrap: "wrap", gap: 8, marginTop: 8 }}>
            {STARTER_PROMPTS.map((p) => (
              <button
                key={p}
                onClick={() => handleSend(p)}
                style={{
                  background: "transparent",
                  border: "1px solid rgba(138,147,184,0.4)",
                  color: "var(--color-mist)",
                  borderRadius: 8,
                  padding: "8px 12px",
                  fontSize: 13,
                  cursor: "pointer",
                  textAlign: "left",
                }}
              >
                {p}
              </button>
            ))}
          </div>
        )}
      </div>

      <form
        onSubmit={(e) => {
          e.preventDefault();
          handleSend(input);
        }}
        style={{
          display: "flex",
          gap: 10,
          padding: "16px 0 24px",
          borderTop: "1px solid rgba(138,147,184,0.2)",
        }}
      >
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Where are you headed?"
          aria-label="Message"
          style={{
            flex: 1,
            background: "var(--color-night-soft)",
            border: "1px solid rgba(138,147,184,0.3)",
            borderRadius: 8,
            padding: "12px 14px",
            color: "#F0EEF7",
            fontSize: 15,
            fontFamily: "var(--font-body)",
          }}
        />
        <button
          type="submit"
          disabled={isLoading}
          style={{
            background: "var(--color-amber)",
            color: "var(--color-night)",
            border: "none",
            borderRadius: 8,
            padding: "0 20px",
            fontWeight: 600,
            fontSize: 14,
            cursor: isLoading ? "not-allowed" : "pointer",
            opacity: isLoading ? 0.6 : 1,
          }}
        >
          Send
        </button>
      </form>
    </div>
  );
}