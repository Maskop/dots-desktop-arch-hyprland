import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Services

Rectangle {
  id: root

  radius: Design.notifCenterRadius
  color: Design.colBg
  
  ColumnLayout {
    anchors.fill: parent    


    Text {
      Layout.alignment: Qt.AlignTop
      Layout.margins: Design.notifCenterMargins
      Layout.preferredHeight: Design.fontSize
      Layout.fillWidth: true
      color: Design.colFg
      text: "NOTIFICATIONS"

      horizontalAlignment: Text.AlignHCenter
      font {
        pixelSize: Design.fontSize * 1.2
        family: Design.fontFamily
        bold: true
      }
    }

    Rectangle {
      id: listContainer

      visible: true
      color: "transparent"
      Layout.alignment: Qt.AlignTop
      Layout.margins: Design.notifCenterMargins * 1.5
      Layout.fillWidth: true
      Layout.fillHeight: true

      ListView {
        id: list

        anchors.fill: parent
        model: NotificationService.notifications
        interactive: true
        clip: true

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

            implicitWidth: list.width
            implicitHeight: childrenRect.height

            color: Design.colFg
            radius: 8


            RowLayout {
              anchors {
                left: parent.left
                right: parent.right
                top: parent.top
              }
              implicitHeight: notifContainer.height
                
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
                    return list.width - Design.notifPopupIconSize * 2 - Design.fontSize * 2
                  } else {
                    return list.width - Design.fontSize * 2
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
                    color: "black"

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
                    color: "black"

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
                    color: "black"

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
                  anchors.fill: parent
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
                    NotificationService.dismiss(modelData.id)
                  }
                }
              }
            }
          }
        }

        onModelChanged: {
          if (NotificationService.notifications.length === 0) {
            listContainer.visible = false
            noNotifsBox.visible = true
          } else {
            listContainer.visible = true
            noNotifsBox.visible = false
          }
        }

        delegate: notifDelegate
      }
    }

    Rectangle {
      id: noNotifsBox

      visible: false
      color: Design.colFg
      radius: 8
      Layout.alignment: Qt.AlignTop
      Layout.margins: Design.notifCenterMargins * 1.5
      Layout.fillWidth: true
      Layout.preferredHeight: Design.fontSize * 1.2 * 6

      property int curWidth: this.width
      
      Text {
        color: "black"

        anchors.fill: parent
        text: "THERE ARE NO NEW NOTIFICATIONS"
        width: noNotifsBox.curWidth

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.Wrap
        font {
          pixelSize: Design.fontSize * 1.2
          family: Design.fontFamily
          bold: true
        }
      }

      // Component.onCompleted: {
      //   console.log("noNotifsBox width: " + this.width)
      //   console.log("noNotifsBox height: " + this.height)
      //   console.log("noNotifsBox visible: " + this.visible)
      // }
    }
  }
}
