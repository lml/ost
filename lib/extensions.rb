# Copyright (c) 2011 Rice University.  All rights reserved.

require 'chronic'

class SecurityTransgression < StandardError; end

class AbstractMethodCalled < StandardError; end

class NotYetImplemented < StandardError; end

class IllegalArgument < StandardError; end

class IllegalState < StandardError; end

def to_bool(string)
  return true if string== true || string =~ (/(true|t|yes|y|1)$/i)
  return false if string== false || string.nil? || string =~ (/(false|f|no|n|0)$/i)
  raise ArgumentError.new("invalid value for Boolean: \"#{string}\"")
end

def days_to_seconds(days)
  days * 24 * 60 * 60
end

def seconds_to_days(seconds)
  seconds / (24 * 60 * 60)
end

def utc_offset_string
  hour_diff = Time.zone_offset(Time.now.zone)/3600
  (hour_diff < 0 ? "-" : "+") + "%02d" % hour_diff.abs + "00"
end

def utc_from_time_and_zone(time_string, time_zone_string)
  original_zone = Time.zone
  Time.zone = time_zone_string
  Chronic.time_class = Time.zone
  Chronic.parse(time_string).utc.tap do
    Time.zone = original_zone
  end
end

module ActiveRecord
  class Base
    def better_becomes(klass)
      became = self.becomes(klass)
      became.instance_variable_set("@errors", @errors)
      became    
    end  
    
    # If you're in the console and say myModel.method('id').call(), you get back
    # the id attribute of the instance you have.  But for some reason that gives
    # an 'undefined method' error when run in a view.  So this method just checks
    # to see if the thing being called is an attribute, and if so calls a method
    # to read that attribute; otherwise, calls it as a method.
    def call(method_or_attribute)
      self.attribute_present?(method_or_attribute) ? 
        self.read_attribute(method_or_attribute) :
        self.method(method_or_attribute).call()
    end
    
    def self.find_in_specified_order(ids)
      items = find(ids)

      order_hash = {}
      ids.each_with_index {|id, index| order_hash[id.to_i]=index}

      items.sort_by!{|item| order_hash[item.id]}
    end
    
    def sudo_enabled?
      WebsiteConfiguration.get_value(:sudo_enabled)
    end
  end
end