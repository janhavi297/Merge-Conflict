
# api/recommendation.py
from fastapi import APIRouter
from strategy.data_loader import load_data
from strategy.strategy_core import run_strategy  # keeps original weights if needed
from strategy.explainers import compute_live_recommendations_with_explanations, per_ticker_series_for_buy_list

router = APIRouter(prefix="/api", tags=["recommendation"])

@router.get("/recommendation")
def recommendation():
    # load original dataframe and run weighting (so CapitalAllocated exists)
    df = load_data()
    # we assume run_strategy populates CapitalAllocated etc. If not, compute weights exactly as in strategy_core
    # But simplest: reuse df as it has CapitalAllocated if you call the correct pipeline; if not, compute weights here
    # For safety, call run_strategy to enforce same data transforms
    _, _, _ = run_strategy(df)  # ensures columns present

    res = compute_live_recommendations_with_explanations(df)
    df_live = res["df_live"]

    # prepare JSON response with allocations + explanation per ticker
    allocations = df_live[["Ticker","CapitalAllocated","Explanation"]].to_dict(orient="records")
    return {
        "next_date": res["next_date_for_recommendation"],
        "buy_tickers": res["buy_tickers"],
        "allocations": allocations
    }
