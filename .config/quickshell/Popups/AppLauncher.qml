// AppLauncher.qml
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
// import QtQuick.Layout
import qs.Services

Scope {
  PanelWindow {
    id: appLauncher
    color: Design.transparent

    visible: false

    implicitWidth: 400
    implicitHeight: 600

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    // Function to toggle popup on/off
    function toggle() {
      visible = !visible
    }

    Rectangle {
      anchors {
        fill: parent
      }
      color: Design.colBg
      opacity: 0.8
      radius: 8
      visible: true

      ListView {
        anchors {
          fill: parent
          margins: appLauncher.width * 1/30
        }
      }
    }

    Process {
      command: ["ls", "/usr/share/applications/"]
    }


    Shortcut {
        sequence: "Escape"
        onActivated: appLauncher.toggle()
    }

    IpcHandler {
      function toggle() {
        appLauncher.toggle()
      }

      target: "AppLauncher"
    }
  }
}
