import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Services
import qs.Popups

PanelWindow {
  id: root

  property int notifBoxWidth: Quickshell.screens[0].width * Design.notifCenterWidthByMonitorWidthRatio
  property int notifBoxHeight: Quickshell.screens[0].height * Design.notifCenterWidthByMonitorHeightRatio
  property int peekWidth: 15
  property bool notifBoxOpen: false

  implicitWidth: Screen.width
  implicitHeight: Screen.height
  color: "transparent"
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.exclusiveZone: -1
  mask: notifBoxMask

  anchors {
    top: true
    bottom: true
    right: true
  }

  Region {
    id: notifBoxMask

    regions: [
      Region {
        x: notifBox.x
        y: notifBox.y
        width: root.notifBoxWidth
        height: root.notifBoxHeight
      }
    ]
  }

  NotifCenter {
    id: notifBox

    x: (root.notifBoxOpen || notifHandler.hovered) ? root.width - root.notifBoxWidth - Design.notifCenterMargins: root.width - root.peekWidth
    // x: root.notifBoxOpen ? root.width - root.notifBoxWidth - Design.notifCenterMargins: root.width - root.peekWidth
    width: root.notifBoxWidth
    height: root.notifBoxHeight

    anchors {
      bottom: parent.bottom
      bottomMargin: Design.notifCenterMargins
    }

    HoverHandler {
      id: notifHandler
    }

    TapHandler {
      acceptedDevices: PointerDevice.Stylus | PointerDevice.TouchScreen
      onTapped: root.notifBoxOpen = !root.notifBoxOpen
    }    

    Behavior on x {
      NumberAnimation {
        duration: 400
        easing.type: Easing.OutBack
        easing.overshoot: 0.8
      }
    }
  }
}
