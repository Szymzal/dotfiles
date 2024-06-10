import Widget from 'resource:///com/github/Aylur/ags/widget.js';
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

export default ({ format = '%d.%m.%y - %H:%M' } = {}) => Clock({
  format,
  hpack: 'center',
});
