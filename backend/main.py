import yfinance as yf
import numpy as np
import pandas as pd
from datetime import datetime
pd.set_option("display.max_rows", None)
pd.set_option("display.max_columns", None)
pd.set_option("display.width", None)
pd.set_option("display.max_colwidth", None)

CAPITAL=10000000
START_DATE="2018-01-01"
END_DATE=datetime.now()

TICKERS = ["^NSEI","^BSESN","^NSEBANK","^CNXPHARMA","^CNXAUTO","^CNXMETAL","^CNXENERGY","^CNXFMCG","^CNXIT","^CNXCMDT"]

friction=((0.0003+0.0000173+0.000001)*1.18+0.00002)+((0.0003+0.0000173+0.000001)*1.18+0.0002)
#brokerage, exchange, SEBI, GST, stamp, STT tax
#Brokerage(Both ways included)+STT(Selling only)+(Exchange+SEBI+Clearing Fees)+GST+Stamp Duty+Slippage
#friction=(0.00002*2+0.0002)*1.18+0.0001+0.0004 #conservative
df=yf.download(TICKERS, start=START_DATE, end=END_DATE, auto_adjust=False)
df=df.stack(level=1).reset_index()
df.columns.name=None
df=df.drop(columns="Adj Close")
df=df.sort_values(["Ticker","Date"]).reset_index(drop=True)
df["PriceInc"]=df.groupby("Ticker")["Close"].pct_change()
df["OvernightInc"]=(1+(df.groupby("Ticker")["Open"].shift(-1)-df["Close"])/df["Close"])*(1-friction)
df["OvernightIncCumm"]=df.groupby("Ticker")["OvernightInc"].cumprod()
df["Target"]=(df["OvernightInc"]>1).astype(int)


condition1=(abs(df["High"]-df["Low"])/abs(df["High"]-df["Close"]))>4 
condition2=(abs(df["High"]-df["Low"])/abs(df["Open"]-df["Close"]))<1.1 
#print(f"Condition1: {len(condition1==True)/len(df)}")
#print(f"Condition2: {len(condition2==True)/len(df)}")

#condition3=(df["Close"]>df.groupby("Ticker")["Open"].shift(1))&(df["Open"]<df.groupby("Ticker")["Close"].shift(1)) 
df["Position"]=((condition1|condition2)|(df["Close"]>df["Open"])).astype(int)

df["Momentum"]=df["Close"]/df["Open"]
df["Momentum"]=np.where(df["Position"]==0,0,df["Momentum"])
daily=df.groupby("Date")["Momentum"].transform("sum")
df["Weightage"]=df["Momentum"]/daily
#df["Weightage"]=df["RollingSharpe"]/(df.groupby("Date")["RollingSharpe"].transform("sum"))
df=df.sort_values(["Date", "Ticker"]).reset_index(drop=True)



df["Date"]=pd.to_datetime(df["Date"])
START_DATE=pd.to_datetime(START_DATE)
df["DaysPassed"]=(df["Date"]-START_DATE).dt.days



df["CapitalAllocated"]=CAPITAL*df["Weightage"]
df["StratFractionPnL"]=(df["OvernightInc"]-1)*df["Weightage"]
daily_return=df.groupby("Date")["StratFractionPnL"].sum()
mean_ret=daily_return.mean()
volatility_ret=daily_return.std()
print(f"Sharpe Ratio: {np.sqrt(252)*mean_ret/volatility_ret}")


portfolio=CAPITAL*(1+daily_return).cumprod()
portfolio=portfolio.reset_index()
portfolio.columns=["Date","PortfolioValue"]
portfolio["DaysPassed"]=(portfolio["Date"]-START_DATE).dt.days


#CAGR
years=(df["Date"].iloc[-1]-df["Date"].iloc[0]).days/365.25
CAGR=np.power((portfolio["PortfolioValue"].iloc[-1]/CAPITAL),1/years)-1
print(f"CAGR: {100*CAGR:.2f}%")


#DRAWDOWN
rollingmax=portfolio["PortfolioValue"].cummax()
drawdown=(portfolio["PortfolioValue"]/rollingmax)-1
max_dd=drawdown.min()
print(f"Max Drawdown: {100*max_dd:.2f}%")



daily_returnBH=df.groupby("Date")["PriceInc"].mean()
portfolioBH=CAPITAL*(1+daily_returnBH).cumprod()
portfolioBH=portfolioBH.reset_index()
portfolioBH.columns=["Date","B&HPortfolioValue"]
portfolioBH["DaysPassed"]=(portfolioBH["Date"]-START_DATE).dt.days


#portfolioB&H=df.groupby("Date")["B&HP&L"].cumprod()
#portfolioB&H.columns=["Date","B&HPortfolioValue"]
#portfolioB&H["DaysPassed"]=(portfolioB&H["Date"]-START_DATE).dt.days

#df["PortfolioValue"]=CAPITAL*((1+daily_return).cumprod())

#print(df)


#df["StratPnL"]=df["CapitalAllocated"]*(df["OvernightInc"]-1)
#df["PresentCapital"]=CAPITAL+(df["StratPnL"]).cumsum()

#print(df[["Date","Ticker","CapitalAllocated","StratFractionPnL","PortfolioValue"]])


#df["CapitalAllocatedB&H"]=CAPITAL/len(TICKERS)
#df["B&HPnL"]=df["CapitalAllocatedB&H"]*(df["PriceInc"]-1)
#df["PresentCapitalB&H"]=CAPITAL+(df["B&HPnL"]).cumsum()
portfolio=portfolio.dropna()
#print(portfolio)

import matplotlib.pyplot as plt
plt.figure(figsize=(12,6))
plt.plot(portfolio["DaysPassed"],portfolio["PortfolioValue"],label="MAJAKCapital", color="blue")
plt.plot(portfolioBH["DaysPassed"],portfolioBH["B&HPortfolioValue"],label="B&H", color="red")
plt.title("Portfolio value vs days passed")
plt.legend()
plt.show()


print(df.columns.tolist())
print(df.head())
print()
print()
print()
print()
print()
print()
print()
print()
print()
print(df.tail())
print()
print()
print()
print()
print()

