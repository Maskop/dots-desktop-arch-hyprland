import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Services

PanelWindow {
    id: appLauncher

    property var opacity: 0.9

    // Borrowed from https://github.com/MannuVilasara/xenon-shell/blob/772cf6f40b1b73ca65e8b8b6075a9c221c0f61e1/Modules/Launcher/AppLauncher.qml
    readonly property string usageFilePath: Quickshell.env("HOME") + "/.cache/app-usage.json"
    property string query: ""
    property int currentIndex: 0
    property var usageCounts: ({
    })
    property var filteredApps: {
        var apps = DesktopEntries.applications.values;
        var q = query.toLowerCase().trim();
        var visible = apps.filter((app) => {
            return !app.noDisplay;
        });
        if (q === "") {
            visible.sort((a, b) => {
                var usageA = getUsage(a.id);
                var usageB = getUsage(b.id);
                if (usageA !== usageB)
                    return usageB - usageA;

                return a.name.toLowerCase().localeCompare(b.name.toLowerCase());
            });
            return visible;
        }
        var matches = visible.filter((app) => {
            return app.name.toLowerCase().includes(q);
        });
        matches.sort((a, b) => {
            var usageA = getUsage(a.id);
            var usageB = getUsage(b.id);
            if (usageA > 0 || usageB > 0) {
                if (usageA !== usageB)
                    return usageB - usageA;

            }
            var nameA = a.name.toLowerCase();
            var nameB = b.name.toLowerCase();
            if (nameA === q && nameB !== q)
                return -1;

            if (nameB === q && nameA !== q)
                return 1;

            var startA = nameA.startsWith(q);
            var startB = nameB.startsWith(q);
            if (startA && !startB)
                return -1;

            if (!startA && startB)
                return 1;

            return nameA.localeCompare(nameB);
        });
        return matches;
    }

    // Borrowed from https://github.com/MannuVilasara/xenon-shell/blob/772cf6f40b1b73ca65e8b8b6075a9c221c0f61e1/Modules/Launcher/AppLauncher.qml
    function loadUsage() {
        usageFileReader.running = true;
    }

    // Borrowed from https://github.com/MannuVilasara/xenon-shell/blob/772cf6f40b1b73ca65e8b8b6075a9c221c0f61e1/Modules/Launcher/AppLauncher.qml
    function saveUsage() {
        usageFileWriter.running = true;
    }

    // Borrowed from https://github.com/MannuVilasara/xenon-shell/blob/772cf6f40b1b73ca65e8b8b6075a9c221c0f61e1/Modules/Launcher/AppLauncher.qml
    function incrementUsage(appId) {
        var counts = usageCounts;
        counts[appId] = (counts[appId] || 0) + 1;
        usageCounts = counts;
        saveUsage();
    }

    // Borrowed from https://github.com/MannuVilasara/xenon-shell/blob/772cf6f40b1b73ca65e8b8b6075a9c221c0f61e1/Modules/Launcher/AppLauncher.qml
    function getUsage(appId) {
        return usageCounts[appId] || 0;
    }

    // Function to toggle popup on/off
    function toggle() {
        visible = !visible;
    }

    color: Design.transparent
    visible: false
    implicitWidth: 600
    implicitHeight: 600
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    Component.onCompleted: loadUsage()
    onVisibleChanged: {
        if (visible) {
            query = "";
            input.text = "";
            input.forceActiveFocus();
            currentIndex = 0;
            appList.positionViewAtBeginning();
        }
    }
    
    // Borrowed from https://github.com/MannuVilasara/xenon-shell/blob/772cf6f40b1b73ca65e8b8b6075a9c221c0f61e1/Modules/Launcher/AppLauncher.qml
    Process {
        id: usageFileReader

        command: ["cat", appLauncher.usageFilePath]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                appLauncher.usageCounts = JSON.parse(this.text);
            }
        }

    }

    // Borrowed from https://github.com/MannuVilasara/xenon-shell/blob/772cf6f40b1b73ca65e8b8b6075a9c221c0f61e1/Modules/Launcher/AppLauncher.qml
    Process {
        id: usageFileWriter

        command: ["sh", "-c", "cat > " + appLauncher.usageFilePath]
        running: false
        onStarted: {
            write(JSON.stringify(appLauncher.usageCounts));
        }
    }

    Rectangle {
        color: Design.colBg
        opacity: appLauncher.opacity
        radius: 8
        visible: true

        anchors {
            fill: parent
        }

        Rectangle {
            id: searchHeader

            height: Design.fontSize * 3
            color: "transparent"
            radius: 8
            border {
                color: Design.colBlue
            }

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: appLauncher.width * 1 / 30
            }

            TextField {
                id: input

                anchors {
                    fill: parent
                    margins: 4
                }

                Layout.fillWidth: true
                background: null
                color: "white"
                font.pixelSize: Design.fontSize
                font.weight: Font.Medium
                placeholderText: "Search applications..."
                placeholderTextColor: "grey"
                verticalAlignment: TextInput.AlignVCenter
                onTextChanged: {
                    appLauncher.query = text;
                    appLauncher.currentIndex = 0;
                    appList.positionViewAtBeginning();
                }
                Keys.onDownPressed: {
                    if (appLauncher.currentIndex < appLauncher.filteredApps.length - 1)
                        appLauncher.currentIndex++;

                    appList.positionViewAtIndex(appLauncher.currentIndex, ListView.Contain);
                }
                Keys.onUpPressed: {
                    if (appLauncher.currentIndex > 0)
                        appLauncher.currentIndex--;

                    appList.positionViewAtIndex(appLauncher.currentIndex, ListView.Contain);
                }
                Keys.onReturnPressed: {
                    if (appLauncher.filteredApps.length > 0) {
                        var app = appLauncher.filteredApps[appLauncher.currentIndex];
                        appLauncher.incrementUsage(app.id);
                        app.execute();
                        appLauncher.toggle()
                    }
                }

            }
        }

        Rectangle {
            color: Design.transparent

            anchors {
                top: searchHeader.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: appLauncher.width * 1 / 30
            }

            ScrollView {
                anchors.fill: parent

                ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                ListView {
                    id: appList

                    model: appLauncher.filteredApps
                    delegate: appDelegate
                    spacing: 3
                    clip: true

                    anchors {
                        fill: parent
                    }

                    Component {
                        id: appDelegate

                        Rectangle {
                            id: appRectangle

                            color: Design.colFg
                            implicitWidth: appList.width
                            implicitHeight: Design.fontSize * 3
                            radius: 5
                            opacity: appLauncher.opacity
                            border {
                                width: this.height * 1/10
                                color: appLauncher.currentIndex === index ? Design.colBlue : Design.transparent
                            }

                            RowLayout {
                                anchors {
                                    fill: parent
                                    margins: appRectangle.height / 4
                                }
                                spacing: appRectangle.height / 3

                                Image {
                                    Layout.preferredHeight: appRectangle.height * 3/5
                                    Layout.preferredWidth: appRectangle.height * 3/5
                                    fillMode: Image.PreserveAspectFit

                                    source: {
                                        if (modelData.icon.indexOf("/") !== -1)
                                            return "file://" + modelData.icon;

                                        return "image://icon/" + modelData.icon;
                                    }
                                }

                                Text {
                                    id: text

                                    text: modelData.name
                                    leftPadding: 5
                                    rightPadding: 5

                                    Layout.fillWidth: true

                                    font {
                                        family: Design.fontFamily
                                        pixelSize: Design.fontSize * 1.3
                                        bold: true
                                    }

                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    appLauncher.incrementUsage(modelData.id);
                                    modelData.execute();
                                    appLauncher.toggle();
                                }
                            }

                        }

                    }

                }
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: appLauncher.toggle()
    }

    IpcHandler {
        function toggle() {
            appLauncher.toggle();
        }

        target: "AppLauncher"
    }

}
