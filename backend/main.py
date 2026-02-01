from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from api.backtest import router as backtest_router
from api.recommendation import router as recommendation_router
from api.graphs import router as graphs_router
from api.performance import router as performance_router
from api.news import router as news_router

app = FastAPI(title="Nocturne Trading Engine")

# 🔥 THIS IS THE KEY FIX 🔥
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],   # allow localhost:3000
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(backtest_router)
app.include_router(recommendation_router)
app.include_router(graphs_router)
app.include_router(performance_router)
app.include_router(news_router)

