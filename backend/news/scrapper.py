import requests
from bs4 import BeautifulSoup

HEADERS = {
    "User-Agent": "Mozilla/5.0 (compatible; MarketLensBot/1.0)"
}

def scrape_preview(url, max_chars=300):
    try:
        res = requests.get(url, headers=HEADERS, timeout=5)
        if res.status_code != 200:
            return None

        soup = BeautifulSoup(res.text, "html.parser")

        paragraphs = soup.find_all("p")
        text = " ".join(p.get_text() for p in paragraphs)

        text = text.strip()
        if not text:
            return None

        return text[:max_chars] + "..."

    except Exception:
        return None
