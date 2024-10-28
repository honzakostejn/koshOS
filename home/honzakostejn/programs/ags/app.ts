import { App, Gdk } from "astal/gtk3";

import Dependencies from "./Dependencies";
import AstalHyprland from "gi://AstalHyprland";

import style from "./style.scss";
import Bar from "./widgets/bar";
import { IMonitor } from "./IMonitor";


App.start({
  css: style,
  main() {
    loadMonitors().map((monitor) => {
      Bar({
        currentMonitor: monitor,
      });
    })
  },
})

function loadMonitors(): IMonitor[] {
  const monitors: IMonitor[] = [];

  const display = Gdk.Display.get_default();
  const screen = display?.get_default_screen();

  for (let i = 0; i < (display?.get_n_monitors() ?? 0); i++) {
    const gdkMonitor = display?.get_monitor(i);
    const hyprlandMonitor = Dependencies.hyprland.get_monitors().filter((hyprlandMonitor) => hyprlandMonitor.name === screen?.get_monitor_plug_name(i))[0];
    monitors.push({
      gdkMonitorId: i,
      gdkMonitor: gdkMonitor!,
      hyprlandMonitor: hyprlandMonitor,
      workspaces: loadMonitorWorkspaces(hyprlandMonitor),
    })
  }

  return monitors;
}

function loadMonitorWorkspaces(hyprlandMonitor: AstalHyprland.Monitor): AstalHyprland.Workspace[] {
  return Dependencies.hyprland.get_workspaces()
    // sort the workspaces by id asc
    .sort((a, b) => a.get_id() - b.get_id())
    // filter them 
    .filter((workspace) => workspace.get_monitor().get_serial() === hyprlandMonitor.get_serial())
}
