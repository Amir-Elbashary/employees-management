// wysihtml init
$(function() {
  $('.textarea_editor').wysihtml5();   
});

// tinymce init
// $(document).ready(function () {
//   if($(".html-editor").length > 0){
//     tinymce.init({
//       selector: "textarea.html-editor",
//       theme: "modern",
//       height:300,
//       plugins: [
//         "advlist autolink link image lists charmap print preview hr anchor pagebreak code",
//         "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
//         "save table contextmenu directionality emoticons template paste textcolor"
//       ],
//       toolbar: "insertfile undo redo | searchreplace code | formatselect | bold italic underline strikethrough | alignleft aligncenter alignright alignjustify | blockquote hr charmap | removeformat subscript superscript | bullist numlist outdent indent | link image | print preview media fullpage | fontsizeselect forecolor backcolor | emoticons",
//       // 'styleselect' icon should be added to toolbar
//       // style_formats: [
//       // 	{title: 'Bold text', inline: 'b'},
//       // 	{title: 'Red text', inline: 'span', styles: {color: '#ff0000'}},
//       // 	{title: 'Red header', block: 'h1', styles: {color: '#ff0000'}},
//       // 	{title: 'Example 1', inline: 'span', classes: 'example1'},
//       // 	{title: 'Example 2', inline: 'span', classes: 'example2'},
//       // 	{title: 'Table styles'},
//       // 	{title: 'Table row 1', selector: 'tr', classes: 'tablerow1'}
//       // ]
//     });
//   }
// });
