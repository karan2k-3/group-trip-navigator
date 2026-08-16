"""
Very simple in-memory conversation store, keyed by session_id.

This is intentionally minimal for a portfolio project: it keeps each
session's message history in a process-local dict. Swap this for Redis
or a database if you need persistence across server restarts or
multiple backend instances.
"""

from typing import Any

_sessions: dict[str, list[dict[str, Any]]] = {}

MAX_HISTORY_MESSAGES = 30  # simple cap so context doesn't grow unbounded


def get_history(session_id: str) -> list[dict[str, Any]]:
    return _sessions.setdefault(session_id, [])


def append_message(session_id: str, message: dict[str, Any]) -> None:
    history = get_history(session_id)
    history.append(message)
    if len(history) > MAX_HISTORY_MESSAGES:
        del history[: len(history) - MAX_HISTORY_MESSAGES]


def clear_session(session_id: str) -> None:
    _sessions.pop(session_id, None)
