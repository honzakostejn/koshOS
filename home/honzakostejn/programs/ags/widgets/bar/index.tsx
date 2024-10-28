import { App, Astal, Gtk } from "astal/gtk3"
import { Variable } from "astal"
import { IBarProps } from "./IBarProps"
import Workspaces from "./workspaces"
import Battery from "./battery"
import { fetchBatteryStatus } from "./battery/battery"

const time = Variable("").poll(1000, "date")

export default function Bar(props: IBarProps) {
  return <window
    className="Bar"
    monitor={props.currentMonitor.gdkMonitorId}
    exclusivity={Astal.Exclusivity.EXCLUSIVE}
    anchor={Astal.WindowAnchor.TOP
      | Astal.WindowAnchor.LEFT
      | Astal.WindowAnchor.RIGHT}
    application={App}>
    <centerbox>
      <box
        halign={Gtk.Align.START}
      >
        <Workspaces
          {...props}
        />
      </box>
      <box
        halign={Gtk.Align.CENTER}
      >
      </box>
      <box
        halign={Gtk.Align.END}
      >
        <Battery
          {...fetchBatteryStatus()}
        />
        <button
          onClick={() => print("hello")}
          halign={Gtk.Align.END} >
          <label label={time()} />
        </button>
      </box>
    </centerbox>
  </window>
}
