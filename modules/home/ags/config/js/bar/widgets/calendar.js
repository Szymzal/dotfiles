import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Clock from "./clock.js";

export default () => Widget.Box({
  vertical: true,
  class_name: "calendar",
  children: [
    Widget.Box({
      class_name: "times",
      vertical: true,
      children: [
        Clock({ format: '%H:%M:%S' }),
        Widget.Calendar({
          hexpand: true,
          hpack: 'center',
        }),
      ],
    }),
  ],
});
