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
                
                var percentage = Math.round(UPower.displayDevice.percentage * 100)
                var bars = Math.round(percentage / 20) // 0-4 bars
                
                if (bars <= 0) return "[    }"       // 0-20%
                else if (bars == 1) return "[■   }"  // 20-40%
                else if (bars == 2) return "[■■  }"  // 40-60%
                else if (bars == 3) return "[■■■ }"  // 60-80%
                else return "[■■■■}"                 // 80-100%
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