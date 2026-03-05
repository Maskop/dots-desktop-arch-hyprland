// AppLauncher.qml
import Quickshell
// import QtQuick.Io
import QtQuick
// import QtQuick.Layout
import qs.Services

PopupWindow {
  id: appLauncher
  color: Design.transparent

  visible: true

  implicitWidth: 200
  implicitHeight: 600

  anchor {
    window: ShellScreen
  }

  // Function to toggle popup on/off
  function toggle() {
    visible = !visible
  }

  Rectangle {
    anchors {
      fill: parent
    }
    color: Design.colBg
    radius: 8
    visible: true
  }
}
