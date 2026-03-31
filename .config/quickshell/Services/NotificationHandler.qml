import QtQuick
import Quickshell.Services.Notifications

NotificationServer {
  id: notifServer

  bodySupported: true
  imageSupported: Design.notifPopupSupport
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
