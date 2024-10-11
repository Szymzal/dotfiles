import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Calendar from './calendar.js';
import PopupWindow from '../util/popupwindow.js';

export default () => PopupWindow({
  keymode: 'on-demand',
  anchor: ['top'],
  name: 'dashboard',
  child: Widget.Box({
    vertical: true,
    children: [
      Calendar(),
    ],
  })
});
