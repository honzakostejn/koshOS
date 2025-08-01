pragma Singleton

import QtQuick

QtObject {
  id: root
  
  readonly property color primaryColor: "#dbcdfe"
  readonly property int numWorkspaces: 10
  
  readonly property var triadicHues: [
    primaryColor.hslHue,
    (primaryColor.hslHue + 0.333) % 1.0,
    (primaryColor.hslHue + 0.667) % 1.0 
  ]
  
  // get workspace color using triadic groups with variations
  function getWorkspaceColor(index) {
    index = (index - 1) % numWorkspaces + 1
    
    var triadicGroup = (index - 1) % 3
    var baseHue = triadicHues[triadicGroup]
    
    // add small variation within each triadic group
    var groupIndex = Math.floor((index - 1) / 3)
    var hueVariation = groupIndex * 0.05
    
    var hue = (baseHue + hueVariation) % 1.0
    
    var hsl = Qt.hsla(
      hue,
      primaryColor.hslSaturation, 
      primaryColor.hslLightness,
      1.0
    )
    
    return hsl
  }
}