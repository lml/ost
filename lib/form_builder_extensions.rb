class ActionView::Helpers::FormBuilder

  # STANDARD_DATETIME_FORMAT ||= "%m/%d/%Y %l:%M %p"
  STANDARD_DATETIME_FORMAT ||= "%b %d, %Y %l:%M %p"

  # Creates a text field set up for datetimes
  def datetime_text_field(name, options={})
    options[:time_zone] ||= "UTC"
    value = @object.send(name)
    options[:value] ||= value.nil? ? "" : value.in_time_zone(options[:time_zone]).strftime(STANDARD_DATETIME_FORMAT)
    
    new_classes = "datetime_field date_time_picker"
    
    options[:class] ||= options[:class].nil? ? 
    new_classes : 
    options[:class] + " " + new_classes

    text_field(name, options)
  end

  # Modify submit to add test tags automatically
  alias orig_submit submit  
  def submit(value=nil, options={})
    add_test_classes options, [:test, :clickable, :submit]
    orig_submit(value, options)
  end

  # Modify check_box to add test tags automatically
  alias orig_check_box check_box
  def check_box(method, options={}, checked_value="1", unchecked_value="0")
    add_test_classes options, [:test, :clickable]
    orig_check_box(method, options, checked_value, unchecked_value)
  end
end

module ActionView::Helpers::FormTagHelper 

  def datetime_text_field_tag(name, value=nil, options={})
    new_classes = "datetime_field date_time_picker"

    options[:class] ||= options[:class].nil? ? 
    new_classes : 
    options[:class] + " " + new_classes

    text_field_tag(name, value, options)
  end

  alias orig_submit_tag submit_tag
  def submit_tag(value="Save changes", options={})
    add_test_classes options, [:test, :clickable]
    orig_submit_tag(value, options)
  end

end
