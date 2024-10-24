import { Gdk } from "astal/gtk3";
import AstalHyprland from "gi://AstalHyprland?version=0.1";

export interface IMonitor {
  gdkMonitorId: number,
  gdkMonitor: Gdk.Monitor,
  hyprlandMonitor: AstalHyprland.Monitor,
}