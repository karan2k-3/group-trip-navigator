export interface ToolCallLog {
  tool: string;
  input: Record<string, unknown>;
  output: Record<string, unknown>;
}

export interface ChatResponse {
  session_id: string;
  reply: string;
  tool_calls: ToolCallLog[];
}

export async function sendMessage(sessionId: string, message: string): Promise<ChatResponse> {
  const res = await fetch("/api/chat", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ session_id: sessionId, message }),
  });

  if (!res.ok) {
    const detail = await res.text();
    throw new Error(`Chat request failed (${res.status}): ${detail}`);
  }

  return res.json();
}
