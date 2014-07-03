
  class Lev::FormBuilder < ActionView::Helpers::FormBuilder

    def datetime_text_field(name, options={})
      mark_error_if_present(name, options)

      options[:time_zone] ||= "UTC"

      value = get_form_params_entry(name)
      options[:value] ||= value.nil? ? "" : value.in_time_zone(options[:time_zone]).strftime(STANDARD_DATETIME_FORMAT)

      new_classes = "datetime_field date_time_picker"
    
      options[:class] ||= options[:class].nil? ? 
        new_classes : 
        options[:class] + " " + new_classes

      text_field(name, options)
    end

    def time_zone_select(method, priority_zones = nil, options = {}, html_options = {})
      set_value_if_available(method, options)
      mark_error_if_present(method, options)
      super(method, priority_zones = nil, options = {}, html_options = {})
    end

  end
