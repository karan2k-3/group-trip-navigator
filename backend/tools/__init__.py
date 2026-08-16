from .weather import get_weather
from .flights import search_flights
from .places import search_attractions

# Maps the tool "name" the LLM calls to the actual async function.
# This is the single place agent.py needs to look to execute a tool call.
TOOL_DISPATCH = {
    "get_weather": get_weather,
    "search_flights": search_flights,
    "search_attractions": search_attractions,
}
