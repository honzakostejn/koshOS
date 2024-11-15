import { Gtk } from "astal/gtk3"
import { IWorkspacesProps } from "./IWorkspacesProps";
import Dependencies from "../../../Dependencies";

export default function Workspaces(props: IWorkspacesProps) {

  // workspace numbers are bound to the keyboard
  const getWorkspaceNumber = (workspaceId: number): number => {
    const mod10 = workspaceId % 10;
    return mod10 === 0 ? 10 : mod10;
  }

  const getFocusedWorkspaceNumber = (): number => {
    return Dependencies.hyprland.get_focused_workspace().get_id();
  }

  const isFocusedWorkspaceOnCurrentMonitor = (): boolean => {
    return Dependencies.hyprland.get_focused_workspace().get_monitor().get_serial() === props.currentMonitor.hyprlandMonitor.get_serial();
  }

  return (
    <box
      className={"workspaces"}
      halign={Gtk.Align.START}
    >
      {props.currentMonitor.workspaces.map((workspace) =>
        <button
          className={
            props.currentMonitor.hyprlandMonitor.get_active_workspace().get_id() === workspace.get_id() ?
              "workspace focused" :
              "workspace"
          }
          halign={Gtk.Align.CENTER}
          setup={(self) => {
            self.hook(Dependencies.hyprland, 'notify::focused-workspace', () => {
              if (getFocusedWorkspaceNumber() === workspace.get_id() && isFocusedWorkspaceOnCurrentMonitor()) {
                self.toggleClassName("focused", true);
              }
              else {
                self.toggleClassName("focused", false);
                self.toggleClassName("has-clients", workspace.get_clients().length > 0);
              }
            })
          }}
          onClick={() => { }}
        >
          {getWorkspaceNumber(workspace.get_id())}
        </button>
      )}
    </box>
  );
}
