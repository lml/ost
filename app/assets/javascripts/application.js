// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.purr
//= require best_in_place
//= require fullcalendar
//= require_tree .


function open_message_dialog(is_modal, height, width, title, body) {
  $("#message_dialog_body").html(body);
  
  $("#message_dialog").dialog({ 
    autoOpen: false, 
    modal: is_modal, 
    height: height, 
    width: width,
    title: title,
    position: 'center'
  });

  $("#message_dialog").dialog('open');
  $("#message_dialog").scrollTop(0);  
}

function get_os_color(color) {
  
  return $('#os_' + color).css('background-color');
}
