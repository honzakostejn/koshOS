import "root:widgets/"
import Quickshell
import Quickshell.Io
import QtQuick

Scope {
  Variants {
    model: Quickshell.screens;

    PanelWindow {
      id: bar

      required property ShellScreen modelData

      screen: modelData
      color: "black"
      implicitHeight: 30

      anchors {
        top: true
        left: true
        right: true
      }

      ClockWidget {
        id: clock

        color: "white"

        anchors {
          right: parent.right
          verticalCenter: parent.verticalCenter
          rightMargin: 10
        }
      }
    }
  }
}