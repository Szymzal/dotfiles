import GLib from 'gi://GLib';

export default ({ format = '%H:%M:%S %B %e. %A', interval = 1000, ...rest }) => {
  const dateTime = Variable('', {
    poll: [interval, () => { return GLib.DateTime.new_now_local().format(format) || 'wrong format'; }]
  });

  return Widget.Label({
    class_name: 'clock',
    ...rest,
    label: dateTime.bind().as(value => value.toString()),
  })
};
