$(function() {
  $('[data-channel-subscribe="room"]').each(function(index, element) {
    var $element = $(element)
        room_id = $element.data('room-id')
        messageTemplate = $('[data-role="message-template"]');
        invMessageTemplate = $('[data-role="inv-message-template"]');
    console.log($('body').data('current-user-id'))

    $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000)        

    App.cable.subscriptions.create(
      {
        channel: "RoomChannel",
        room: room_id
      },
      {
        received: function(data) {
          if (data.sender_id == $('body').data('current-user-id')) {
            var content = messageTemplate.children().clone(true, true);
          } else {
            var content = invMessageTemplate.children().clone(true, true);
          }
          content.find('[data-role="message-sender"]').text(data.sender_name);
          content.find('[data-role="user-avatar"]').attr('src', data.avatar_url);
          content.find('[data-role="message-text"]').text(data.message);
          content.find('[data-role="message-date"]').text(data.created_at);
          $element.append(content);
          $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000);

          var objDiv = document.getElementById("chat-area");
          objDiv.scrollTop = objDiv.scrollHeight;
        }
      }
    );
  });
});
