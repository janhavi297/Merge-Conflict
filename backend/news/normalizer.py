from .scrapper import scrape_preview

def normalize_article(article):
    url = article.get("url")

    preview = scrape_preview(url)

    return {
        "title": article.get("title"),
        "source": article.get("source", {}).get("name"),
        "published_at": article.get("publishedAt"),
        "url": url,
        "image": article.get("urlToImage"),
        "summary": (
            preview
            or article.get("description")
            or "Click to read full article."
        )
    }
