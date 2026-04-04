import QtQuick
import QtQuick.Layouts
import qs.Services

Rectangle {
  id: root
  color: Design.colBg
  Layout.preferredWidth: this.height
  radius: Design.widgetRadius

  border {
    width: Design.widgetHeight / 16
    color: Design.transparent
  }

  Text {
    text: "󰣇"
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
      StatusSaver.appLauncherVisible = !StatusSaver.appLauncherVisible

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
