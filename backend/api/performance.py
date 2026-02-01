# api/performance.py
from fastapi import APIRouter
import numpy as np
from strategy.data_loader import load_data
from strategy.strategy_core import run_strategy
from strategy.config import CAPITAL

router = APIRouter(prefix="/api", tags=["performance"])

@router.get("/performance")
def performance():
    df = load_data()
    _, portfolio, _ = run_strategy(df)

    # ===== DAILY RETURNS =====
    portfolio = portfolio.sort_values("Date")
    daily_returns = portfolio["PortfolioValue"].pct_change().dropna()

    # ===== CAGR =====
    years = (portfolio["Date"].iloc[-1] - portfolio["Date"].iloc[0]).days / 365.25
    cagr = (portfolio["PortfolioValue"].iloc[-1] / CAPITAL) ** (1 / years) - 1

    # ===== MAX DRAWDOWN =====
    rolling_max = portfolio["PortfolioValue"].cummax()
    drawdown = (portfolio["PortfolioValue"] / rolling_max) - 1
    max_dd = drawdown.min()

    # ===== SHARPE RATIO =====
    sharpe = (
        daily_returns.mean() / daily_returns.std()
    ) * np.sqrt(252)   # annualized

    return {
        "cagr": round(cagr * 100, 2),          # %
        "max_drawdown": round(max_dd * 100, 2),# %
        "sharpe": round(sharpe, 2)
    }
