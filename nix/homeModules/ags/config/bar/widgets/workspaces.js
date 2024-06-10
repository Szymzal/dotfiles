import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
import { range } from '../../utils.js';

const workspaces = 9;
const dispatch = (/** @type {number} */ arg) => Utils.execAsync(`hyprctl dispatch workspace ${arg}`)

export default () => Widget.Box({
  class_name: 'workspaces',
  children: range(workspaces || 9).map(i => Widget.Button({
    on_clicked: () => dispatch(i),
    child: Widget.Label({
      setup: label => {
        label.hook(Hyprland.active, self => {
          self.toggleClassName('active', Hyprland.active.workspace.id === i);
        });

        label.hook(Hyprland, self => {
          const workspace = Hyprland.getWorkspace(i);
          if (workspace !== undefined) {
            self.toggleClassName('occupied', workspace.windows > 0);
          }
        });
      },
      label: `${i}`,
      class_name: 'indicatior',
      vpack: 'center',
    }),
    expand: true,
  })),
});
