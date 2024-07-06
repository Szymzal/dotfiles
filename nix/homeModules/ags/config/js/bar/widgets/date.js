import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Clock from './clock.js';

export default ({ window = 'dashboard', format = '%d.%m.%y - %H:%M', ...rest } = {}) => {
  let open = false;

  return Widget.Button({
    class_name: "popup-button",
    setup: button => {
      button.hook(App, self => {
        const win = App.getWindow(window);

        if (win) {
          if (open && !win.visible) {
            open = false;
            self.toggleClassName('button-active', false);
          }

          if (win.visible) {
            open = true;
            self.toggleClassName('button-active');
          }
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
