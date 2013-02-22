// Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
// License version 3 or later.  See the COPYRIGHT file for details.

// Useful debugging code:
//  window.alert("Your message here");

function refresh_buttons() {
   $('input:submit').button();
   $('.button').button();
   $(".show_button").button({icons: {primary: "ui-icon-search"}, text: false });
   $(".edit_button").button({icons: {primary: "ui-icon-pencil"}, text: false });
   $(".trash_button").button({icons: {primary: "ui-icon-trash"}, text: false });
   $(".calendar_button").button({icons: {primary: "ui-icon-calendar"}, text: false });
   refresh_datetime_pickers();
}

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(elem_to_append_to, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(elem_to_append_to).append(content.replace(regexp, new_id));
}

// Use this method when you want to do an AJAX "DELETE", which 
// rails/jquery likes to achieve as a POST with an extra field
// passed in.  See "handleMethod(link)" in rails.js for the 
// prototype for this method.
function delete_as_post(action, serializedArray) {
   serializedArray.push({name: "_method", value: "delete"}); 
   return $.post(action, serializedArray);
}

function delete_and_go(url) {
   var $form = $("<form>")
       .attr("method", "delete")
       .attr("action", url);
   $form.appendTo("body");
   $form.submit();              
}

function put_as_post(action, serializedArray) {
   serializedArray.push({name: "_method", value: "put"}); 
   return $.post(action, serializedArray);
}

// Adds a 'notice' message to the page
function add_notice(message) {
   add_attention_message(message, "notice");
}

// Adds an 'alert' message to the page
function add_alert(message) {
   add_attention_message(message, "alert");
}

// Adds an attention message to the page of the given type
function add_attention_message(message, type) {
   $('#attention').append('<div id="' + type + '" class="' + type + '">' + message + '</div>');
}

(function($) {
    $.extend({
        getGo: function(url, params) {
            document.location = url + '?' + $.param(params);
        },
        deleteGo: function(url) {
           var $form = $("<form>")
               .attr("method", "delete")
               .attr("action", url);
           $form.appendTo("body");
           $form.submit();           
        }, 
        postGo: function(url, params) {
            var $form = $("<form>")
                .attr("method", "post")
                .attr("action", url);
            $.each(params, function(name, value) {
                $("<input type='hidden'>")
                    .attr("name", name)
                    .attr("value", value)
                    .appendTo($form);
            });
            $form.appendTo("body");
            $form.submit();
        },
        putGo: function(url, params) {
              params.push({name: "_method", value: "put"}); 
              var $form = $("<form>")
                  .attr("method", "post")
                  .attr("action", url);
              $.each(params, function(index, param) {
                  $("<input type='hidden'/>")
                      .attr("name", param['name'])
                      .attr("value", param['value'])
                      .appendTo($form);
              });
              $form.appendTo("body");
              $form.submit();
          }
    });
});

function show_none_row_if_needed(table_id) {
  if ($('#' + table_id + ' tr').length == 2) {
    $('#' + table_id + '_none_row').show();
  }
}

function refresh_datetime_pickers() {
  $(".date_time_picker").each( function(index) {
    $(this).datetimepicker({
      numberOfMonths: parseInt($(this).attr("number_of_months")) || 3,
      timeFormat:     $(this).attr("time_format")                || 'h:mm TT', // this only takes effect after refresh
      dateFormat:     $(this).attr("date_format")                || 'M d, yy', // this only takes effect after refresh
      stepMinute:     parseInt($(this).attr("step_minute"))      || 1, 
      ampm:           true, 
      hour:           parseInt($(this).attr("hour"))             || 9,
      minute:         parseInt($(this).attr("minute"))           || 0
    });
  });
}

Number.prototype.formatMoney = function(c, d, t) {
  // http://stackoverflow.com/questions/149055/how-can-i-format-numbers-as-money-in-javascript
  var n = this, c = isNaN(c = Math.abs(c)) ? 2 : c, d = d == undefined ? "," : d, t = t == undefined ? "." : t, s = n < 0 ? "-" : "", i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", j = (j = i.length) > 3 ? j % 3 : 0;
  return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
};

