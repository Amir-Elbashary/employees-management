$(function() {
  $('#lightSlider').lightSlider({
      gallery: true,
      item: 1,
      loop: false,
      slideMargin: 0,
      thumbItem: 9
  });
});

function toggleSeen(id) {
  if($('.toggle-seen-link-'+id).hasClass('text-info')) {
    $('.toggle-seen-link-'+id).removeClass('text-info');
    $('.toggle-seen-link-'+id).html('<i class="fa fa-eye"></i> I\'m not going to react');
  } else {
    $('.toggle-seen-link-'+id).addClass('text-info');
    $('.toggle-seen-link-'+id).html('<i class="fa fa-eye"></i> I feel xx');
  }
}
