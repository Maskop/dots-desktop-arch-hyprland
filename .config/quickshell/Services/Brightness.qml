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
  property var brightnessIcon: "󰃠"

  Process {
    id: getMaxBrightness
    running: Design.checkBrightness

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
        root.brightness = Math.floor(parseInt(String(this.text)) / root.percentCalc)
        if (root.brightness <= 30) {
          root.brightnessIcon = "󰃞"
        } else if (root.brightness <= 60) {
          root.brightnessIcon = "󰃟"
        } else {
          root.brightnessIcon = "󰃠"
        }
      }
    }
  }

  Timer {
    interval: Design.checkBrightnessInterval
    running: Design.checkBrightness
    repeat: true

    onTriggered: {
      getCurBrightness.running = true
    }
  }
}
