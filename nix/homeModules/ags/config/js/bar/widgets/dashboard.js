import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Calendar from './calendar.js';

let name = 'dashboard';

export default () => Widget.Window({
  name: name,
  visible: false,
  keymode: 'on-demand',
  anchor: ['top'],
  class_names: ['popup-window', name],
  child: Widget.Box({
    vertical: true,
    children: [
      Calendar(),
    ],
  }),
  setup: window => {
    window.keybind("Escape", () => App.closeWindow(name));
  },
});
