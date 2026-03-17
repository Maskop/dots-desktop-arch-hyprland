pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root

  property list<QtObject> notifications: ({})


  onNotificationsChanged: {
    console.log("\t\t\tNotificationsService\t\t\t")
    console.log("------------------------------------------------------------")
    console.log(notifications)
    for (let i = 0; i < notifications.length; i++) {
      var notif = notifications[i]
      if (notif == null) {
        notifications.pop(i)
        break
      }
      
      console.log("id: " + notif.id)
      console.log("appName: " + notif.appName)
      console.log("summary: " + notif.summary)
      console.log("body: " + notif.body)
      console.log("appIcon: " + notif.appIcon)
    }
  }

  function dismiss(id) {
    for (let i = 0; i < notifications.length; i++) {
      if (notifications[i].id == id) {
        notifications.pop(i).dismiss()
        break;
      }
    }
  }

  function dismissAll() {
    for (let i = 0; i < notifications.length; i++) {
      notifications.pop(i)?.dismiss()
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true

    onTriggered: {
      console.log("All notifications cleared")
      root.dismissAll()
    }
  }
}
