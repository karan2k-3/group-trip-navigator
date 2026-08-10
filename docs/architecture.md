# Architecture

## Request flow

```
User types in browser
        │
        ▼
Next.js Chat UI (app/page.tsx, components/ChatWindow.tsx)
        │  POST /api/chat  { session_id, message }
        ▼
Next.js API route (app/api/chat/route.ts)
        │  proxies to backend — keeps ANTHROPIC_API_KEY server-side only
        │  POST {BACKEND_URL}/chat
        ▼
FastAPI backend (backend/main.py)
        │
        ▼
Agent loop (backend/agent/agent.py)
        │
        ├─► Claude (Anthropic API) — decides: answer directly, or call a tool?
        │
        │   if tool_use:
        ├─► tools/weather.py | flights.py | places.py
        │   (each returns a plain dict)
        │
        └─► result fed back to Claude as tool_result,
            loop continues until Claude returns plain text
        │
        ▼
ChatResponse { reply, tool_calls[] }  →  back up the chain to the UI
```

## Why this shape

- **The frontend never talks to the LLM directly.** The Next.js API route
  is a thin proxy so the Anthropic API key only ever lives on a server,
  never in browser JS.
- **The agent loop is provider-agnostic in shape.** `agent.py` doesn't
  know anything about weather or flights specifically — it just knows
  how to run the "call LLM → check for tool_use → execute → feed back"
  loop. Adding a new capability means adding one function to `tools/`
  and one schema entry to `tool_schemas.py`; `agent.py` doesn't change.
- **Tools are pure functions.** Each tool takes plain arguments and
  returns a plain dict — no knowledge of Anthropic's message format
  leaks into them. This makes them independently testable
  (`tests/test_tools.py`) and easy to swap from mock data to a real API
  (see the docstring at the top of each tool file).
- **Memory is a stand-in.** `agent/memory.py` is an in-memory dict keyed
  by session ID, which is enough for a demo/portfolio deployment. Swap
  it for Redis or a database for anything that needs to survive a
  server restart or run across multiple backend instances.

## Adding a new tool

1. Write an async function in `backend/tools/your_tool.py` that takes
   plain arguments and returns a dict.
2. Add its JSON schema to `TOOLS` in `backend/tools/tool_schemas.py`
   (the `description` field is what the LLM uses to decide *when* to
   call it — be specific).
3. Register it in `TOOL_DISPATCH` in `backend/tools/__init__.py`.
4. That's it — `agent.py` picks it up automatically.
