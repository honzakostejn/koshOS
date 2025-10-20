import qs.widgets
import qs.services
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Scope {
  id: barModuleScope
  property int barHeight

  Variants {
    model: Quickshell.screens;

    PanelWindow {
      id: bar

      required property ShellScreen modelData

      screen: modelData
      color: "black"
      
      implicitHeight: Math.max(
        workspacesLayout.implicitHeight, 
        battery.implicitHeight, 
        clock.implicitHeight
      )

      anchors {
        top: true
        left: true
        right: true
      }

      RowLayout {
        id: workspacesLayout
        spacing: 4
        anchors {
          left: parent.left
          verticalCenter: parent.verticalCenter
          leftMargin: 20
        }

        Repeater {
          model: HyprlandService.workspaces.values.filter(ws => ws.monitor?.name === bar.modelData.name)
          
          WorkspaceWidget {
            actualWorkspaceId: modelData.id
            monitorName: bar.modelData.name
            barHeight: barModuleScope.barHeight
          }
        }
      }

      BatteryWidget {
        id: battery

        anchors {
          right: clock.left
          verticalCenter: parent.verticalCenter
          rightMargin: 15
        }
      }

      ClockWidget {
        id: clock
        color: "white"

        anchors {
          right: parent.right
          verticalCenter: parent.verticalCenter
          rightMargin: 20
        }
      }
    }
  }
}