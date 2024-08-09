import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Gdk from 'gi://Gdk';
import Clock from './clock.js';

export default ({ window = 'dashboard', format = '%d.%m.%y - %H:%M', ...rest } = {}) => {
  return Widget.Button({
    class_name: "popup-button",
    setup: button => {
      button.hook(App, (self, currentName, visible) => {
        if (currentName === 'dashboard') {
          self.toggleClassName('button-active', visible);

          const monitor = App.getWindow(currentName);
          const window_display = monitor?.widget;
          const default_display = Gdk.Display.get_default();
          // if (window_display) {
          //   const test = default_display?.get_monitor_at_window(window_display);
          //   console.log(test);
          // }
          const monitor_num = default_display?.get_n_monitors() || 1;
          for (let i = 0; i < monitor_num; i++) {
            // const display = default_display?.get_monitor(i);
            // console.log(display);
            // const work_area = display?.get_workarea();
            // console.log(`x: ${work_area?.x}, y: ${work_area?.y}, width: ${work_area?.width}, height: ${work_area?.height}`);
          }
          // const win_on_place = default_display?.get_monitor_at_point(3000, 0);
          // console.log(win_on_place);
        }
      });
    },
    on_clicked: () => {
      App.toggleWindow(window);
    },
    child: Widget.Box({
      children: [
        Clock({
          format,
          hpack: 'center',
        })
      ],
    }),
    ...rest
  });
};
