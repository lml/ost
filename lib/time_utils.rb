# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

module TimeUtils

  def self.timestr_and_zonestr_to_utc_time(origin_timestr, origin_zonestr)
    origin_time = Chronic.parse(origin_timestr)
    raise "unable to parse origin time string: (#{origin_timestr})" if origin_time.nil?
    self.time_and_zonestr_to_utc_time(origin_time, origin_zonestr)
  end

  def self.time_and_zonestr_to_utc_time(origin_time, origin_zonestr)
    origin_zone = TimeUtils.zonestr_to_zone(origin_zonestr)
    self.time_and_zone_to_utc_time(origin_time, origin_zone)    
  end
  
  def self.time_and_zone_to_utc_time(time, zone)
    zone.local_to_utc(time)
  end
  
  def self.time_and_zonestr_to_timestr_in_zone(time, target_zonestr, time_formatstr='%Y-%m-%d %H:%M')
    target_zone = ActiveSupport::TimeZone.new(target_zonestr)
    raise "unable to parse target zone string: #{target_zonestr}" if target_zone.nil?
    target_zone.utc_to_local(time.utc).strftime(time_formatstr)
  end
  
  def self.time_to_timestr(time, time_formatstr='%Y-%m-%d %H:%M')
    timestr = time.strftime(time_formatstr)
    raise "invalid time format string (#{time_formatstr})" \
      if timestr.blank?
    timestr
  end

  def self.zonestr_to_zone(zonestr)
    zone = ActiveSupport::TimeZone.new(format_zonestr(zonestr));
    raise "unable to parse origin zone string: (#{zonestr})" \
      if zone.nil?
    zone
  end
  
  def self.zone_to_zonestr(zone)
    self.format_zonestr(zone.to_s)
  end
  
  def self.format_zonestr(zonestr)
    if /^\(.*?\)\s+(?<rest>.*)$/ =~ zonestr
      zonestr = rest
    end
    zonestr
  end
  
end