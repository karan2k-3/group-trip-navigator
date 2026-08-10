import ChatWindow from "@/components/ChatWindow";

export default function Home() {
  return (
    <main className="night-sky" style={{ display: "flex", flexDirection: "column", minHeight: "100vh" }}>
      <header
        style={{
          borderBottom: "1px solid rgba(231, 169, 76, 0.25)",
          padding: "22px 20px",
        }}
      >
        <div
          style={{
            maxWidth: 720,
            margin: "0 auto",
            display: "flex",
            alignItems: "baseline",
            justifyContent: "space-between",
          }}
        >
          <div style={{ display: "flex", alignItems: "baseline", gap: 10 }}>
            <span style={{ fontFamily: "var(--font-display)", fontSize: 24, color: "#F5F1E6" }}>
              Wayfinder
            </span>
            <span
              style={{
                fontFamily: "var(--font-mono)",
                fontSize: 11,
                color: "var(--color-amber)",
                letterSpacing: "0.08em",
                textTransform: "uppercase",
              }}
            >
              AI Travel Agent
            </span>
          </div>
          <span style={{ fontFamily: "var(--font-mono)", fontSize: 11, color: "var(--color-mist)" }}>
            BOARDING · ANY DESTINATION
          </span>
        </div>
      </header>

      <div style={{ flex: 1 }}>
        <ChatWindow />
      </div>
    </main>
  );
}
