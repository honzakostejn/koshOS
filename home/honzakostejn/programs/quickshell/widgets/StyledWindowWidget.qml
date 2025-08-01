import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick

PanelWindow {
    required property string name
    property int barHeight
    property color backgroundColor

    WlrLayershell.namespace: `koshos-${name}`
    color: "transparent"

    anchors {
        top: true
        left: true
        bottom: true
        right: true
    }

    WrapperRectangle {
        anchors.fill: parent
        anchors.topMargin: barHeight
        color: backgroundColor
        radius: 10
    }
}