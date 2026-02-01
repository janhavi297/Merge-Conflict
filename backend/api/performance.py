from fastapi import APIRouter
import numpy as np
from strategy.data_loader import load_data
from strategy.strategy_core import run_strategy

router = APIRouter(prefix="/api", tags=["performance"])

@router.get("/performance")
def performance():
    df = load_data()
    _, _, portfolio_bh = run_strategy(df)

    # Strategy daily returns
    # recompute exactly like notebook
    daily_return = df.groupby("Date")["StratFractionPnL"].sum()

    mean = daily_return.mean()
    std = daily_return.std()
    sharpe = float(np.sqrt(252) * mean / std)

    return {
        "sharpe": sharpe
    }



'''from fastapi import APIRouter
import numpy as np

router = APIRouter(prefix="/api", tags=["performance"])

@router.get("/performance")
def performance(daily_return: list[float]):
    mean = np.mean(daily_return)
    std = np.std(daily_return)

    sharpe = np.sqrt(252) * mean / std

    return {
        "sharpe": sharpe
    }
'''