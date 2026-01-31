import numpy as np
import pandas as pd
from .data_loader import CAPITAL, START_DATE

def run_strategy(df):
    df["Momentum"] = df["Close"] / df["Open"]
    df["Momentum"] = np.where(df["Position"] == 0, 0, df["Momentum"])

    daily = df.groupby("Date")["Momentum"].transform("sum")
    df["Weightage"] = df["Momentum"] / daily

    df["Date"] = pd.to_datetime(df["Date"])
    START_DATE_DT = pd.to_datetime(START_DATE)
    df["DaysPassed"] = (df["Date"] - START_DATE_DT).dt.days

    df["CapitalAllocated"] = CAPITAL * df["Weightage"]
    df["StratFractionPnL"] = (df["OvernightInc"] - 1) * df["Weightage"]

    # ===== STRATEGY PORTFOLIO (same as notebook) =====
    daily_return = df.groupby("Date")["StratFractionPnL"].sum()
    portfolio = CAPITAL * (1 + daily_return).cumprod()
    portfolio = portfolio.reset_index()
    portfolio.columns = ["Date", "PortfolioValue"]
    portfolio["DaysPassed"] = (portfolio["Date"] - START_DATE_DT).dt.days

    # ===== BUY & HOLD PORTFOLIO (same as notebook) =====
    daily_return_bh = df.groupby("Date")["PriceInc"].mean()
    portfolio_bh = CAPITAL * (1 + daily_return_bh).cumprod()
    portfolio_bh = portfolio_bh.reset_index()
    portfolio_bh.columns = ["Date", "PortfolioValue"]
    portfolio_bh["DaysPassed"] = (portfolio_bh["Date"] - START_DATE_DT).dt.days

    portfolio = portfolio.dropna()
    portfolio_bh = portfolio_bh.dropna()


    return df, portfolio, portfolio_bh
