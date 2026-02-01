import requests
from datetime import datetime, timedelta
from .config import NEWS_API_KEY, FINANCE_KEYWORDS, MAX_ARTICLES

NEWS_ENDPOINT = "https://newsapi.org/v2/everything"

def fetch_finance_news():
    query = " OR ".join(FINANCE_KEYWORDS)

    params = {
        "q": query,
        "language": "en",
        "sortBy": "publishedAt",
        "pageSize": MAX_ARTICLES,
        "apiKey": NEWS_API_KEY
    }

    response = requests.get(NEWS_ENDPOINT, params=params, timeout=10)
    response.raise_for_status()

    data = response.json()
    return data.get("articles", [])