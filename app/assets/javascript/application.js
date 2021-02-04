//= require jquery3
//= require popper
//= require bootstrap-sprockets

// Loads all Semantic javascripts
//= require semantic-ui

// ドロップダウンを使用するためのコード
$(function(){
  $('.ui.dropdown').dropdown();
})

function previewFileWithId(id) {
   const target = this.event.target;
   const file = target.files[0];
   const reader  = new FileReader();
   reader.onloadend = function () {
   preview.src = reader.result;
   }
   if (file) {
   reader.readAsDataURL(file);
   } else {
   preview.src = '';
   }
}
