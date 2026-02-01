import yfinance as yf
import numpy as np
import pandas as pd
from datetime import datetime
from .config import CAPITAL, START_DATE, END_DATE, TICKERS, FRICTION


CAPITAL = 10_000_000
START_DATE = "2015-01-01"
END_DATE = datetime.now()

TICKERS = [
    "^NSEI","^BSESN","^NSEBANK","^CNXPHARMA",
    "^CNXAUTO","^CNXMETAL","^CNXENERGY",
    "^CNXFMCG","^CNXCMDT","^CNXMEDIA"
]

FRICTION = (
    ((0.0003+0.0000173+0.000001)*1.18+0.00002) +
    ((0.0003+0.0000173+0.000001)*1.18+0.0002)
)

def load_data():
    df = yf.download(TICKERS, start=START_DATE, end=END_DATE, auto_adjust=False)
    df = df.stack(level=1).reset_index()
    df.columns.name = None
    df = df.drop(columns="Adj Close")
    df = df.sort_values(["Ticker", "Date"]).reset_index(drop=True)

    df["PriceInc"] = df.groupby("Ticker")["Close"].pct_change()
    df["OvernightInc"] = (
        1 + (df.groupby("Ticker")["Open"].shift(-1) - df["Close"]) / df["Close"]
    ) * (1 - FRICTION)

    df["OvernightIncCumm"] = df.groupby("Ticker")["OvernightInc"].cumprod()
    df["Target"] = (df["OvernightInc"] > 1).astype(int)

    condition1 = (abs(df["High"] - df["Low"]) / abs(df["High"] - df["Close"])) > 4
    condition2 = (abs(df["High"] - df["Low"]) / abs(df["Open"] - df["Close"])) < 1.1

    df["Position"] = ((condition1 | condition2) | (df["Close"] > df["Open"])).astype(int)

    return df