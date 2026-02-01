# Nocturn Capital

### Overview
Nocturn Capitals is a long-only overnight strategy built on Indian index futures. Every day we allocate a fixed pool of capital across a portfolio of indexes, enter positions at market close, and liquidate them at the next day's open- using momentum-based strategies and candlestick patterns. The platform maintains a universe of liquid Indian indexes to choose from. On any given day, the algorithm may allocate more capital to certain indexes, less to others, or none at all when no buy signal is generated. There is no shorting; the strategy only makes two decisions: BUY at close or STAY OUT. Risk is controlled through allocation, not leverage or speculation.

#### Why Indian Index Futures ??
Index futures offer lower brokerage and impact costs than trading individual stocks, while indexes themselves carry less company-specific noise and clearer directional structure. Through research, we found the edge to be specific to Indian markets; the same logic fails on global indexes where participant behaviour and overnight dynamics differ.

### Features
- Algorithmic Signals: Real-time generation of trading vectors based on daily volatility and market close data.
- Predictive Terminal: A dedicated dashboard showing current session signals, asset allocation (SPY/QQQ), and projected overnight gaps.
- Historical Backtesting: A robust 10-year backtest engine showing equity curves, CAGR, Max Drawdown, and Sharpe Ratio since 2015.
- Interactive Data Visualisation: Dynamic charts rendering index signal curves and portfolio value comparisons against benchmarks.
- Neural Feed: A live data stream component for monitoring encrypted session activity.
- Responsive Dark UI: A modern, high-contrast interface designed for clarity and professional use.

### Tech Stack
- Frontend: HTML and CSS
- Data Visualisation: D3.js for the performance graphs.
- Backend: Node.js / Express.js
- Database/Storage: Integration for historical index data and backtesting logs.

### Installation

### Demo Video

### User Flow

