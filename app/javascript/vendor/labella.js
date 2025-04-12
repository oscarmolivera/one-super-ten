import * as d3 from 'd3';
import labella from 'labella';

document.addEventListener('turbo:load', () => {
  const svgElement = document.querySelector('#labella-timeline');
  if (!svgElement) return;

  const width = 700;
  const height = 250;

  const svg = d3.select(svgElement)
    .attr('width', width)
    .attr('height', height);

  const margin = { left: 40, right: 40 };

  const timeScale = d3.scaleLinear()
    .domain([0, 500])
    .range([margin.left, width - margin.right]);

  const rawNodes = [
    { time: 100, label: 'Start' },
    { time: 150, label: 'Prep' },
    { time: 170, label: 'Train' },
    { time: 200, label: 'Play' },
    { time: 250, label: 'Rest' },
    { time: 290, label: 'Repeat' },
    { time: 350, label: 'Recover' }
  ];

  // Create nodes with ideal positions
  const nodes = rawNodes.map(d => new labella.Node(timeScale(d.time), 60, d));

  const force = new labella.Force({
    minPos: margin.left,
    maxPos: width - margin.right
  });

  force.nodes(nodes).compute();

  const computedNodes = force.nodes();

  const rectHeight = 20;

  // Connector lines
  svg.selectAll('path.link')
    .data(computedNodes)
    .enter()
    .append('path')
    .attr('d', d => {
      const x = d.target?.x;
      const y = d.target?.y;
      const ideal = d.getRoot().idealPos;
      if (typeof x !== 'number' || typeof y !== 'number') return '';
      return `M${ideal},0V${y - 5}H${x}`;
    })
    .attr('stroke', '#ccc')
    .attr('fill', 'none');

  // Label groups
  const label = svg.selectAll('g.label')
    .data(computedNodes)
    .enter()
    .append('g')
    .attr('class', 'label')
    .attr('transform', d => {
      const x = d.target?.x;
      const y = d.target?.y;
      if (typeof x !== 'number' || typeof y !== 'number') return null;
      return `translate(${x},${y})`;
    });

  label.append('rect')
    .attr('x', d => -d.width / 2)
    .attr('y', -rectHeight / 2)
    .attr('width', d => d.width)
    .attr('height', rectHeight)
    .attr('rx', 4)
    .attr('fill', '#1f77b4');

  label.append('text')
    .attr('dy', '0.35em')
    .attr('text-anchor', 'middle')
    .text((d, i) => d.data.label)
    .attr('fill', 'white')
    .style('font-size', '11px');
});