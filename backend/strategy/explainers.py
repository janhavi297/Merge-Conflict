# strategy/explainers.py
import yfinance as yf
import pandas as pd
from .config import START_DATE, END_DATE
from datetime import datetime
from pandas.tseries.offsets import BDay

def make_explanation(row):
    parts = []
    if row.get("condition1", False):
        parts.append("Bullish Hammer")
    if row.get("condition2", False):
        parts.append("Bullish Marobozu")
    if row.get("condition3", False):
        parts.append("Momentum from the day's trading")
    return "; ".join(parts) if parts else "none"

def compute_live_recommendations_with_explanations(df):
    """
    Input: full df (same as from data_loader.load_data()) with Position, etc.
    Returns:
      df_live: dataframe rows for last_date (with CapitalAllocated etc)
      buy_tickers: list of tickers recommended to BUY for next day (where Position==1 in df_live)
    """
    # Ensure Date is datetime
    df = df.copy()
    df["Date"] = pd.to_datetime(df["Date"])

    last_date = df["Date"].max()
    df_live = df[df["Date"] == last_date].copy()

    # Build condition flags exactly as in your cell 4
    df_live["condition1"] = ((abs(df_live["High"]-df_live["Low"]) / abs(df_live["High"]-df_live["Close"])) > 4) & (df_live["Close"] > df_live["Open"])
    df_live["condition2"] = (abs(df_live["High"]-df_live["Low"]) / abs(df_live["Open"]-df_live["Close"])) < 1.1
    df_live["condition3"] = df_live["Close"] > df_live["Open"]
    df_live["Position"] = ((df_live["condition1"] | df_live["condition2"]) | df_live["condition3"]).astype(int)
    df_live["Explanation"] = df_live[["condition1","condition2","condition3"]].apply(lambda r: make_explanation(r), axis=1)

    buy_tickers = df_live.loc[df_live["Position"]==1, "Ticker"].tolist()

    # next-date calculation (same as Cell 4)
    PRESENT = datetime.now()
    NEXT_DATE = PRESENT.replace(hour=3, minute=30, second=0, microsecond=0)
    if (PRESENT.hour > 3) or (PRESENT.hour == 3 and PRESENT.minute > 30):
        NEXT_DATE = NEXT_DATE + BDay(1)

    return {
        "next_date_for_recommendation": str(NEXT_DATE),
        "df_live": df_live,   # DataFrame to be used server-side as canonical data
        "buy_tickers": buy_tickers
    }

def per_ticker_series_for_buy_list(buy_tickers, start_date=START_DATE, end_date=END_DATE):
    """
    For the given buy_tickers list, fetch full history and compute
    PriceInc (next day / today), cumulative product PriceIncCumm,
    condition flags and Explanation for each row. Return a dictionary:
       { ticker1: [ {date, DaysPassed, PriceIncCumm, Explanation}, ... ], ... }
    """
    if not buy_tickers:
        return {}

    df_show = yf.download(buy_tickers, start=start_date, end=end_date, auto_adjust=False)
    df_show = df_show.stack(level=1).reset_index()
    df_show.columns.name = None
    # drop Adj Close if present
    if "Adj Close" in df_show.columns:
        df_show = df_show.drop(columns=["Adj Close"])

    # Compute PriceInc as next day's close divided by today's close (like you had: shift(-1)/x)
    df_show = df_show.sort_values(["Ticker","Date"]).reset_index(drop=True)
    df_show["PriceInc"] = df_show.groupby("Ticker")["Close"].transform(lambda x: x.shift(-1)/x)
    df_show["PriceIncCumm"] = df_show.groupby("Ticker")["PriceInc"].cumprod()

    # condition flags same as cell4
    condition1 = ((abs(df_show["High"]-df_show["Low"]) / abs(df_show["High"]-df_show["Close"])) > 4) & (df_show["Close"] > df_show["Open"])
    condition2 = (abs(df_show["High"]-df_show["Low"]) / abs(df_show["Open"]-df_show["Close"])) < 1.1
    condition3 = df_show["Close"] > df_show["Open"]

    df_show["condition1"] = condition1
    df_show["condition2"] = condition2
    df_show["condition3"] = condition3
    df_show["Explanation"] = df_show[["condition1","condition2","condition3"]].apply(lambda r: make_explanation(r), axis=1)

    # DaysPassed
    df_show["Date"] = pd.to_datetime(df_show["Date"])
    df_show["DaysPassed"] = (df_show["Date"] - pd.to_datetime(START_DATE)).dt.days.astype(int)

    # Build output dict
    out = {}
    for ticker, sub in df_show.groupby("Ticker"):
        sub = sub.dropna(subset=["PriceIncCumm","DaysPassed"])
        records = sub[["Date","DaysPassed","PriceIncCumm","Explanation"]].copy()
        # Convert date to ISO string
        records["Date"] = records["Date"].astype(str)
        out[ticker] = records.to_dict(orient="records")
    return out
