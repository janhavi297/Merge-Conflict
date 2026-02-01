# api/graphs.py
from fastapi import APIRouter, HTTPException
from strategy.explainers import per_ticker_series_for_buy_list

router = APIRouter(prefix="/api", tags=["graphs"])

@router.get("/ticker/{ticker}/series")
def ticker_series(ticker: str):
    """
    Returns full series for the requested ticker in the same format
    that your matplotlib plot used: DaysPassed vs PriceIncCumm,
    and Explanation for each date (useful for hover/tooltips).
    """
    out = per_ticker_series_for_buy_list([ticker])
    if not out or ticker not in out:
        raise HTTPException(status_code=404, detail=f"No series available for {ticker}")
    return {
        "ticker": ticker,
        "series": out[ticker]
    }

@router.get("/buy_list/series")
def buy_list_series():
    """
    Convenience endpoint: return all buy-ticker series for current recommendation.
    """
    # compute live recs
    # This endpoint will call compute_live_recommendations_with_explanations inside explainer to get buy list
    # To avoid duplication, we call per_ticker_series_for_buy_list with buy list computed upstream.
    # For simplicity, callers should call /api/recommendation first to get buy_tickers then call this.
    raise HTTPException(status_code=501, detail="Use /api/recommendation to get buy_tickers then call /api/ticker/{ticker}/series for each ticker")
