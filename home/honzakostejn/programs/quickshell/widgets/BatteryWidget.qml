import Quickshell
import Quickshell.Services.UPower
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "root:widgets/"

WrapperItem {
    implicitHeight: 20
    
    RowLayout {
        spacing: 4
        
        // Battery icon (ASCII battery representation)
        TextWidget {
            id: batteryIcon
            text: {
                if (!UPower.displayDevice.isLaptopBattery) return "[--]"
                
                var batterySegments = 4
                // extra one is for empty state (no bar displayed)
                var barStep = 100 / (batterySegments + 1)
                var percentage = Math.round(UPower.displayDevice.percentage * 100)

                var bars = Math.round(percentage / barStep)
                // use only the state property for charging detection
                var isCharging = UPower.displayDevice.state === 1

                var fillChar = isCharging ? "+" : "■"
                
                // when charging, show at least 1 bar
                var displayBars = isCharging ? Math.max(1, bars) : bars
                // build battery array dynamically
                var battery = new Array(batterySegments).fill(" ")
                for (var i = 0; i < displayBars; i++) {
                    battery[i] = fillChar
                }
                
                return "[" + battery.join("") + "}"
            }
            color: {
                if (!UPower.displayDevice.isLaptopBattery) return "white"
                
                var percentage = Math.round(UPower.displayDevice.percentage * 100)
                if (percentage <= 20) return "red"
                else if (percentage <= 50) return "orange"
                else return "green"
            }
        }
        
        // Battery percentage text
        TextWidget {
            id: batteryText
            bold: true
            text: {
                if (!UPower.displayDevice.isLaptopBattery) {
                    return "No Battery"
                }
                return Math.round(UPower.displayDevice.percentage * 100) + "%"
            }
            color: {
                if (!UPower.displayDevice.isLaptopBattery) return "white"
                
                var percentage = Math.round(UPower.displayDevice.percentage * 100)
                if (percentage <= 20) return "red"
                else if (percentage <= 50) return "orange"
                else return "green"
            }
        }
    }
}