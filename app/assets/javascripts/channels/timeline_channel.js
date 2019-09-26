$(function() {
  $('[data-channel-subscribe="timeline"]').each(function(index, element) {
    var $element = $(element)
        statusTemplate = $('[data-role="status-template"]');
        newsTemplate = $('[data-role="news-template"]');
        showOffTemplate = $('[data-role="show-off-template"]');

    App.cable.subscriptions.create(
      {
        channel: "TimelineChannel",
        room: 'public'
      },
      {
        received: function(data) {
          if (data.kind == 'status') {
            var statusContent = statusTemplate.children().clone(true, true);

            if ((data.owner_id == $('body').data('current-user-id')) && (data.creation == 'manual')) {
              statusContent.find('[data-role="status-close-btn"]').attr('href', '/admin/timelines/' + data.id);
            } else {
              statusContent.find('[data-role="status-close-btn"]').attr('class', 'd-none');
            }

            statusContent.find('[data-role="status-owner-name"]').text(data.owner_name);
            statusContent.find('[data-role="status-content"]').html(data.content);
            statusContent.find('[data-role="status-owner-avatar"]').attr('src', data.avatar_url);
            statusContent.find('[data-role="status-created-since"]').text(data.created_since + ' ago');
            $element.prepend(statusContent);
          } else if (data.kind == 'news') {
            var newsContent = newsTemplate.children().clone(true, true);

            if ((data.owner_id == $('body').data('current-user-id')) && (data.creation == 'manual')) {
              newsContent.find('[data-role="news-close-btn"]').attr('href', '/admin/timelines/' + data.id);
            } else {
              newsContent.find('[data-role="news-close-btn"]').attr('class', 'd-none');
            }

            newsContent.find('[data-role="news-owner-name"]').text(data.owner_name);
            newsContent.find('[data-role="news-content"]').html(data.content);
            newsContent.find('[data-role="news-image"]').attr('src', data.image);
            newsContent.find('[data-role="news-owner-avatar"]').attr('src', data.avatar_url);
            newsContent.find('[data-role="news-created-since"]').text(data.created_since + ' ago');
            $element.prepend(newsContent);
          } else if (data.kind == 'show_off') {
            var showOffContent = showOffTemplate.children().clone(true, true);
                imagesDiv = showOffContent.find('[data-role="show-off-images"]'); 

            if ((data.owner_id == $('body').data('current-user-id')) && (data.creation == 'manual')) {
              showOffContent.find('[data-role="show-off-close-btn"]').attr('href', '/admin/timelines/' + data.id);
            } else {
              showOffContent.find('[data-role="show-off-close-btn"]').attr('class', 'd-none');
            }

            showOffContent.find('[data-role="show-off-owner-name"]').text(data.owner_name);
            showOffContent.find('[data-role="show-off-content"]').html(data.content);

            data.images.forEach(function (item, index) {
              imagesDiv.append('<div class="col-lg-3 col-md-6 m-b-20"><img src="' + item.url + '" class="img-responsive radius"></div>')
            });

            showOffContent.find('[data-role="show-off-owner-avatar"]').attr('src', data.avatar_url);
            showOffContent.find('[data-role="show-off-created-since"]').text(data.created_since + ' ago');
            $element.prepend(showOffContent);
          }
        }
      }
    );
  });
});
