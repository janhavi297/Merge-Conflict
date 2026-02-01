const width = 1000;
const height = 500;
const margin = { top: 20, right: 30, bottom: 50, left: 80 };

const svg = d3.select("#chart");

const chartWidth = width - margin.left - margin.right;
const chartHeight = height - margin.top - margin.bottom;

const g = svg.append("g")
  .attr("transform", `translate(${margin.left},${margin.top})`);

fetch("http://localhost:9000/backtest")
  .then(res => res.json())
  .then(data => {
    drawChart(data.strategy, data.buy_and_hold);
  })
  .catch(err => console.error(err));
function findNearestPoint(data, xValue) {
  return data.reduce((prev, curr) =>
    Math.abs(curr.DaysPassed - xValue) <
    Math.abs(prev.DaysPassed - xValue)
      ? curr
      : prev
  );
}
const bisectDays = d3.bisector(d => d.DaysPassed).left;

function drawChart(strategy, buyAndHold) {

  // Combine both datasets for scaling (matplotlib auto-scale)
  const allData = strategy.concat(buyAndHold);

  const x = d3.scaleLinear()
    .domain(d3.extent(allData, d => d.DaysPassed))
    .range([0, chartWidth]);

  const y = d3.scaleLinear()
    .domain(d3.extent(allData, d => d.PortfolioValue))
    .nice()
    .range([chartHeight, 0]);
  const tooltip = d3.select("#tooltip");

  // Vertical hover line
  const hoverLine = g.append("line")
    .attr("y1", 0)
    .attr("y2", chartHeight)
    .attr("stroke", "white")
    .attr("stroke-dasharray", "4 4")
    .style("opacity", 0);

  // Focus dot — Strategy
  const focusStrategy = g.append("circle")
    .attr("r", 4)
    .attr("fill", "steelblue")
    .style("opacity", 0);

  // Focus dot — Buy & Hold
  const focusBH = g.append("circle")
    .attr("r", 4)
    .attr("fill", "red")
    .style("opacity", 0);



// Transparent overlay to capture mouse events
g.append("rect")
  .attr("width", chartWidth)
  .attr("height", chartHeight)
  .attr("fill", "transparent")
  .on("mousemove", function (event) {
  const [mouseX] = d3.pointer(event);
  const xValue = x.invert(mouseX);

  // Nearest Strategy point
  const iS = bisectDays(strategy, xValue, 1);
  const s0 = strategy[iS - 1];
  const s1 = strategy[iS] || s0;
  const nearestStrategy =
    xValue - s0.DaysPassed > s1.DaysPassed - xValue ? s1 : s0;

  // Nearest Buy & Hold point
  const iBH = bisectDays(buyAndHold, xValue, 1);
  const b0 = buyAndHold[iBH - 1];
  const b1 = buyAndHold[iBH] || b0;
  const nearestBH =
    xValue - b0.DaysPassed > b1.DaysPassed - xValue ? b1 : b0;

  // Hover line
  hoverLine
    .style("opacity", 1)
    .attr("x1", x(nearestStrategy.DaysPassed))
    .attr("x2", x(nearestStrategy.DaysPassed));

  // Strategy dot
  focusStrategy
    .style("opacity", 1)
    .transition()
    .duration(8)
    .attr("cx", x(nearestStrategy.DaysPassed))
    .attr("cy", y(nearestStrategy.PortfolioValue));

  // Buy & Hold dot
  focusBH
    .style("opacity", 1)
    .transition()
    .duration(8)
    .attr("cx", x(nearestBH.DaysPassed))
    .attr("cy", y(nearestBH.PortfolioValue));

  // Tooltip
  tooltip
    .style("opacity", 1)
    .html(`
      <strong>Days Passed:</strong> ${nearestStrategy.DaysPassed}<br/>
      <span style="color: steelblue">● Strategy:</span>
      ${nearestStrategy.PortfolioValue.toFixed(2)}<br/>
      <span style="color: red">● Buy & Hold:</span>
      ${nearestBH.PortfolioValue.toFixed(2)}
    `)
    .style("left", (event.pageX + 12) + "px")
    .style("top", (event.pageY - 28) + "px");
})

  .on("mouseleave", function () {
  tooltip.style("opacity", 0);
  hoverLine.style("opacity", 0);
  focusStrategy.style("opacity", 0);
  focusBH.style("opacity", 0);
});



  // Axes (matplotlib-like defaults)
  g.append("g")
    .attr("transform", `translate(0,${chartHeight})`)
    .call(d3.axisBottom(x));

  g.append("g")
    .call(d3.axisLeft(y));

  // Line generator (STRAIGHT lines — VERY IMPORTANT)
  const line = d3.line()
    .x(d => x(d.DaysPassed))
    .y(d => y(d.PortfolioValue))
    .curve(d3.curveLinear); // 🔴 this matches matplotlib

  // Strategy line (blue)
  g.append("path")
    .datum(strategy)
    .attr("fill", "none")
    .attr("stroke", "steelblue")
    .attr("stroke-width", 2)
    .attr("d", line);

  // Buy & Hold line (red)
  g.append("path")
    .datum(buyAndHold)
    .attr("fill", "none")
    .attr("stroke", "red")
    .attr("stroke-width", 2)
    .attr("d", line);

  // Axis labels (same as matplotlib)
  g.append("text")
    .attr("x", chartWidth / 2)
    .attr("y", chartHeight + 40)
    .attr("text-anchor", "middle")
    .attr("fill", "white")
    .text("Days Passed");

  g.append("text")
    .attr("transform", "rotate(-90)")
    .attr("x", -chartHeight / 2)
    .attr("y", -60)
    .attr("text-anchor", "middle")
    .attr("fill", "white")
    .text("Portfolio Value");
}
