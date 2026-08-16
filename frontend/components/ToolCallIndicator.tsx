const TOOL_LABELS: Record<string, string> = {
  get_weather: "Checking the weather",
  search_flights: "Searching flights",
  search_attractions: "Finding attractions",
};

export default function ToolCallIndicator({ toolName }: { toolName: string }) {
  const label = TOOL_LABELS[toolName] ?? `Running ${toolName}`;

  return (
    <div
      style={{
        display: "inline-flex",
        alignItems: "center",
        gap: 8,
        padding: "6px 12px",
        borderRadius: 999,
        background: "var(--color-night-soft)",
        border: "1px solid rgba(231, 169, 76, 0.35)",
        color: "var(--color-amber)",
        fontFamily: "var(--font-mono)",
        fontSize: 12,
        letterSpacing: "0.02em",
      }}
    >
      <span className="plane-glide" aria-hidden="true">✈</span>
      {label}…
    </div>
  );
}
