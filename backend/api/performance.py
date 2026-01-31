from fastapi import APIRouter
import numpy as np

router = APIRouter()

@router.get("/performance")
def performance(daily_return: list[float]):
    mean = np.mean(daily_return)
    std = np.std(daily_return)

    sharpe = np.sqrt(252) * mean / std

    return {
        "sharpe": sharpe
    }
