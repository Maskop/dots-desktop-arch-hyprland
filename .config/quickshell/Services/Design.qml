pragma Singleton

import Quickshell
import QtQuick 


Singleton {
  // color pallete
  property color colBg: "#1a1b26"
  property color colFg: "#a9b1d6"
  property color colMuted: "#444b6a"
  property color colCyan: "#0db9d7"
  property color colBlue: "#7aa2f7"
  property color colYellow: "#e0af68"
  property color transparent: "#00000000"

  // time format
  property string timeFormat: "hh:mm:ss"

  // font settings
  property string fontFamily: "JetBrainsMono Nerd Font"
  property int fontSize: 14

  // bar settings
  property int barAdd: 4
  property int widgetsSub: 4
  property int barHeight: fontSize * 2 + barAdd
  property int widgetHeight: barHeight - widgetsSub
  property int barMargins: (barHeight - widgetHeight) / 2
  property int widgetRadius: fontSize * (2/3)

  // launcher settings
  property real launcherOpacity: 0.9

  // notif server settings
  property bool notifImageSupport: false

  // notif popup settings
  property real notifPopupWidthByMonitorWidthRatio: 1/7
  property real notifPopupOpacity: 0.9
  property int notifPopupTimeout: 5000                           /* time in ms */
  property int notifPopupIconSize: 40
  property int notifPopupMaxCharacters: 300

  // notif center settings
  property real notifCenterWidthByMonitorWidthRatio: 1/4
  property real notifCenterWidthByMonitorHeightRatio: 1/2
  property int notifCenterRadius: 20
  property int notifCenterMargins: 10

  // widget toggles
  property bool clockWidgetVisible: true
  property bool appWorkspacesButtonVisible: true
  property bool statusWidgetVisible: true
  property bool virtKeyboardButtonVisible: true
  property bool workspacesVisible: true
  property bool workspaceMoverButtonVisible: true

  // check for changes settings
  property bool checkBrightness: true
  property int checkBrightnessInterval: 500
  property bool checkBattery: true
  property int checkbatteryInterval: 5000  
}
