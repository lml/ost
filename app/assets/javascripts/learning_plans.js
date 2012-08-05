$(document).ready(function() {

  $('#topics').on("dblclick", '.topic_info', function(event){
    $(this).children(".topic_body:first").toggle();
    $(this).children(".topic_summary").toggle();
  }); 
  
  $('#topics').on("mouseenter", '.topic_info', function(event){
    $(this).children(".topic_buttons:first").show();
  });

  $('#topics').on("mouseleave", '.topic_info', function(event){
    $(this).children(".topic_buttons:first").hide();
  });
  
  //////////////
  
  $('#lp_items').on("dblclick", '.lp_item_info', function(event){
    $(this).children(".lp_item_body:first").toggle();
    $(this).children(".lp_item_summary").toggle();
  }); 
  
  $('#lp_items').on("mouseenter", '.lp_item_info', function(event){
    $(this).children(".lp_item_buttons:first").show();
  });

  $('#lp_items').on("mouseleave", '.lp_item_info', function(event){
    $(this).children(".lp_item_buttons:first").hide();
  });
  

  $('#lp_items').on('click', '.calendar_button', function(event) {
    event.preventDefault();
    var id = $(this).attr('data-assignment-id');
    var event = $('#calendar').fullCalendar( 'clientEvents', 'assignment_' + id )[0];
    $('#calendar').fullCalendar('gotoDate', event.start);
  });
  
});

