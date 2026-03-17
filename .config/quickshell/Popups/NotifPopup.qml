import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Services

PanelWindow {
  id: root

  property int maxWidth: Quickshell.screens[0].width / Design.notifPopupWidthByMonitorWidthRatio

  screen: Quickshell.screens[0]
  color: Design.transparent
  visible: true
  implicitWidth: maxWidth
  implicitHeight: 600
  WlrLayershell.layer: WlrLayer.Overlay
  anchors {
    top: true
    right: true
  }
  // WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
  
  Connections {
    target: NotificationService

    function onNotificationsChanged() {
      if (NotificationService.notifications.length > 0) {
        root.visible = true
      } else {
        root.visible = false
      }
      console.log(NotificationService.notifications.length)
    }
  }

  ListView {
    anchors.fill: parent
    model: NotificationService.notifications

    Component {
      id: notifDelegate

      Rectangle {
        id: notifContainer

        implicitWidth: root.maxWidth
        implicitHeight: 60

        color: Design.colBg

        RowLayout {
          implicitWidth: root.maxWidth
          implicitHeight: 60
          Image {
            Layout.preferredHeight: 40
            Layout.preferredWidth: 40
            source: {
              if (modelData.appIcon.indexOf("/") !== -1)
                return "file://" + modelData.appIcon;

              return "image://icon/" + modelData.appIcon;
            }
          }
          
          ColumnLayout {
            implicitWidth: root.maxWidth
            Text {
              text: modelData.appName
              color: "white"
            }

            Text {
              text: modelData.summary
              color: "white"
            }

            Text {
              text: modelData.body
              color: "white"
            }
          }
        }
      }
    }

    delegate: notifDelegate
  }
}
