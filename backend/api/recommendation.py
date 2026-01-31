from fastapi import APIRouter
from strategy.data_loader import load_data
from strategy.strategy_core import run_strategy
from strategy.recommender import generate_recommendation

router = APIRouter()

@router.get("/recommendation")
def recommendation():
    df = load_data()
    df, _, _ = run_strategy(df)
    return generate_recommendation(df)
