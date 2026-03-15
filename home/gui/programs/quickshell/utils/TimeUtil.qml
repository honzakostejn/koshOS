
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root
  readonly property string time: {
    Qt.formatDateTime(clock.date, "yyyy-MM-dd | hh:mm:ss AP | t")
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
  
  function copyUnixTime() {
    var unixTime = Math.floor(Date.now() / 1000).toString()
    
    var copyProcess = Qt.createQmlObject(`
      import Quickshell.Io
      Process {
        command: ["wl-copy", "${unixTime}"]
        running: true
      }
    `, root)
  }
}