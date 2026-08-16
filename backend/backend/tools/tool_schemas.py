"""
Tool schemas the agent hands to the LLM so it knows what functions
it can call, and with what arguments. This is the "menu" of capabilities.

Anthropic's tool-use format: https://docs.claude.com/en/docs/build-with-claude/tool-use
"""

TOOLS = [
    {
        "name": "get_weather",
        "description": (
            "Get the current weather and a short forecast for a city. "
            "Use this when the user asks what a destination's weather is "
            "like, or when it would help you recommend what to pack or "
            "when to travel."
        ),
        "input_schema": {
            "type": "object",
            "properties": {
                "city": {
                    "type": "string",
                    "description": "City name, e.g. 'Tokyo' or 'Cape Town'",
                },
                "country_code": {
                    "type": "string",
                    "description": "Optional ISO 3166 country code, e.g. 'JP', to disambiguate cities with the same name",
                },
            },
            "required": ["city"],
        },
    },
    {
        "name": "search_flights",
        "description": (
            "Search for flights between two cities on a given date. "
            "Use this when the user wants flight options, prices, or "
            "durations for a specific route."
        ),
        "input_schema": {
            "type": "object",
            "properties": {
                "origin": {
                    "type": "string",
                    "description": "Departure city or IATA airport code, e.g. 'Melbourne' or 'MEL'",
                },
                "destination": {
                    "type": "string",
                    "description": "Arrival city or IATA airport code, e.g. 'Tokyo' or 'NRT'",
                },
                "date": {
                    "type": "string",
                    "description": "Departure date in YYYY-MM-DD format",
                },
                "max_price": {
                    "type": "number",
                    "description": "Optional maximum price in USD to filter results",
                },
            },
            "required": ["origin", "destination", "date"],
        },
    },
    {
        "name": "search_attractions",
        "description": (
            "Find top attractions, landmarks, or points of interest in a "
            "city. Use this when the user asks what to see or do "
            "somewhere."
        ),
        "input_schema": {
            "type": "object",
            "properties": {
                "city": {
                    "type": "string",
                    "description": "City to search attractions in",
                },
                "category": {
                    "type": "string",
                    "description": "Optional filter, e.g. 'museums', 'nature', 'food', 'nightlife'",
                },
                "limit": {
                    "type": "integer",
                    "description": "How many results to return, default 5",
                },
            },
            "required": ["city"],
        },
    },
]
