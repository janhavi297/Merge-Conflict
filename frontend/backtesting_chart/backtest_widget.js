function renderBacktestChart(containerId) {
  const width = 1000;
  const height = 500;
  const margin = { top: 20, right: 30, bottom: 50, left: 80 };

  const container = d3.select(`#${containerId}`);
  container.html(""); // clear previous render

  const svg = container
    .append("svg")
    .attr("width", width)
    .attr("height", height);

  const chartWidth = width - margin.left - margin.right;
  const chartHeight = height - margin.top - margin.bottom;

  const g = svg.append("g")
    .attr("transform", `translate(${margin.left},${margin.top})`);

  fetch("http://127.0.0.1:9000/api/backtest")
    .then(res => res.json())
    .then(data => drawChart(data.strategy, data.buy_and_hold));

  function drawChart(strategy, buyAndHold) {
    const allData = strategy.concat(buyAndHold);

    const x = d3.scaleLinear()
      .domain(d3.extent(allData, d => d.DaysPassed))
      .range([0, chartWidth]);

    const y = d3.scaleLinear()
      .domain(d3.extent(allData, d => d.PortfolioValue))
      .nice()
      .range([chartHeight, 0]);

    g.append("g")
      .attr("transform", `translate(0,${chartHeight})`)
      .call(d3.axisBottom(x));

    g.append("g")
      .call(d3.axisLeft(y));

    const line = d3.line()
      .x(d => x(d.DaysPassed))
      .y(d => y(d.PortfolioValue))
      .curve(d3.curveLinear);

    g.append("path")
      .datum(strategy)
      .attr("fill", "none")
      .attr("stroke", "steelblue")
      .attr("stroke-width", 2)
      .attr("d", line);

    g.append("path")
      .datum(buyAndHold)
      .attr("fill", "none")
      .attr("stroke", "red")
      .attr("stroke-width", 2)
      .attr("d", line);

    g.append("text")
      .attr("x", chartWidth / 2)
      .attr("y", chartHeight + 40)
      .attr("fill", "#c9d1d9")
      .attr("text-anchor", "middle")
      .text("Days Passed");

    g.append("text")
      .attr("transform", "rotate(-90)")
      .attr("x", -chartHeight / 2)
      .attr("y", -60)
      .attr("fill", "#c9d1d9")
      .attr("text-anchor", "middle")
      .text("Portfolio Value");
  }
}
