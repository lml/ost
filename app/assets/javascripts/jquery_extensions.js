jQuery.fn.exists = function(){return jQuery(this).length>0;}

jQuery.fn.pageTimeout = function(options) {
   var default_options = {
      timeTilDialog: 29*60*1000,
      timeAfterDialog: 1*60*1000,
	}
    
   var config = $.extend(default_options, options);
   var preDialogTimeout, postDialogTimeout;
   
   auto_signout = false;
    
    var resetTimeouts = function() {
       clearTimeout(preDialogTimeout);
       clearTimeout(postDialogTimeout);
       
       preDialogTimeout = setTimeout(openTimeoutDialog, config.timeTilDialog);
    }
    
    var openTimeoutDialog = function() {
       postDialogTimeout = setTimeout(signout, config.timeAfterDialog);
       
       timeoutDialog = "<div id='timeout_dialog'><p>You are about to be signed out due to inactivity!</p></div>";
       
       $(timeoutDialog).dialog({
          buttons: {
             "I\'m still here!": function() {
                resetTimeouts();
                $(this).dialog("close");
             }
          },
          modal:true,
          title:"Attention!"
       });
       
       $("#timeout_dialog").bind('dialogclose', function(event, ui) {
           resetTimeouts();
       });
    }
    
    var signout = function() {
       auto_signout = true;
       $(document).trigger('beforeTimeout');
       $('#signout_link').click();
    }
    
    return jQuery(this).each(function() {
       resetTimeouts();
       $(document).bind('click', resetTimeouts);
    });
 }
