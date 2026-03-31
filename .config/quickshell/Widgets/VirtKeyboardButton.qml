import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.VirtualKeyboard
import qs.Popups

Rectangle {
  id: virtKeyboardButton
  color: Design.colBg
  Layout.preferredWidth: this.height
  radius: Design.widgetRadius

  property var parentWindow: ""

  Text {
    text: "K"
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
      StatusSaver.wokrspacesView = !StatusSaver.wokrspacesView
    }
  }
}
