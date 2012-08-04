$(document).ready(function() {
  $('.topic_info').on("dblclick", function(event){
    $(this).children(".topic_body:first").toggle();
    $(this).children(".topic_summary").toggle();
  }); 
  
  $('.topic_info').on("mouseenter", function(event){
    $(this).children(".topic_buttons:first").show();
  }); 
  $('.topic_info').on("mouseleave", function(event){
    $(this).children(".topic_buttons:first").hide();
  });
});

