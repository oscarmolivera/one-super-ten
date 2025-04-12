import { Timeline } from 'vis-timeline';
import { DataSet } from 'vis-data';
import 'vis-timeline/dist/vis-timeline-graph2d.min.css';

document.addEventListener('turbo:load', () => {
  const container = document.getElementById('my-timeline');
  if (!container) return;

  const items = new DataSet([
    { id: 1, content: 'Kickoff', start: '2025-04-10' },
    { id: 2, content: 'Training', start: '2025-04-11' },
    { id: 3, content: 'Scrimmage', start: '2025-04-13' },
    { id: 4, content: 'Match Day', start: '2025-04-15' },
    { id: 5, content: 'Recovery', start: '2025-04-17' },
  ]);

  const options = {
    orientation: 'top',
    showCurrentTime: true,
    height: '250px',
    margin: {
      item: 10,
      axis: 5
    },
    editable: false,
  };

  new Timeline(container, items, options);
});