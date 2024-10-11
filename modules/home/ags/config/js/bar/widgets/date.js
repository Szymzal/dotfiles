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
