import os
from dotenv import load_dotenv

load_dotenv()  # must run before importing agent (reads ANTHROPIC_API_KEY at import time)

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from models.schemas import ChatRequest, ChatResponse
from agent.agent import run_agent
from agent.memory import clear_session

app = FastAPI(title="Travel AI Agent API")

allowed_origins = os.environ.get("ALLOWED_ORIGINS", "http://localhost:3000").split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
async def health():
    return {"status": "ok"}


@app.post("/chat", response_model=ChatResponse)
async def chat(req: ChatRequest):
    if not req.message.strip():
        raise HTTPException(status_code=400, detail="message cannot be empty")

    result = await run_agent(session_id=req.session_id, user_message=req.message)
    return ChatResponse(
        session_id=req.session_id,
        reply=result["reply"],
        tool_calls=result["tool_calls"],
    )


@app.post("/session/{session_id}/reset")
async def reset_session(session_id: str):
    clear_session(session_id)
    return {"status": "cleared", "session_id": session_id}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=int(os.environ.get("PORT", 8000)), reload=True)
