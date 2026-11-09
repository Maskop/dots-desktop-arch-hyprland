import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.Services

PanelWindow {
  id: root

  property int maxWidth: Quickshell.screens[0].width * Design.notifPopupWidthByMonitorWidthRatio


  screen: Quickshell.screens[0]
  color: Design.transparent
  visible: false
  implicitWidth: maxWidth
  implicitHeight: list.implicitHeight
  WlrLayershell.layer: WlrLayer.Overlay

  anchors {
    top: true
    right: true
  }

  margins {
    right: maxWidth/30
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
    id: list

    anchors {
      top: parent.top
      left: parent.left
    }
    implicitWidth: root.maxWidth
    implicitHeight: (childrenRect.height > Quickshell.screens[0].height / 2 ? Quickshell.screens[0].height / 2 : childrenRect.height)
    model: NotificationService.notifActive
    interactive: false

    spacing: 8

    Component {
      id: notifDelegate

      Rectangle {
        id: notifContainer

        function showIcon() {
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

        implicitWidth: root.maxWidth
        implicitHeight: childrenRect.height

        color: Design.colBg
        radius: 8


        RowLayout {
          anchors {
            left: parent.left
            right: parent.right
            top: parent.top
          }
          implicitHeight: notifContainer.height
          // implicitWidth: parent.width

            
          Image {
            property int appIconSize: (notifContainer.showIcon() ? Design.notifPopupIconSize : 0)
            Layout.preferredHeight: appIconSize
            Layout.preferredWidth: appIconSize
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            visible: notifContainer.showIcon()
            width: appIconSize
            height: appIconSize
            Layout.margins: 8

            source: {
              // console.log("this.width: " + this.width)
              // console.log("this.height: " + this.height)
              // console.log("maxWidth: " + root.maxWidth)
              if (modelData.appIcon.indexOf("/") !== -1)
                return "file://" + modelData.appIcon;

              return "image://icon/" + modelData.appIcon;
            }
          }

          ColumnLayout {
            id: contentColumn

            Layout.topMargin: 8
            Layout.bottomMargin: 8

            spacing: 0

            property int textWidth: {
              if (notifContainer.showIcon()) {
                return root.maxWidth - Design.notifPopupIconSize * 2 - Design.fontSize * 2
              } else {
                return root.maxWidth - Design.fontSize * 2
              }
            }

            Rectangle {
              color: "transparent"
              implicitWidth: childrenRect.width
              implicitHeight: childrenRect.height
              Text {
                id: appNameT

                width: contentColumn.textWidth
                text: NotificationService.shortenedMessage(modelData.appName)
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

                Component.onCompleted: {
                  if (this.text === "") {
                    this.visible = false
                    this.height = 0
                  }
                }
              }
            }
            
            Rectangle {
              color: "transparent"
              implicitWidth: childrenRect.width
              implicitHeight: childrenRect.height

              Text {
                id: summaryT

                width: contentColumn.textWidth
                text: NotificationService.shortenedMessage(modelData.summary)
                wrapMode: Text.Wrap
                color: "white"

                leftPadding: 5
                rightPadding: 5

                // Layout.fillWidth: true

                font {
                  family: Design.fontFamily
                  pixelSize: Design.fontSize
                  bold: false
                }

                Component.onCompleted: {
                  if (this.text === "") {
                    this.visible = false
                    this.height = 0
                  }
                }
              }
            }


            Rectangle {
              color: "transparent"
              implicitWidth: childrenRect.width
              implicitHeight: childrenRect.height

              Text {
                id: bodyT

                width: contentColumn.textWidth
                text: NotificationService.shortenedMessage(modelData.body)
                wrapMode: Text.Wrap
                color: "white"

                leftPadding: 5
                rightPadding: 5

                // Layout.fillWidth: true

                font {
                    family: Design.fontFamily
                    pixelSize: Design.fontSize
                    bold: false
                }

                Component.onCompleted: {
                  if (this.text === "") {
                    this.visible = false
                    this.height = 0
                  }
                }

              }
            }
          }

          Rectangle {
            implicitWidth: Design.fontSize * 1.2
            implicitHeight: Design.fontSize * 1.2
            color: Design.colMuted
            radius: this.implicitHeight

            Layout.alignment: Qt.AlignTop | Qt.AlignRight
            Layout.margins: 3

            Text {
              text: "󰖭"
              color: "white"
              anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
              }

              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter
              font {
                family: Design.fontFamily
                pixelSize: Design.fontSize
              }
            }

            MouseArea {
              anchors.fill: parent

              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              onClicked: {
                NotificationService.closePopup(modelData.id)
              }
            }
          }
        }
      }
    }

    delegate: notifDelegate
  }
}
