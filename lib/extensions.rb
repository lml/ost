# Copyright (c) 2011 Rice University.  All rights reserved.

require 'chronic'

class SecurityTransgression < StandardError; end

class AbstractMethodCalled < StandardError; end

class NotYetImplemented < StandardError; end

class IllegalArgument < StandardError; end

class IllegalState < StandardError; end

class IllegalOperation < StandardError; end

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

def add_test_classes(html_options, test_tokens)
  return if Rails.env.production?

  class_str    = html_options[:class] || ""
  class_tokens = class_str.split

  html_options[:test] ||= ""
  html_options[:test].split.each do |elem| 
    test_tokens << elem if !test_tokens.include?(elem)
  end

  test_tokens.each do |elem|
    class_tokens << elem if !class_tokens.include?(elem)
  end

  html_options[:class] = class_tokens.join(' ') if class_tokens.size > 0
  html_options.delete :test
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

module Store

  module ClassMethods
    # def store(store_attribute, options = {})
    #   serialize store_attribute, Hash
    #   store_accessor(store_attribute, options[:accessors]) if options.has_key? :accessors
    # end
    # 
    # def store_accessor(store_attribute, *keys)
    #   Array(keys).flatten.each do |key|
    #     define_method("#{key}=") do |value|
    #       send(store_attribute)[key] = value
    #       send("#{store_attribute}_will_change!")
    #     end
    #   
    #     define_method(key) do
    #       send(store_attribute)[key]
    #     end
    #   end
    # end
    
    def store_typed_accessor(store_attribute, datatype, *keys)
      # store_accessor(store_attribute, keys)
      
      
      Array(keys).flatten.each do |key|
        define_method("validate_datatype_of_#{key}") do
          true
        end

        before_validation "validate_datatype_of_#{key}"        
      end
    end
  end
end

# http://stackoverflow.com/a/2329394
module LocalActiveRecordExtensions
  def self.included(base)
    base.extend(ClassMethods)
  end
  # 
  # # add your instance methods here
  # def foo
  #    "foo"
  # end

  module ClassMethods
    # add your static(class) methods here
    
    def cast_from_string_with_error_checking(precast_value, datatype)
      cast_value = nil
      error_msg = nil
      
      if !precast_value.blank?
        case datatype
        when :integer
          cast_value = precast_value.to_i
          error_msg = "is not an integer" if cast_value.to_s != precast_value
        when :boolean
          case precast_value.downcase
          when "1", "true", "t", "yes"
            cast_value = true
          when "0", "false", "f", "no"
            cast_value = false
          else
            error_msg = 'is not a boolean'
          end
        end
      end

      return [cast_value, error_msg]
    end
    
    def store_typed_accessor(store_attribute, datatype, *keys)
      store_accessor(store_attribute, keys)
      
      Array(keys).flatten.each do |key|
        validation_method_name = "cast_#{key}_to_#{datatype.to_s}"
        
        define_method(validation_method_name) do
          precast_value = send("#{key}")
          return true if precast_value.class.name != "String"
          precast_value.strip! if !precast_value.nil?

          cast_value, error_msg = ActiveRecord::Base.cast_from_string_with_error_checking(precast_value, datatype)

          if !error_msg.nil?
            errors.add(key, error_msg)
            cast_value = precast_value
          end

          send("#{key}=", cast_value)
          errors.none?
        end
        
        before_validation validation_method_name    
      end # keys.each
    end
    
  end
  
end

# include the extension 
ActiveRecord::Base.send(:include, LocalActiveRecordExtensions)

###############################################################################
#
# From https://gist.github.com/1124645#file_string_ext.rb
#
class String
  def to_bool
    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end
#
###############################################################################


###############################################################################
#
# Wrap deliver and deliver! so if there's an exception it doesn't blow up
#
module Mail
  class Message
 
    alias_method :original_deliver, :deliver
    alias_method :original_deliver!, :deliver!

    def deliver(options={})
      begin
        original_deliver
      rescue StandardError => e
        raise if options[:safe_delivery_disabled]
        DeveloperNotifier.exception_email(e, nil, "An error occurred trying to deliver the following email: #{self.inspect}")
      end
    end

    def deliver!(options={})
      begin
        original_deliver!
      rescue StandardError => e
        raise if options[:safe_delivery_disabled]
        DeveloperNotifier.exception_email(e, nil, "An error occurred trying to deliver! the following email: #{self.inspect}")
      end
    end
    
  end
end