import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import GLib from 'gi://GLib';

const Clock = (
  /** @type {import('types/widgets/label').LabelProps & {
  * format?: string,
  * interval?: number,
  * }}
  */
  {
    format = '%H:%M:%S %B %e. %A',
    interval = 1000,
    ...rest
  } = {}) => {
  const dateTime = Variable('', {
    poll: [interval, () => { return GLib.DateTime.new_now_local().format(format) || 'wrong format'; }]
  });

  return Widget.Label({
    class_name: 'clock',
    ...rest,
    label: dateTime.bind().as(value => value.toString()),
  })
};

export default ({ window = 'dashboard', format = '%d.%m.%y - %H:%M', ...rest } = {}) => {
  let open = false;

  return Widget.Button({
    class_name: "popup-button",
    setup: button => {
      button.hook(App, self => {
        const win = App.get_active_window();

        if (win && win.name == window) {
          if (open && !win.visible) {
            open = false;
            self.toggleClassName('active', false);
          }

          if (win.visible) {
            open = true;
            self.toggleClassName('active');
          }
        }
      });
    },
    on_clicked: () => App.toggleWindow(window),
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
