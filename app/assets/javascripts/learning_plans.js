// Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
// License version 3 or later.  See the COPYRIGHT file for details.

$(document).ready(function() {
  
  $('#lp_items').on("dblclick", '.lp_item_info', function(event){
    $(this).children(".lp_item_body:first").toggle();
    $(this).find(".lp_item_summary .hide_when_expanded").toggle();
  }); 
  
  $('#lp_items').on("mouseenter", '.lp_item_info', function(event){
    $(this).children(".lp_item_buttons:first").show();
  });

  $('#lp_items').on("mouseleave", '.lp_item_info', function(event){
    $(this).children(".lp_item_buttons:first").hide();
  });
  
  $('#lp_items').on('click', '.calendar_button', function(event) {
    event.preventDefault();
    var id = $(this).attr('data-assignment-plan-id');
    var event = $('#calendar').fullCalendar( 'clientEvents', 'assignment_plan_' + id )[0];
    $('#calendar').fullCalendar('gotoDate', event.start);
    
    $('html, body').animate({
      scrollTop: $("#calendar").offset().top - 20
    }, 200);
  });
  
});

