from fastapi import APIRouter
from strategy.data_loader import load_data
from strategy.strategy_core import run_strategy

router = APIRouter(prefix="/api", tags=["backtest"])

@router.get("/backtest")
def backtest():
    df = load_data()
    df, portfolio, portfolio_bh = run_strategy(df)

    return {
        "strategy": portfolio.to_dict(orient="records"),
        "buy_and_hold": portfolio_bh.to_dict(orient="records")
    }

