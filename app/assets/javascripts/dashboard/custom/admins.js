$(function() {
  $('#lightSlider').lightSlider({
    gallery: true,
    item: 1,
    loop: false,
    slideMargin: 0,
    thumbItem: 9
  });
});

function toggleSeen(id, react) {
  $('.toggle-seen-link-'+id).addClass('text-info');
  if (react == 'like') {
    $('.toggle-seen-link-'+id).html('<i class="fa fa-eye"></i> I like this');   
  } else if (react == 'love') {
    $('.toggle-seen-link-'+id).html('<i class="fa fa-eye"></i> I love this');   
  } else if (react == 'joy') {
    $('.toggle-seen-link-'+id).html('<i class="fa fa-eye"></i> Hahaha');   
  } else if (react == 'wow') {
    $('.toggle-seen-link-'+id).html('<i class="fa fa-eye"></i> This is Amazing');   
  } else if (react == 'sad') {
    $('.toggle-seen-link-'+id).html('<i class="fa fa-eye"></i> I\'m sorry');   
  } else if (react == 'angry') {
    $('.toggle-seen-link-'+id).html('<i class="fa fa-eye"></i> NOT FUNNY!');   
  }
}

function animateEmoji() {
  $(this).addClass('animated rubberBand');
}

$(document).ready(function(){
  $(".animated-emoji").hover(function(){
    $(this).animate({ height: "2.8em" });
  }, function() {
    $(this).animate({ height: "1.8em" });
  });
});
