import Widget from 'resource:///com/github/Aylur/ags/widget.js';

let name = 'dashboard';

export default () => Widget.Window({
  name: name,
  visible: false,
  keymode: 'on-demand',
  anchor: ['top'],
  class_names: ['popup-window', name],
  child: Widget.Box({
    children: [
      Widget.Label({
        label: "Test",
      }),
    ],
  }),
  setup: window => {
    window.keybind("Escape", () => App.closeWindow(name));
  },
});
