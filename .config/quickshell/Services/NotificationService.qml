pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root

  property list<QtObject> notifications
  property list<QtObject> notifActive
  property list<var> timer


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
    interval: 60000
    running: true
    repeat: true

    onTriggered: {
      console.log("All notifications cleared")
      root.dismissAll()
    }
  }

  Timer {
    id: popupTimer
    interval: 1000
    running: root.notifActive.length > 0
    repeat: true

    onTriggered: {
      for (let i = 0; i < root.notifActive.length; i++) {
        console.log("Date.now(): " + Date.now())
        console.log("root.timer[i].time: " + root.timer[i].time)
        console.log("root.notifActive[i]?.expireTimeout * 1000: " + root.notifActive[i]?.expireTimeout * 1000)
        let expireTimer = (root.notifActive[i]?.expireTimeout * 1000 > 1000) ? root.timer[i].time + root.notifActive[i]?.expireTimeout * 1000 : root.timer[i].time + 5000
        console.log("expireTimer: " + expireTimer)
        if (Date.now() > expireTimer) {
          console.log("deleting")
          root.notifActive.pop(i)
          root.timer.pop(i)
        }
      }
    }
  }
}
