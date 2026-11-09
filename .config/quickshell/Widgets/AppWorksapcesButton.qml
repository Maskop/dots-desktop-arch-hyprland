import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Popups

Rectangle {
  id: root
  color: Design.colBg
  Layout.preferredWidth: this.height
  radius: Design.widgetRadius

  border {
    width: Design.widgetHeight / 16
    color: Design.transparent
  }

  property var parentWindow: ""

  Text {
    text: ""
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

  AppsWorkspaces {
    id: appsWorkspaces
    anchor.window: root.parentWindow
    anchor.item: root
    anchor.rect.y: Design.barHeight + Design.barMargins
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      // appsWorkspaces.toggle()
      // appsWorkspaces.setWidth()

      enabled: checkEnabled()
    }
  }

  property var enabled: true


  function checkEnabled() {
    if(enabled) {
      disableTouch.running = true
    } else {
      enableTouch.running = true
    }
    enabled = !enabled
    notifyState.running = true
    return !enabled
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

  Process {
    id: enableTouch
    running: false

    command: ["hyprctl", "eval", "hl.config({[\"input.touchdevice.enabled\"]=true})"]
    // stdout: StdioCollector {
    //   onStreamFinished: console.log(`input.touchdevice.enabled: ${this.text}`)
    // }
  }

  Process {
    id: disableTouch
    running: false

    command: ["hyprctl", "eval", "hl.config({[\"input.touchdevice.enabled\"]=false})"]
    // stdout: StdioCollector {
    //   onStreamFinished: console.log(`input.touchdevice.disabled: ${this.text}`)
    // }
  }

  Process {
    id: notifyState
    running: false

    command: ["notify-send", "input.touchdevice.enabled: " + enabled]
  }

}
