class WebsiteConfiguration < ActiveRecord::Base

  # Format: {"name" => [value, "value_type"], "name" => [value, "value_type"]}
  @@defaults = {
                  "in_maintenance" => ["false", "boolean"],
                  "sudo_enabled" => ["false", "boolean"],
                  "consent_reask_weeks" => ["5", "number"]
               }

  validates_uniqueness_of :name
  validates_presence_of :value_type

  attr_accessible :value

  def self.defaults
    @@defaults
  end

  def self.get_value(name)
    name = name.to_s
    configuration = WebsiteConfiguration.find_by_name(name)
    
    # Check if we need to lazily instantiate this parameter
    if configuration.nil?
      default = @@defaults[name]
      raise IllegalArgument if default.nil?
      configuration = WebsiteConfiguration.new
      configuration.name = name
      configuration.value = default[0]
      configuration.value_type = default[1]
      configuration.save!
    end
    
    case configuration.value_type
    when "boolean"
      !configuration.value.blank? && configuration.value != "f" && configuration.value != "0" && configuration.value != "false"
    when "text"
      configuration.value
    end
  end
  
  def self.load
    return if @@defaults.size == WebsiteConfiguration.count
    @@defaults.keys.each{|key| get_value(key)}
  end
  
  def typed_value
    case value_type
    when "boolean"
      value != "false"
      #!configuration.value.blank? && configuration.value != "f" && configuration.value != "0"
    when "text"
      value
    when "number"
      Float value
    end    
  end

  #############################################################################
  # Access control methods
  #############################################################################

  def self.can_be_read_by?(user)
    !user.is_anonymous? && user.is_administrator?
  end
  
  def self.can_be_updated_by?(user)
    !user.is_anonymous? && user.is_administrator?
  end
end
