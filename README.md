# Wayfinder — AI Travel Agent

A tool-calling AI agent that helps plan trips: live weather, flight search,
and local attractions, wrapped in a chat UI. Built as a portfolio project
demonstrating an actual agentic loop (LLM decides when to call tools),
not just a wrapped prompt.

See [`docs/architecture.md`](docs/architecture.md) for how the pieces fit
together.

## Stack

- **Backend**: Python, FastAPI, Anthropic SDK (tool use / function calling)
- **Frontend**: Next.js (App Router), TypeScript
- **Tools**: weather (OpenWeatherMap, real), flights + attractions (mock
  data by default — see docstrings in `backend/tools/` for wiring up
  real APIs)

## Project structure

```
backend/
  main.py              FastAPI app, exposes POST /chat
  agent/agent.py        The core tool-calling loop
  agent/memory.py        Per-session conversation history
  agent/prompts.py       System prompt
  tools/                 One file per tool + tool_schemas.py
  tests/                 pytest tests for tools + dispatch wiring
frontend/
  app/page.tsx            Page shell
  app/api/chat/route.ts    Proxies to the Python backend (keeps API key server-side)
  components/               Chat UI
docs/architecture.md      Request flow + how to add a new tool
```

## Setup

### 1. Backend

```bash
cd backend
python -m venv venv
source venv/bin/activate      # Windows: venv\Scripts\activate
pip install -r requirements.txt

cp ../.env.example .env       # then fill in ANTHROPIC_API_KEY at minimum
uvicorn main:app --reload --port 8000
```

The backend works out of the box with just `ANTHROPIC_API_KEY` set —
flights and attractions use realistic mock data, and weather falls back
to mock data too if `OPENWEATHER_API_KEY` isn't set.

### 2. Frontend

```bash
cd frontend
npm install
echo "BACKEND_URL=http://localhost:8000" > .env.local
npm run dev
```

Open http://localhost:3000.

### 3. Run tests

```bash
cd backend
pip install pytest pytest-asyncio
pytest
```

## Deploying

- **Backend** → Railway, Render, or Fly.io (any host that runs a
  long-lived Python process). Set `ANTHROPIC_API_KEY` and
  `ALLOWED_ORIGINS` (your deployed frontend URL) as environment
  variables there.
- **Frontend** → Vercel. Set `BACKEND_URL` to your deployed backend URL.

## What makes this an "agent" and not a chatbot

The LLM isn't just generating text — on each turn it decides whether it
has enough information to answer, or whether it needs to call
`get_weather`, `search_flights`, or `search_attractions` first, and the
backend actually executes those calls and feeds real data back before
the model finishes its reply. See `backend/agent/agent.py` for the loop,
and `docs/architecture.md` for the full request flow diagram.

## Extending this project

Ideas if you want to build on this for your portfolio:
- Swap flight/attraction mocks for real APIs (Amadeus, Google Places —
  see docstrings in `backend/tools/`)
- Add a `book_flight` tool with a confirmation step (agents that take
  actions, not just look things up, are a natural next milestone)
- Persist memory in Redis/Postgres so sessions survive a restart
- Add streaming responses for a snappier UI
