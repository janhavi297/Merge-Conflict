from datetime import datetime
from pandas.tseries.offsets import BDay

def generate_recommendation(df):
    last_date = df["Date"].max()
    df_live = df[df["Date"] == last_date]

    PRESENT = datetime.now()
    NEXT_DATE = PRESENT.replace(hour=3, minute=30, second=0, microsecond=0)

    if (PRESENT.hour > 3) or (PRESENT.hour == 3 and PRESENT.minute > 30):
        NEXT_DATE += BDay(1)

    recommendations = df_live[["Ticker", "CapitalAllocated"]]

    return {
        "date": str(NEXT_DATE),
        "allocations": recommendations.to_dict(orient="records")
    }
