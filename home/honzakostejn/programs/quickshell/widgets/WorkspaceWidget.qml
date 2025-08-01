import "root:services/"
import "root:utils/"
import Quickshell.Widgets
import QtQuick

WrapperMouseArea {
    property int actualWorkspaceId
    property color activeColor: "white"
    property color inactiveColor: "gray"
    property string monitorName: ""
    property int barHeight
    
    
    // Check if this workspace is the active workspace on this specific monitor
    readonly property bool isActiveOnThisMonitor: {
        if (!HyprlandService.monitors || !HyprlandService.monitors.values) return false
        
        var monitor = HyprlandService.monitors.values.find(m => m.name === monitorName)
        return monitor?.activeWorkspace?.id === actualWorkspaceId
    }
    
    // Check if this workspace has any windows (reactive via service)
    readonly property bool isOccupied: {
        if (!HyprlandService.workspaces || !HyprlandService.workspaces.values) return false
        
        var workspace = HyprlandService.workspaces.values.find(workspace => workspace.id === actualWorkspaceId)
        return workspace?.lastIpcObject?.windows > 0
    }
    
    // Get pastel color for this workspace index using shared palette
    readonly property color workspacePastelColor: ColorPalette.getWorkspaceColor(actualWorkspaceId)
    
    Rectangle {
        implicitWidth: barHeight * 2
        implicitHeight: barHeight
        radius: 4
        bottomLeftRadius: 0
        bottomRightRadius: 0
        color: isActiveOnThisMonitor ? workspacePastelColor : (isOccupied ? workspacePastelColor : inactiveColor)

        TextWidget {
            readonly property color activeTextColor: {
                return isActiveOnThisMonitor ?
                    Qt.hsla(
                        workspacePastelColor.hslHue,
                        workspacePastelColor.hslSaturation, 
                        0.4,
                        1.0
                    ) : (
                        isOccupied ?
                            Qt.hsla(
                                workspacePastelColor.hslHue,
                                workspacePastelColor.hslSaturation,
                                0.8,
                                1.0
                            ) : "white"
                    )
            }

            anchors.centerIn: parent
            text: (actualWorkspaceId % 10).toString()
            color: activeTextColor
            size: 12
            bold: true
        }
    }

    onClicked: HyprlandService.dispatch(`workspace ${actualWorkspaceId}`)
}