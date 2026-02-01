function renderTickerChart(containerId, ticker) {
  const margin = { top: 40, right: 30, bottom: 50, left: 70 };
  const width = 900 - margin.left - margin.right;
  const height = 450 - margin.top - margin.bottom;

  // Clear container (important for re-render)
  d3.select(`#${containerId}`).html("");

  // Title
  d3.select(`#${containerId}`)
    .append("h3")
    .attr("class", "chart-title")
    .text(`${ticker} Value`);

  const svg = d3
    .select(`#${containerId}`)
    .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", `translate(${margin.left},${margin.top})`);

  const tooltip = d3
    .select("body")
    .append("div")
    .attr("class", "tooltip");

  fetch(`http://127.0.0.1:9000/api/ticker/${encodeURIComponent(ticker)}/series`)
    .then(res => {
      if (!res.ok) {
        throw new Error("Ticker not in today's BUY list");
      }
      return res.json();
    })
    .then(data => {
      const series = data.series;

      series.forEach(d => {
        d.DaysPassed = +d.DaysPassed;
        d.PriceIncCumm = +d.PriceIncCumm;
      });

      series.sort((a, b) => a.DaysPassed - b.DaysPassed);


      // Scales
      const x = d3.scaleLinear()
        .domain(d3.extent(series, d => d.DaysPassed))
        .range([0, width]);

      const y = d3.scaleLinear()
        .domain(d3.extent(series, d => d.PriceIncCumm))
        .nice()
        .range([height, 0]);

      // Grid
      svg.append("g")
        .attr("class", "grid")
        .call(
          d3.axisLeft(y)
            .tickSize(-width)
            .tickFormat("")
        );

      // Axes
      svg.append("g")
        .attr("class", "axis")
        .attr("transform", `translate(0,${height})`)
        .call(d3.axisBottom(x));

      svg.append("g")
        .attr("class", "axis")
        .call(d3.axisLeft(y));

      // Line
      const line = d3.line()
        .x(d => x(d.DaysPassed))
        .y(d => y(d.PriceIncCumm));

      svg.append("path")
        .datum(series)
        .attr("fill", "none")
        .attr("stroke", "#58a6ff")
        .attr("stroke-width", 2)
        .attr("d", line);

      // Invisible hover points
      svg.selectAll(".hover-point")
        .data(series)
        .enter()
        .append("circle")
        .attr("cx", d => x(d.DaysPassed))
        .attr("cy", d => y(d.PriceIncCumm))
        .attr("r", 5)
        .attr("fill", "transparent")
        .on("mousemove", (event, d) => {
          tooltip
            .style("opacity", 1)
            .html(`
              <strong>Day:</strong> ${d.DaysPassed}<br/>
              <strong>Value:</strong> ${d.PriceIncCumm.toFixed(4)}<br/>
              <strong>Signal:</strong> ${d.Explanation}
            `)
            .style("left", event.pageX + 12 + "px")
            .style("top", event.pageY - 28 + "px");
        })
        .on("mouseout", () => {
          tooltip.style("opacity", 0);
        });

      // Axis labels
      svg.append("text")
        .attr("x", width / 2)
        .attr("y", height + 40)
        .attr("text-anchor", "middle")
        .attr("fill", "#c9d1d9")
        .text("Days Passed");

      svg.append("text")
        .attr("transform", "rotate(-90)")
        .attr("x", -height / 2)
        .attr("y", -50)
        .attr("text-anchor", "middle")
        .attr("fill", "#c9d1d9")
        .text("Price Increase");
    })
    .catch(err => {
      d3.select(`#${containerId}`)
        .append("div")
        .style("color", "#f85149")
        .style("margin-top", "20px")
        .text(`No BUY signal for ${ticker} today`);
    });
}



