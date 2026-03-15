pragma Singleton

import Quickshell
import Quickshell.Hyprland
import QtQuick

Singleton {
    id: root

    readonly property var workspaces: Hyprland.workspaces
    readonly property var monitors: Hyprland.monitors
    readonly property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace
    readonly property int activeWsId: focusedWorkspace?.id ?? 1

    function dispatch(request) {
        Hyprland.dispatch(request)
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            const eventName = event.name
            
            // Refresh workspace data when windows change - this makes occupancy reactive!
            if (["openwindow", "closewindow", "movewindow"].includes(eventName)) {
                Hyprland.refreshWorkspaces()
            }

            // Refresh monitors and workspaces when workspace focus changes
            if (["workspace", "moveworkspace", "focusedmon", "activespecial"].includes(eventName)) {
                Hyprland.refreshWorkspaces()
                Hyprland.refreshMonitors()
            }

            // Refresh monitors when monitor events occur
            if (eventName.includes("mon")) {
                Hyprland.refreshMonitors()
            }

            // Refresh workspaces for workspace events
            if (eventName.includes("workspace")) {
                Hyprland.refreshWorkspaces()
            }
        }
    }
}