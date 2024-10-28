import { Gtk } from "astal/gtk3"
import { IWorkspacesProps } from "./IWorkspacesProps";
import Dependencies from "../../../Dependencies";

export default function Workspaces(props: IWorkspacesProps) {

  // workspace numbers are bound to the keyboard
  const getWorkspaceNumber = (workspaceId: number): number => {
    const mod10 = workspaceId % 10;
    return mod10 === 0 ? 10 : mod10;
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
              "workspace active" :
              "workspace"
          }
          halign={Gtk.Align.CENTER}
          setup={(self) => {
            self.hook(Dependencies.hyprland, 'notify::focused-workspace', () => {
              const focusedWorkspace = Dependencies.hyprland.get_focused_workspace();

              // make sure the focused workspace is on the current monitor before toggling class
              if (focusedWorkspace && focusedWorkspace.get_monitor().get_serial() === props.currentMonitor.hyprlandMonitor.get_serial()) {
                self.toggleClassName("active", focusedWorkspace.get_id() === workspace.get_id());
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
