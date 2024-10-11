import { perMonitor } from "./utils.js";
import Bar from "./bar/bar.js";
import Dashboard from './bar/widgets/dashboard.js';

const windows = () => [
  perMonitor(Bar),
  Dashboard(),
];

App.config({
  windows: windows().flat(1),
  style: './style/main.css',
});
