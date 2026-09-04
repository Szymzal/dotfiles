class Workspaces : Gtk.Box {
  AstalHyprland.Hyprland hypr = AstalHyprland.get_default();
  public Workspaces() {
    Astal.widget_set_class_names(this, { "Workspaces" });
    hypr.notify["workspaces"].connect(sync);
    sync();
  }

  void sync() {
    foreach (var child in get_children())
      child.destroy();

    var currentMonitor = CurrentMonitorModel.getCurrentMonitor();
    var workspaces = hypr.workspaces;
    workspaces.sort((a, b) => {
      return a.id - b.id;
    });

    foreach (var ws in workspaces) {
      if (ws.monitor.model != currentMonitor.model) {
        continue;
      }

      // filter out special workspaces
      if (!(ws.id >= -99 && ws.id <= -2)) {
        add(button(ws));
      }
    }
  }

  Gtk.Button button(AstalHyprland.Workspace ws) {
    var btn = new Gtk.Button() {
      visible = true,
      label = "○",
    };

    hypr.notify["focused-workspace"].connect(() => {
      var focused = hypr.focused_workspace == ws;
      if (focused) {
        Astal.widget_set_class_names(btn, { "focused" });
      } else {
        Astal.widget_set_class_names(btn, {});
      }
    });

    btn.clicked.connect(ws.focus);
    return btn;
  }
}

class SysTray : Gtk.Box {
  HashTable<string, Gtk.Widget> items = new HashTable<string, Gtk.Widget> (str_hash, str_equal);
  AstalTray.Tray tray = AstalTray.get_default();

  public SysTray() {
    Astal.widget_set_class_names(this, { "SysTray" });
    tray.item_added.connect(add_item);
    tray.item_removed.connect(remove_item);
  }

  void add_item(string id) {
    if (items.contains(id))
      return;

    var item = tray.get_item(id);
    var btn = new Gtk.MenuButton() { use_popover = false, visible = true };
    var icon = new Astal.Icon() { visible = true };

    item.bind_property("tooltip-markup", btn, "tooltip-markup", BindingFlags.SYNC_CREATE);
    item.bind_property("gicon", icon, "gicon", BindingFlags.SYNC_CREATE);
    item.bind_property("menu-model", btn, "menu-model", BindingFlags.SYNC_CREATE);
    btn.insert_action_group("dbusmenu", item.action_group);
    item.notify["action-group"].connect(() => {
      btn.insert_action_group("dbusmenu", item.action_group);
    });

    btn.add(icon);
    add(btn);
    items.set(id, btn);
  }

  void remove_item(string id) {
    if (items.contains(id)) {
      items.remove(id);
    }
  }
}

class VolumeLabel : Gtk.Label {
  double _volume;

  public VolumeLabel() {
    this._volume = 1.0;
    this.label = "100%";
  }

  public double volume {
    get { return this._volume; }
    set {
      this._volume = value;
      var persentile = Math.round(this._volume * 100.0);
      this.label = @"$persentile%";
    }
  }
}

class Audio : Gtk.Box {
  Astal.Icon icon = new Astal.Icon();
  VolumeLabel label = new VolumeLabel();

  public Audio() {
    add(icon);
    add(label);
    Astal.widget_set_class_names(this, { "Audio" });
    Astal.widget_set_css(this, "min-width: 140px");

    var speaker = AstalWp.get_default().audio.default_speaker;
    speaker.bind_property("volume-icon", icon, "icon", BindingFlags.SYNC_CREATE);
    speaker.bind_property("volume", label, "volume", BindingFlags.SYNC_CREATE);
  }
}

class Time : Astal.Label {
  string format;
  AstalIO.Time interval;

  void sync() {
    label = new DateTime.now_local().format(format);
  }

  public Time(string format = "%H:%M:%S") {
    this.format = format;
    interval = AstalIO.Time.interval(1000, null);
    interval.now.connect(sync);
    destroy.connect(interval.cancel);
    Astal.widget_set_class_names(this, { "Time" });
  }
}

class Left : Gtk.Box {
  public Left(string monitorName) {
    Object(hexpand: true, halign: Gtk.Align.START);
    add(new Workspaces());
    // add(new FocusedClient());
  }
}

class Center : Gtk.Box {
  public Center() {
    // add(new Media());
  }
}

class Right : Gtk.Box {
  public Right() {
    Object(hexpand: true, halign: Gtk.Align.END);
    add(new SysTray());
    // add(new Wifi());
    add(new Audio());
    // add(new Battery());
    add(new Time());
  }
}

class Bar : Astal.Window {
  public Bar(Gdk.Monitor monitor) {
    Object(
           anchor: Astal.WindowAnchor.TOP
           | Astal.WindowAnchor.LEFT
           | Astal.WindowAnchor.RIGHT,
           exclusivity: Astal.Exclusivity.EXCLUSIVE,
           gdkmonitor: monitor
    );

    CurrentMonitorModel.updateMonitor(monitor);

    Astal.widget_set_class_names(this, { "Bar" });

    add(new Astal.CenterBox() {
      start_widget = new Left(name),
      center_widget = new Center(),
      end_widget = new Right(),
    });

    show_all();
  }
}

class CurrentMonitorModel {
  private static CurrentMonitorModel s_instance;
  private Gdk.Monitor m_monitor;

  public CurrentMonitorModel() {
  }

  public static void updateMonitor(Gdk.Monitor monitor) {
    getInstance().m_monitor = monitor;
  }

  public static CurrentMonitorModel getInstance() {
    if (CurrentMonitorModel.s_instance == null) {
      CurrentMonitorModel.s_instance = new CurrentMonitorModel();
    }

    return CurrentMonitorModel.s_instance;
  }

  public static Gdk.Monitor getCurrentMonitor() {
    return CurrentMonitorModel.getInstance().m_monitor;
  }
}
