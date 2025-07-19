import "root:/widgets"
import Quickshell
import Quickshell.Wayland

Scope {
  Variants {
    model: Quickshell.screens

    StyledWindowWidget {
      id: background

      required property ShellScreen modelData

      screen: modelData
      name: "background"
      WlrLayershell.exclusionMode: ExclusionMode.Ignore
      WlrLayershell.layer: WlrLayer.Background
      color: "black"

      anchors {
        top: true
        left: true
        bottom: true
        right: true
      }
    }
  }
}