import pytest
import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from tools.weather import get_weather
from tools.flights import search_flights
from tools.places import search_attractions


@pytest.mark.asyncio
async def test_get_weather_returns_expected_fields():
    result = await get_weather("Tokyo")
    assert "temperature_c" in result
    assert "condition" in result


@pytest.mark.asyncio
async def test_search_flights_valid_date():
    result = await search_flights("MEL", "NRT", "2026-04-10")
    assert "results" in result
    assert len(result["results"]) > 0
    assert all(f["price_usd"] > 0 for f in result["results"])


@pytest.mark.asyncio
async def test_search_flights_invalid_date():
    result = await search_flights("MEL", "NRT", "not-a-date")
    assert "error" in result


@pytest.mark.asyncio
async def test_search_attractions_respects_limit():
    result = await search_attractions("Kyoto", limit=3)
    assert len(result["results"]) <= 3
