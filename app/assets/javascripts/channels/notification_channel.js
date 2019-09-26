$(function() {
  $('[data-channel-subscribe="notification"]').each(function(index, element) {
    var $element = $(element)
        notificationTemplate = $('[data-role="notification-template"]');

    App.cable.subscriptions.create(
      {
        channel: "NotificationChannel",
        room: 'general'
      },
      {
        received: function(data) {
          var content = notificationTemplate.children().clone(true, true);
          content.find('[data-role="notification-content"]').text(data.content);
          $element.prepend(content);
        }
      }
    );
  });
});
