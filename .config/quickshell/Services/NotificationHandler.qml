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
  }
}
