pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.Services

Scope {
  id: root
  property ShellScreen focusedScreen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) 
  property HyprlandMonitor focusedMonitor: Hyprland.focusedMonitor
  property real spacing: 8
  property real columns: 5
  property real rows: 2
  property real contentWidth: (focusedMonitor?.width / focusedMonitor?.scale) / 1.5
  property real tileWidth: (contentWidth - spacing * (columns + 1)) / columns
  property real tileHeight: tileWidth * 2 / 3

  
  PanelWindow {
    id: overviewWindow
    screen: root.focusedScreen
    color: "transparent"

    implicitWidth: root.contentWidth
    implicitHeight: root.tileHeight * root.rows + root.spacing * (root.rows + 1)
    visible: StatusSaver.wokrspacesView

    // mask: Region { item: Rectangle {anchors.fill: parent} }
    
    Rectangle { 
      id: overviewWindowRect
      color: Design.colBg
      anchors.fill: parent
      radius: 8 
      GridLayout {
        id: overviewLayout
        anchors.fill: parent
        anchors.margins: root.spacing

        columns: root.columns
        rows: root.rows
        rowSpacing: 8
        columnSpacing: 8

        Repeater {
          model: root.rows * root.columns
          WorkspaceView {
            parentWindow: overviewWindowRect
            implicitWidth: root.tileWidth 
            implicitHeight: root.tileHeight

            DropArea {
              anchors.fill: parent
              onDropped: function(drag) { 
                var address = drag.source.address
                Hyprland.dispatch(
                  "movetoworkspacesilent " +
                  (index + 1) +
                  ", address:" +
                  address
                )
                Hyprland.refreshWorkspaces()
                Hyprland.refreshMonitors()
                Hyprland.refreshToplevels()
              }
            }
          }
        }
      }
    }
  }
}
