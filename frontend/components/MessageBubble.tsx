import ToolCallIndicator from "./ToolCallIndicator";
import type { ToolCallLog } from "@/lib/api";

export interface Message {
  role: "user" | "assistant";
  content: string;
  toolCalls?: ToolCallLog[];
}

export default function MessageBubble({ message }: { message: Message }) {
  const isUser = message.role === "user";

  if (isUser) {
    return (
      <div style={{ display: "flex", justifyContent: "flex-end", margin: "10px 0" }}>
        <div
          style={{
            maxWidth: "72%",
            background: "var(--color-night-soft)",
            borderRight: "3px solid var(--color-amber)",
            borderRadius: "10px 2px 10px 10px",
            padding: "12px 16px",
            color: "#F0EEF7",
            fontSize: 15,
            lineHeight: 1.5,
          }}
        >
          {message.content}
        </div>
      </div>
    );
  }

  return (
    <div style={{ display: "flex", justifyContent: "flex-start", margin: "10px 0" }}>
      <div style={{ maxWidth: "78%" }}>
        {message.toolCalls && message.toolCalls.length > 0 && (
          <div style={{ display: "flex", flexWrap: "wrap", gap: 8, marginBottom: 8 }}>
            {message.toolCalls.map((tc, i) => (
              <ToolCallIndicator key={i} toolName={tc.tool} />
            ))}
          </div>
        )}

        <div
          style={{
            position: "relative",
            background: "var(--color-paper)",
            color: "var(--color-ink)",
            borderRadius: "2px 10px 10px 10px",
            padding: "14px 18px",
            fontSize: 15,
            lineHeight: 1.55,
            boxShadow: "0 4px 18px rgba(0,0,0,0.25)",
          }}
        >
          <div
            aria-hidden="true"
            style={{
              position: "absolute",
              left: -1,
              top: 10,
              bottom: 10,
              width: 0,
              borderLeft: "2px dashed rgba(26,31,51,0.2)",
            }}
          />
          {message.content}
        </div>
      </div>
    </div>
  );
}