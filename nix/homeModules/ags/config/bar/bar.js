import DateButton from "./widgets/date.js";
import Workspaces from "./widgets/workspaces.js";

const Start = () => Widget.Box({
  class_name: 'start',
  children: [
    Workspaces()
  ],
});

const Center = () => Widget.Box({
  class_name: 'center',
  children: [
    DateButton()
  ],
});

const End = () => Widget.Box({
  class_name: 'end',
  children: [

  ],
});

export default (/** @type {number} */ monitor) => Widget.Window({
  monitor,
  name: `bar${monitor}`,
  anchor: ['top', 'left', 'right'],
  exclusivity: 'exclusive',
  child: Widget.CenterBox({
    class_name: 'panel',
    start_widget: Start(),
    center_widget: Center(),
    end_widget: End(),
  }),
})

