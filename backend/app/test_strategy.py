import yfinance as yf
import numpy as np
import pandas as pd
from datetime import datetime
import matplotlib.pyplot as plt

def generate_chart():
    CAPITAL = 10_000_000
    START_DATE = "2018-01-01"
    END_DATE = datetime.now()

    TICKERS = [
        "^NSEI","^BSESN","^NSEBANK","^CNXPHARMA","^CNXAUTO",
        "^CNXMETAL","^CNXENERGY","^CNXFMCG","^CNXIT","^CNXCMDT"
    ]

    friction = ((0.0003+0.0000173+0.000001)*1.18+0.00002) + \
               ((0.0003+0.0000173+0.000001)*1.18+0.0002)

    df = yf.download(TICKERS, start=START_DATE, end=END_DATE)
    df = df.stack(level=1).reset_index()
    df.columns.name = None
    #df = df.drop(columns="Adj Close")
    df = df.sort_values(["Ticker","Date"]).reset_index(drop=True)

    df["PriceInc"] = df.groupby("Ticker")["Close"].pct_change()
    df["OvernightInc"] = (
        1 + (df.groupby("Ticker")["Open"].shift(-1) - df["Close"]) / df["Close"]
    ) * (1 - friction)

    condition1 = (abs(df["High"] - df["Low"]) / abs(df["High"] - df["Close"])) > 4
    condition2 = (abs(df["High"] - df["Low"]) / abs(df["Open"] - df["Close"])) < 1.1

    df["Position"] = ((condition1 | condition2) | (df["Close"] > df["Open"])).astype(int)
    df["Momentum"] = np.where(df["Position"] == 0, 0, df["Close"] / df["Open"])

    daily = df.groupby("Date")["Momentum"].transform("sum")
    df["Weightage"] = df["Momentum"] / daily
    df["StratFractionPnL"] = (df["OvernightInc"] - 1) * df["Weightage"]

    daily_return = df.groupby("Date")["StratFractionPnL"].sum()
    portfolio = CAPITAL * (1 + daily_return).cumprod()

    # Buy & Hold
    daily_returnBH = df.groupby("Date")["PriceInc"].mean()
    portfolioBH = CAPITAL * (1 + daily_returnBH).cumprod()

    # Plot
    plt.figure(figsize=(12, 6))
    plt.plot(portfolio.index, portfolio.values, label="Strategy")
    plt.plot(portfolioBH.index, portfolioBH.values, label="Buy & Hold")
    plt.legend()
    plt.title("Portfolio Value Over Time")
    plt.tight_layout()

    # Save as HTML-compatible image
    plt.savefig("static/chart.png")
    plt.close()
