module WebsiteConfigurationsHelper

  def value_html_tag_for(configuration)
    case configuration.value_type
    when "boolean"
      hidden_field_tag(configuration.name, 'false') +
      check_box_tag(configuration.name, 'true', configuration.typed_value)
    when "text", "number"
      text_field_tag configuration.name, configuration.value
    end
  end

  def value_label_for(configuration)
    case configuration.value_type
    when "boolean"
      tf_to_yn(configuration.typed_value)
    when "text", "number"
      configuration.value
    end
  end

end
