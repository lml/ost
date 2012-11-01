// Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
// License version 3 or later.  See the COPYRIGHT file for details.

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
