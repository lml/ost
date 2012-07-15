window._isDirty = false;

$('input, textarea, select').not('[type="submit"]').focus(function() {
   window._isDirty = true;
});

$('input[type="submit"]').click(function() {
   window._isDirty = false;
});

$(window).bind('beforeunload', function(){
   if (window._isDirty && (typeof(auto_signout) == undefined || !auto_signout)) {
     return "Unsaved changes will be lost. Are you sure you want to leave?";
   }
});
