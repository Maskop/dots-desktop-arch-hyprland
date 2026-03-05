pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

Singleton {
  id: root
  property var maxBrightness: 100000
  property var percentCalc: 100
  property var brightness: 100

  Process {
    id: getMaxBrightness
    running: true

    command: ["brightnessctl", "m"]

    stdout: StdioCollector {
      onStreamFinished: {
        root.maxBrightness  = parseInt(String(this.text))
        root.percentCalc = root.maxBrightness / 100
      }
    }
  }

  Process {
    id: getCurBrightness

    command: ["brightnessctl", "g"]

    stdout: StdioCollector {
      onStreamFinished: {
        root.brightness  = Math.floor(parseInt(String(this.text)) / root.percentCalc)
      }
    }
  }

  // Timer {
  //   interval: 500
  //   running: true
  //   repeat: true
  //
  //   onTriggered: {
  //     getCurBrightness.running = true
  //   }
  // }
}
