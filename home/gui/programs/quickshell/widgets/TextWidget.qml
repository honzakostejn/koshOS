import QtQuick

Text {
    // Default font settings for all text in QuickShell
    font.family: "JetBrains Mono"
    
    // Allow customization while keeping defaults
    property bool bold: false
    property int size: 16
    
    font.bold: bold
    font.pixelSize: size
}