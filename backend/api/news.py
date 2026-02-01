from fastapi import APIRouter
from news.client import fetch_finance_news
from news.normalizer import normalize_article

router = APIRouter(prefix="/api", tags=["news"])

@router.get("/news")
def get_finance_news():
    articles = fetch_finance_news()

    cards = []
    for article in articles:
        cards.append(normalize_article(article))

    return {
        "count": len(cards),
        "articles": cards
    }
