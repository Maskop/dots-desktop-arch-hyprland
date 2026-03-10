import QtQuick
import QtQuick.Layouts
import qs.Services

Rectangle {
  id: statusWidget

  color: Design.colBg
  radius: Design.widgetRadius

  property int curWidth: 0

  function calculateWidth() {
    curWidth = 10 + row.children.length * 5 + splitter0.implicitWidth
    for (let i = 0; i < row.children.length; i++) {
      let rect = row.children[i]
      curWidth += rect.implicitWidth
    }
  }

  implicitWidth: curWidth 
  
  Component.onCompleted: {
    statusWidget.calculateWidth()
  }

  RowLayout {
    id: row

    anchors.fill: parent
    spacing: 5

    Rectangle {
      id: volume

      color: Design.transparent
      // color: Design.colFg
      implicitWidth: 30
      implicitHeight: parent.height
      Layout.alignment: Qt.AlignLeft
      Layout.leftMargin: Design.fontSize / 3
    }

    Rectangle {
      id: splitter0

      color: Design.colMuted
      Layout.alignment: Qt.AlignCenter

      implicitWidth: Design.fontSize * 1/5
      implicitHeight: parent.height * 3/4
      radius: this.width
    }

    Rectangle {
      id: brightness

      color: Design.transparent
      // color: Design.colFg
      implicitWidth: textWidth.width
      implicitHeight: parent.height
      Layout.alignment: Qt.AlignCenter

      Text {
        id: textWidth
        anchors {
          verticalCenter: parent.verticalCenter
          horizontalCenter: parent.horizontalCenter
        }
        visible: true
        text: Brightness.brightness + "% " + Brightness.brightnessIcon
        color: "white"
        font {
          family: Design.fontFamily
          pixelSize: Design.fontSize
        }
      }
    }

    Rectangle {
      id: splitter1

      color: Design.colMuted
      Layout.alignment: Qt.AlignCenter

      implicitWidth: Design.fontSize * 1/5
      implicitHeight: parent.height * 3/4
      radius: this.width
    }


    Rectangle {
      id: battery

      color: Design.transparent
      // color: Design.colFg
      implicitWidth: percentageIcon.contentWidth
      implicitHeight: parent.height
      Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
      Layout.rightMargin: Design.fontSize / 3

      Text {
        id: percentageIcon
        anchors {
          verticalCenter: parent.verticalCenter
          // horizontalCenter: parent.horizontalCenter
        }
        visible: true
        text: BatteryStats.batteryIcon
        color: BatteryStats.color
        font {
          family: Design.fontFamily
          pixelSize: Design.fontSize * 2.5
          bold: true
        }

        Text {
          id: percentageText
          anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: Design.fontSize * 0.5
          }
          visible: true
          text: BatteryStats.batteryPercentage
          color: "white"
          horizontalAlignment: Text.AlignHCenter
          font {
            family: Design.fontFamily
            pixelSize: Design.fontSize * 0.8
          }
        }
      }
    }
  }
}
