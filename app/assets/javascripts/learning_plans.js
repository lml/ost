$(document).ready(function() {
  $('.topic_info').on("dblclick", function(event){
    $(this).children(".topic_body:first").toggle();
    $(this).children(".topic_summary").toggle();
  }); 
  
  $('.topic_info').on("hover", function(event){
    $(this).children(".topic_buttons:first").toggle();
  }); 
});

