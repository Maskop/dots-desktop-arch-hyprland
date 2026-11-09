import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.Services
// import qs.VirtualKeyboard

Rectangle {
  id: root
  color: Design.colBg
  Layout.preferredWidth: this.height
  radius: Design.widgetRadius

  property bool kbdOpen: false 

  border {
    width: Design.widgetHeight / 16
    color: Design.transparent
  }

  Process {
    id: runKbd

    running: false

    command: ["wvkbd-mobintl", "-L", "300"]
  }

  Process {
    id: killKbd

    running: false

    command: ["killall", "wvkbd-mobintl"]
  }

  Text {
    text: root.kbdOpen ? "󰌏" : "󰌌"
    color: Design.colFg
    anchors {
      horizontalCenter: parent.horizontalCenter
      verticalCenter: parent.verticalCenter
    }

    font {
      family: Design.fontFamily
      pixelSize: Design.fontSize
    }
  }
  
  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      if (!root.kbdOpen) {
        runKbd.running = true
        root.kbdOpen = true
      } else {
        killKbd.running = true
        root.kbdOpen = false
      }
    }
  }

  HoverHandler {
    id: mouse
    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    cursorShape: Qt.PointingHandCursor

    onHoveredChanged: {
      if (hovered) {
        root.border.color = Design.colBlue
      } else {
        root.border.color = Design.transparent
      }
    }
  }
}
