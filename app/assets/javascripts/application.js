// Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
// License version 3 or later.  See the COPYRIGHT file for details.

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
//= require jquery.remotipart
//= require jquery-ui
//= require jquery.purr
//= require best_in_place
//= require fullcalendar
//= require codecogs_editor
//= require raphael-min
//= require_tree .
//= require on_the_spot
// Loads Bootstrap javascripts for accordions; note loading everything breaks other existing CSS/JS
//= require bootstrap-transition
//= require bootstrap-collapse
//= require bootstrap-dropdown


function open_specified_dialog(name, is_modal, height, width, title, body) {
  $('#' + name + '_dialog_errors').html('');

  $("#" + name + "_dialog_body").html(body);
  
  $("#" + name + "_dialog").dialog({ 
    autoOpen: false, 
    modal: is_modal, 
    height: height, 
    width: width,
    title: title,
    position: 'center',
    open: function () {
      $(document).trigger('after_dialog_open');
    }
  });
  
  refresh_buttons();

  $("#" + name + "_dialog").dialog('open').closeOnClickOutside();
  $("#" + name + "_dialog").scrollTop(0);   
}

function open_message_dialog(is_modal, height, width, title, body) {
  open_specified_dialog('message', is_modal, height, width, title, body);
}

function get_os_color(color) {
  return $('#os_' + color).css('background-color');
}

function sum(array) {
  var sum = 0;
  for (var ii = 0; ii < array.length; ii++) {
    sum += array[ii];
  }
  return sum;
}

// Open all non-local links in a new tab/window
//  http://stackoverflow.com/questions/4086988/how-do-i-make-link-to-open-external-urls-in-a-new-window
$(document).ready(function() {
  $("a").on("click", function() {
    link_host = this.href.split("/")[2];
    document_host = document.location.href.split("/")[2];

    if (link_host != document_host) {
      window.open(this.href);
      return false;
    }
  });
});