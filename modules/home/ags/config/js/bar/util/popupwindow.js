import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export default ({
  name,
  child,
  ...props
}) => {
  return Widget.Window({
    name,
    visible: false,
    layer: 'overlay',
    class_names: ['popup-window', name],
    ...props,

    child: Widget.Box({
      setup: (self) => {
        self.keybind("Escape", () => {
          App.closeWindow(name);
        });
      },
      child: child,
    }),
  });
}
