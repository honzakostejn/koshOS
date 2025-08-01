import "root:widgets/"
import "root:services/"
import "root:utils/"
import Quickshell
import Quickshell.Wayland

Scope {
  id: backgroundModuleScope
  property int barHeight

  Variants {
    model: Quickshell.screens

    StyledWindowWidget {
      id: background

      required property ShellScreen modelData

      screen: modelData
      name: "background"
      WlrLayershell.exclusionMode: ExclusionMode.Ignore
      WlrLayershell.layer: WlrLayer.Background
      barHeight: backgroundModuleScope.barHeight
      
      // Get the active workspace for this monitor
      readonly property int activeWorkspaceId: {
          if (!HyprlandService.monitors || !HyprlandService.monitors.values) return 1
          
          var monitor = HyprlandService.monitors.values.find(m => m.name === modelData.name)
          return monitor?.activeWorkspace?.id ?? 1
      }
      
      // Calculate workspace index (1-10) for color selection
      readonly property int workspaceIndex: ((activeWorkspaceId - 1) % 10) + 1
      
      // Set background color based on active workspace using shared palette
      backgroundColor: ColorPalette.getWorkspaceColor(workspaceIndex)
    }
  }
}