"""
Weather tool — wraps the OpenWeatherMap free-tier API.

Get a free key at https://openweathermap.org/api and set
OPENWEATHER_API_KEY in your .env file.
"""

import os
import httpx

OPENWEATHER_API_KEY = os.environ.get("OPENWEATHER_API_KEY", "")
BASE_URL = "https://api.openweathermap.org/data/2.5/weather"


async def get_weather(city: str, country_code: str | None = None) -> dict:
    """
    Returns current weather for a city. Falls back to mock data if no
    API key is configured, so the agent still works out of the box.
    """
    if not OPENWEATHER_API_KEY:
        return _mock_weather(city)

    query = f"{city},{country_code}" if country_code else city
    params = {
        "q": query,
        "appid": OPENWEATHER_API_KEY,
        "units": "metric",
    }

    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            resp = await client.get(BASE_URL, params=params)
            resp.raise_for_status()
            data = resp.json()
    except (httpx.HTTPError, httpx.TimeoutException):
        return _mock_weather(city, note="live weather lookup failed, showing estimate")

    return {
        "city": data.get("name", city),
        "temperature_c": data["main"]["temp"],
        "feels_like_c": data["main"]["feels_like"],
        "condition": data["weather"][0]["description"],
        "humidity_pct": data["main"]["humidity"],
        "wind_kph": round(data["wind"]["speed"] * 3.6, 1),
    }


def _mock_weather(city: str, note: str | None = None) -> dict:
    """Deterministic-ish mock so the demo works with zero API keys configured."""
    result = {
        "city": city,
        "temperature_c": 22,
        "feels_like_c": 23,
        "condition": "partly cloudy",
        "humidity_pct": 55,
        "wind_kph": 12,
        "mock_data": True,
    }
    if note:
        result["note"] = note
    return result
