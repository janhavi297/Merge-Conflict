import os

NEWS_API_KEY = os.getenv("NEWS_API_KEY")  # put in env, NOT hard-coded

FINANCE_KEYWORDS = [
    "markets",
    "stocks",
    "economy",
    "inflation",
    "interest rates",
    "central bank",
    "GDP",
    "recession",
    "bonds",
    "commodities",
    "forex",
    "earnings"
]

MAX_ARTICLES = 25
PREVIEW_SENTENCES = 1

