function closeModal(modal) {
  $("#" + modal).modal('toggle');
}

function toggle(id) {
  $('#enable_' + id).toggle();
  $('#disable_' + id).toggle();
}

function toggle_status(id) {
  $('#verify_' + id).toggle();
  $('#unverify_' + id).toggle();
}

function toggle_visibility(id) {
  $('#highlight_' + id).toggle();
  $('#lowlight_' + id).toggle();
}
