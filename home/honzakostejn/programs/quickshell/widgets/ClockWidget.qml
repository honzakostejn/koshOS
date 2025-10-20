import qs.utils
import qs.widgets
import Quickshell.Widgets
import QtQuick

WrapperMouseArea {
  property color color: "white"
  implicitHeight: 20
  
  TextWidget {
    text: TimeUtil.time
    bold: true
    color: parent.color
  }
  
  onClicked: TimeUtil.copyUnixTime()
}