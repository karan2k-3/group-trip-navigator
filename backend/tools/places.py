"""
Attractions tool.

Ships with MOCK data so the agent works with zero setup. To go live,
swap the body of search_attractions() for a real call to the Google
Places API (Text Search):
https://developers.google.com/maps/documentation/places/web-service/text-search

Set GOOGLE_PLACES_API_KEY in .env once you're ready to wire it in.
"""

import random

CATEGORY_TEMPLATES = {
    "museums": ["{city} National Museum", "{city} Museum of Modern Art", "{city} History Museum"],
    "nature": ["{city} Botanical Gardens", "{city} National Park", "{city} Waterfront Trail"],
    "food": ["{city} Night Market", "{city} Old Town Food Street", "{city} Central Market"],
    "nightlife": ["{city} Rooftop District", "{city} Live Music Quarter", "{city} Riverside Bars"],
    "landmarks": ["{city} Old Town Square", "{city} Cathedral", "{city} Castle Hill", "{city} Tower"],
}


async def search_attractions(city: str, category: str | None = None, limit: int = 5) -> dict:
    rng = random.Random(f"{city}{category}")
    categories = [category] if category and category in CATEGORY_TEMPLATES else list(CATEGORY_TEMPLATES.keys())

    pool = []
    for cat in categories:
        for template in CATEGORY_TEMPLATES[cat]:
            pool.append({
                "name": template.format(city=city),
                "category": cat,
                "rating": round(rng.uniform(3.8, 4.9), 1),
                "estimated_visit_hours": rng.choice([1, 1.5, 2, 3, 4]),
            })

    rng.shuffle(pool)
    return {
        "city": city,
        "category": category or "all",
        "results": pool[:limit],
        "mock_data": True,
    }
