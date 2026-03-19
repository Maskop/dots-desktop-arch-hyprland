import QtQuick
import Quickshell.Services.Notifications

NotificationServer {
  id: notifServer

  bodySupported: true
  imageSupported: false
  actionsSupported: false
  inlineReplySupported: false
  bodyMarkupSupported: false

  onNotification: (notification) => {
    notification.tracked = true

    NotificationService.notifications.push(notification)
    NotificationService.notifActive.push(notification)
    NotificationService.timer.push({"time" : Date.now(), "id" : notification.id})
  }
}
