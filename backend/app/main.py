from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from app.strategy import generate_chart

app = FastAPI()

app.mount("/static", StaticFiles(directory="static"), name="static")

@app.get("/chart", response_class=HTMLResponse)
def chart():
    generate_chart()
    return """
    <html>
      <head>
        <title>Strategy Chart</title>
      </head>
      <body>
        <h2>Portfolio Performance</h2>
        <img src="/static/chart.png" width="100%">
      </body>
    </html>
    """
