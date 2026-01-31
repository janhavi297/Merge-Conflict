from fastapi import FastAPI
from api.backtest import router as backtest_router
from api.recommendation import router as recommendation_router

app = FastAPI(title="Nocturne Engine")

app.include_router(backtest_router)
app.include_router(recommendation_router)
