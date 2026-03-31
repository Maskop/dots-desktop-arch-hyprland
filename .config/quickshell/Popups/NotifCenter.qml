import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Services

PanelWindow {
  id: root

  property int maxWidth: Quickshell.screens[0].width * Design.notifCenterWidthByMonitorWidthRatio

  implicitWidth: maxWidth

}
