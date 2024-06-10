import { perMonitor } from "./utils.js";
import Bar from "./bar/bar.js";

const windows = () => [
  perMonitor(Bar),
];

App.config({
  windows: windows().flat(1),
  style: './style/main.css',
})
