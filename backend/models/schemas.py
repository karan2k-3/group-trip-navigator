from pydantic import BaseModel
from typing import Literal


class ChatMessage(BaseModel):
    role: Literal["user", "assistant"]
    content: str


class ChatRequest(BaseModel):
    session_id: str
    message: str


class ToolCallLog(BaseModel):
    tool: str
    input: dict
    output: dict


class ChatResponse(BaseModel):
    session_id: str
    reply: str
    tool_calls: list[ToolCallLog] = []
