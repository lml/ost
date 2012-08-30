# Copyright (c) 2011 Rice University.  All rights reserved.

module JqueryHelper
  def display_flash(scroll = true)
    # Override scroll in the case where there's nothing to see
    scroll = scroll && !flash[:alert].blank? && !flash[:notice].blank?
    
    output = '$("#attention").html("' +
             escape_javascript(render :partial => 'shared/attention') +
             '");'
    output << ' scrollTo(0,0);' if scroll
    flash.discard
    output.html_safe
  end

  def unless_errors(error_html_id='attention', &block)
    unless_errors_in(nil, error_html_id, &block)
  end

  def unless_errors_in(object=nil, error_html_id='attention', &block)
    @errors = object.nil? ? [] : object.errors
    
    if !@errors.empty? || !alert.blank?
      "$('##{error_html_id}').html(\"#{ ej(render :partial => 'shared/attention') } \");".html_safe
    else
      ("$('##{error_html_id}').html('');" + capture(&block)).html_safe
    end
  end

  def hide_none(row_id = "")
    ('$("#' + row_id + 'none_row").hide();').html_safe
  end

  def show_none(row_id = "")
    ('$("#' + row_id + 'none_row").show();').html_safe
  end

  # This function is used to make MathJax re-process the page after we update the contents
  # using javascript. Unless it is called after each update, math won't display properly.
  def reload_mathjax(element_id="")
    ('MathJax.Hub.Queue(["Typeset", MathJax.Hub, document.getElementById("' +
            element_id + '")]);').html_safe
  end
  
  def message_dialog(title=nil, options={}, &block)
    specified_dialog("message", title, options, &block)
  end
  
  def specified_dialog(name=nil, title=nil, options={}, &block)
    @name ||= name
    @title ||= title
    @options = options
    @body = capture(&block)
    render :template => 'shared/specified_dialog'
  end
end
