pragma Singleton

import QtQuick

QtObject {
  id: root
  
  readonly property color primaryColor: "#dbcdfe"
  readonly property real hueStepShift: 0.15
  readonly property int numWorkspaces: 10
  
  // Get workspace color with progressive hue shifts
  function getWorkspaceColor(index) {
    index = (index - 1) % numWorkspaces + 1
    
    // Calculate hue shift for this workspace
    var hueShift = (index - 1) * hueStepShift
    var hue = (primaryColor.hslHue + hueShift) % 1.0
    
    var hsl = Qt.hsla(
      hue,
      primaryColor.hslSaturation, 
      primaryColor.hslLightness,
      1.0
    )
    
    return hsl
  }
}