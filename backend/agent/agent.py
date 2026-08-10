"""
The agent loop. This is the core of the project.

The pattern here is the standard "tool use loop":
  1. Send the conversation + tool definitions to the LLM.
  2. If the LLM's response includes a tool_use block, run that tool
     locally and feed the result back to the LLM as a tool_result.
  3. Repeat until the LLM responds with plain text (no more tool calls).

This is what separates an "agent" from a simple chatbot: the LLM
decides, turn by turn, whether it has enough information to answer or
whether it needs to call a tool first.
"""

import os
from anthropic import AsyncAnthropic

from .prompts import SYSTEM_PROMPT
from .memory import get_history, append_message
from tools import TOOL_DISPATCH
from tools.tool_schemas import TOOLS

MODEL = "claude-sonnet-4-6"
MAX_TOOL_ITERATIONS = 5

client = AsyncAnthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))


async def run_agent(session_id: str, user_message: str) -> dict:
    """
    Runs one full turn of the agent: takes a user message, returns the
    agent's final text reply plus a log of any tool calls it made along
    the way.
    """
    history = get_history(session_id)
    append_message(session_id, {"role": "user", "content": user_message})

    tool_call_log = []

    for _ in range(MAX_TOOL_ITERATIONS):
        response = await client.messages.create(
            model=MODEL,
            max_tokens=1024,
            system=SYSTEM_PROMPT,
            tools=TOOLS,
            messages=history,
        )

        append_message(session_id, {"role": "assistant", "content": response.content})

        if response.stop_reason != "tool_use":
            final_text = _extract_text(response.content)
            final_text = _format_final_text(final_text)
            return {"reply": final_text, "tool_calls": tool_call_log}

        tool_results = []
        for block in response.content:
            if block.type != "tool_use":
                continue

            tool_name = block.name
            tool_input = block.input
            output = await _execute_tool(tool_name, tool_input)

            tool_call_log.append(
                {
                    "tool": tool_name,
                    "input": tool_input,
                    "output": output,
                }
            )

            tool_results.append(
                {
                    "type": "tool_result",
                    "tool_use_id": block.id,
                    "content": str(output),
                }
            )

        append_message(session_id, {"role": "user", "content": tool_results})

    return {
        "reply": "## Error\nI ran into trouble finishing that request after several tool calls. Please try rephrasing or narrowing it down.",
        "tool_calls": tool_call_log,
    }


async def _execute_tool(name: str, tool_input: dict) -> dict:
    fn = TOOL_DISPATCH.get(name)
    if fn is None:
        return {"error": f"Unknown tool '{name}'"}
    try:
        return await fn(**tool_input)
    except Exception as exc:
        return {"error": f"Tool '{name}' failed: {exc}"}


def _extract_text(content_blocks) -> str:
    return "".join(block.text for block in content_blocks if block.type == "text").strip()


def _format_final_text(text: str) -> str:
    if not text:
        return "## Answer\nI couldn't generate a response."

    stripped = text.strip()

    if "## " in stripped or "- " in stripped or "1. " in stripped:
        return stripped

    return f"## Answer\n{stripped}"