function Why3findTreemap(id, width, height, data) {

  // Color scale.
  const color = d3.scaleOrdinal(d3.schemeAccent);

  // Treemap layout.
  const root = d3.treemap()
    .tile(d3.treemapSquarify)
    .size([width, height])
    .paddingInner(1)
    .paddingOuter(0)
    .round(true)
    (d3.hierarchy(data, d => d.children)
      .sum(d => d.children ? 0 : d.time)
      .sort((a, b) => b.height - a.height || b.value - a.value));

  // Time format.
  function time(t) {
    if (t < 1.0)
      return Math.round(t * 1000) + 'ms';
    else if (t < 60.0)
      return Math.round(t * 10) / 10 + 's';
    else {
      const m = Math.trunc(t / 60.0);
      const s = Math.round(t - m * 60.0);
      return `${m}' ${s}s`;
    }
  }

  // SVG container.
  const svg =
    d3.select(id).append("svg")
      .attr("viewBox", [-3, -32, width+6, height+35])
      .attr("width", width)
      .attr("height", height)
      .attr("style", "font: 10px monospace;");

  // Add a border for each goals

  const goals = root.descendants().filter(d => d.data.goal);
  const targets =
    svg.append("g")
    .selectAll("g")
    .data(goals)
    .join("g")
    .attr("id", d => d.data.path)
    .attr("class", "goal");

  targets
    .append("text")
    .attr("x", d => Math.min(d.x0, 800 - d.data.path.length * 6))
    .attr("y", -12)
    .attr("fill", "red")
    .attr("opacity", 1)
    .attr("visibility", "hidden")
    .text(d => d.data.path);

  targets
    .append("rect")
    .attr("fill", "red")
    .attr("fill-opacity", 0)
    .attr("x", d => d.x0)
    .attr("y", d => d.y0)
    .attr("width", d => d.x1 - d.x0)
    .attr("height", d => d.y1 - d.y0);

  // Add a cell for each leaf of the hierarchy.
  const leaf = svg.append("g")
    .selectAll("g")
    .data(root.leaves())
    .join("g")
    .attr("transform", d => `translate(${d.x0},${d.y0})`)
    .append("a").attr("href", d => d.data.url);

  // Append a title.
  leaf.append("title").text(d => {
    let title = d.data.path;
    if (d.data.status) title += '\n' + d.data.status;
    const count = (d.data.proved || 0) + (d.data.stuck || 0);
    if (d.data.depth || count > 1)
      title += `\nTotal (${count}) (${time(d.data.time)})`;
    return title;
  });

  // Append a color rectangle.
  leaf.append("rect")
    .attr("fill", d => d.data.stuck ? 'red' : color(d.data.path))
    .attr("fill-opacity", d => d.data.stuck ? 1 : 0.4)
    .attr("width", d => d.x1 - d.x0)
    .attr("height", d => d.y1 - d.y0);

  // Layout
  function layout(lines, width, items, sep) {
    let offset = 0;
    let buffer = '';
    items.forEach(a => {
      if (a.length > width) a = a.substring(0, width - 2) + '…';
      if (offset > 0) {
        const extent = offset + 1 + a.length;
        if (extent <= width) {
          buffer += sep;
          buffer += a;
          offset = extent;
        } else if (offset < width / 2) {
          buffer += sep;
          buffer += a.substring(0, width - offset - 2);
          buffer += '…';
          lines.push(buffer);
          buffer = '';
          offset = 0;
        } else {
          lines.push(buffer);
          buffer = a;
          offset = a.length;
        }
      } else {
        buffer = a;
        offset = a.length;
      }
    });
    if (buffer.length) lines.push(buffer);
  }

  const pathElement = /^[a-zA-Z][a-zA-Z._]*/;
  const pathSubgoal = /(.[0-9]+)+/g;

  // Set text
  leaf
    .selectAll("text")
    .data(d => {
      const h = Math.round((d.y1 - d.y0 - 14) / 12);
      if (h < 1) return [];
      const w = Math.round((d.x1 - d.x0 - 12) / 6);
      if (w < 5) return [];
      const lines = [];
      let path = d.data.path;
      let subgoal = path.search(pathSubgoal);
      if (subgoal > 0) path = path.substring(0, subgoal);
      layout(lines, w, path.split('.'), '.');
      if (lines.length < h) {
        const status = d.data.status;
        const stats = status ? status.split(' ').filter(d => d !== 'Valid') : [];
        const count = (d.data.stuck || 0) + (d.data.proved || 0);
        if (d.data.count > 1) {
          stats.push(`(${count})`);
          stats.push(`(${time(d.data.time)})`);
        }
        layout(lines, w, stats, ' ');
      }
      if (lines.length > h)
        return lines.slice(0, h);
      return lines;
    })
    .join("text")
    .attr("x", 5)
    .attr("y", (_, i) => 14 + i * 12)
    .attr("opacity", txt => pathElement.test(txt) ? 1 : 0.5)
    .text(txt => txt);

}
