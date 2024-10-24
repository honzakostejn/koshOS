import { App, Gdk } from "astal/gtk3";

import AstalHyprland from 'gi://AstalHyprland';
import style from "./style.css";
import Bar from "./widgets/bar";
import { IMonitor } from "./IMonitor";

const Hyprland = AstalHyprland.get_default();

App.start({
  css: style,
  main() {
    loadMonitorProfile().map((monitor) => {
      Bar({ monitor: monitor });
    })
  },
})

function loadMonitorProfile(): IMonitor[] {
  const monitors: IMonitor[] = [];

  const display = Gdk.Display.get_default();
  const screen = display?.get_default_screen();

  for (let i = 0; i < (display?.get_n_monitors() ?? 0); i++) {
    const gdkMonitor = display?.get_monitor(i);
    const hyprlandMonitor = Hyprland.get_monitors().filter((hyprlandMonitor) => hyprlandMonitor.name === screen?.get_monitor_plug_name(i))[0];
    monitors.push({
      gdkMonitorId: i,
      gdkMonitor: gdkMonitor!,
      hyprlandMonitor: hyprlandMonitor,
    })
  }

  return monitors;
}
