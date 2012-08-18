module TimeUtils
  def self.time_and_zone_strings_to_utc_time(origin_time_string, origin_zone_string)
    original_chronic_time_class = Chronic.time_class
    origin_zone = ActiveSupport::TimeZone.new(format_zone_string(origin_zone_string))
    raise "unable to parse origin zone string: (#{origin_zone_string})" if origin_zone.nil?
    origin_time = Chronic.parse(origin_time_string)
    raise "unable to parse origin time string: (#{origin_time_string})" if origin_time.nil?
    origin_zone.local_to_utc(origin_time)
  ensure
    Chronic.time_class = original_chronic_time_class
  end

  def self.time_to_time_in_zone_string(time, target_zone_string, time_format_string='%Y-%m-%d %H:%M:%S')
    target_zone = ActiveSupport::TimeZone.new(target_zone_string)
    raise "unable to parse target zone string: #{target_zone_string}" if target_zone.nil?
    target_zone.utc_to_local(time.utc).strftime(time_format_string)
  end
  
  def self.time_to_time_string(time, time_format_string='%Y-%m-%d %H:%M:%S')
    time.strftime(time_format_string)
  end
  
  def self.zone_to_string(zone)
    format_zone_string(zone.to_s)
  end
  
  def self.format_zone_string(str)
    if /^\(.*?\)\s+(?<rest>.*)$/ =~ str
      str = rest
    end
    str
  end
end
