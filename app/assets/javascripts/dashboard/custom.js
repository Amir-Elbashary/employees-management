$(function() {
  $(".select2").select2();
});

$(function() {
  $('.textarea_editor').wysihtml5();   
});

// $(function() {
//   $('.sortable').railsSortable({
//     axis: false,
//     opacity: 0.5,
//     revert: 240,
//     scroll: true,
//     scrollSensitivity: 20,
//     scrollSpeed: 40,
//     tolerance: "pointer",
//     cursor: "move",
//   });
// });

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

$(function() {
  $('#myTable, #admins_table, #employees_table').DataTable();
  var table = $('#example').DataTable({
    "columnDefs": [{
      "visible": false,
      "targets": 2
    }],
    "order": [
      [2, 'asc']
    ],
    "displayLength": 25,
    "drawCallback": function(settings) {
      var api = this.api();
      var rows = api.rows({
        page: 'current'
      }).nodes();
      var last = null;
      api.column(2, {
          page: 'current'
      }).data().each(function(group, i) {
        if (last !== group) {
          $(rows).eq(i).before('<tr class="group"><td colspan="5">' + group + '</td></tr>');
          last = group;
        }
      });
    }
  });
  // Order by the grouping
  $('#example tbody').on('click', 'tr.group', function() {
    var currentOrder = table.order()[0];
    if (currentOrder[0] === 2 && currentOrder[1] === 'asc') {
      table.order([2, 'desc']).draw();
    } else {
      table.order([2, 'asc']).draw();
    }
  });
});
