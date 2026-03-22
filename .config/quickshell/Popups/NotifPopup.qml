import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Services

PanelWindow {
  id: root

  property int maxWidth: Quickshell.screens[0].width / Design.notifPopupWidthByMonitorWidthRatio


  screen: Quickshell.screens[0]
  color: Design.transparent
  visible: false
  implicitWidth: maxWidth
  implicitHeight: 600
  WlrLayershell.layer: WlrLayer.Overlay
  anchors {
    top: true
    right: true
  }
  
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
    model: NotificationService.notifActive

    spacing: 8

    Component {
      id: notifDelegate

      Rectangle {
        id: notifContainer

        function showImage() {
          if (modelData.appIcon === "") {
            return false
          } else {
            return true
          }
        }

        function totalContentHeight() {
          let total = 0

          // for (var rep in contentColumn.children) {
          //   console.log("totalContentHeight: " + total)
          //   console.log("item.contentHeight: " + rep.contentHeigt)
          //   total += rep.contentHeight
          // }
          //

          total = appNameT.height + summaryT.height + bodyT.height + root.maxWidth * 1/40

          return total
        }

        implicitWidth: root.maxWidth * 29/30
        implicitHeight: childrenRect.height

        color: Design.colBg
        radius: 8

        RowLayout {
          implicitWidth: root.maxWidth * 29/30
          implicitHeight: notifContainer.height

          Image {
            property int appIconSize: (notifContainer.showImage() ? Design.iconSize : 0)
            visible: notifContainer.showImage()
            Layout.preferredHeight: appIconSize
            Layout.preferredWidth: appIconSize
            Layout.leftMargin: 8

            source: {
              if (modelData.appIcon.indexOf("/") !== -1)
                return "file://" + modelData.appIcon;

              return "image://icon/" + modelData.appIcon;
            }
          }
          
          ColumnLayout {
            id: contentColumn

            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            Layout.topMargin: 8
            Layout.bottomMargin: 8

            spacing: 0

            Text {
              id: appNameT

              width: parent.width
              text: modelData.appName
              wrapMode: Text.WordWrap
              color: "white"

              leftPadding: 5
              rightPadding: 5

              // Layout.fillWidth: true

              font {
                family: Design.fontFamily
                pixelSize: Design.fontSize
                bold: false
              }
            }

            Text {
              id: summaryT

              width: parent.width
              text: modelData.summary
              wrapMode: Text.WordWrap
              color: "white"

              leftPadding: 5
              rightPadding: 5

              // Layout.fillWidth: true

              font {
                family: Design.fontFamily
                pixelSize: Design.fontSize
                bold: false
              }
            }

            Text {
              id: bodyT

              width: parent.width
              text: modelData.body
              wrapMode: Text.WordWrap
              color: "white"

              leftPadding: 5
              rightPadding: 5

              // Layout.fillWidth: true

              font {
                  family: Design.fontFamily
                  pixelSize: Design.fontSize
                  bold: false
              }
            }
          }
        }
      }
    }

    delegate: notifDelegate
  }
}
