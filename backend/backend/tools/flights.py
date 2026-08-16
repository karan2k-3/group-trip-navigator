"""
Flight search tool.

This ships with realistic MOCK data so the agent works with zero setup.
To go live, swap the body of search_flights() for a real call to the
Amadeus Self-Service Flight Offers Search API:
https://developers.amadeus.com/self-service/category/flights

Amadeus requires an OAuth2 client-credentials token exchange before the
actual search call — that token-fetch step is intentionally left out
here to keep the starter code dependency-free, but the shape of the
returned dict below matches what you'd map their response into.
"""

import random
from datetime import datetime


AIRLINES = ["Qantas", "Jetstar", "Singapore Airlines", "ANA", "Emirates", "Air New Zealand"]


async def search_flights(
    origin: str,
    destination: str,
    date: str,
    max_price: float | None = None,
) -> dict:
    try:
        datetime.strptime(date, "%Y-%m-%d")
    except ValueError:
        return {"error": f"Invalid date format '{date}', expected YYYY-MM-DD"}

    rng = random.Random(f"{origin}{destination}{date}")  # deterministic per-route mock
    results = []
    for _ in range(4):
        price = rng.randint(280, 1850)
        if max_price and price > max_price:
            continue
        duration_hrs = rng.randint(2, 22)
        results.append({
            "airline": rng.choice(AIRLINES),
            "flight_number": f"{rng.choice(['QF', 'JQ', 'SQ', 'NH', 'EK', 'NZ'])}{rng.randint(100, 999)}",
            "origin": origin,
            "destination": destination,
            "date": date,
            "duration_hours": duration_hrs,
            "stops": 0 if duration_hrs < 6 else rng.choice([0, 1]),
            "price_usd": price,
        })

    results.sort(key=lambda f: f["price_usd"])

    return {
        "origin": origin,
        "destination": destination,
        "date": date,
        "results": results,
        "mock_data": True,
    }
