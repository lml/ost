# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'net/http'

module Ost
  module Utilities

    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods

    end
    
    def merge_delimited_strings(delimeter, *strings)
      raw_merge = strings.collect{|string| "#{string}#{delimeter}"}
      merge = raw_merge.split(delimeter).reject{|t| t.blank?}.join(delimeter)
    end

    def full_class_name(object)
      case object.class.name
      when "Section"
        object.klass.course.name
      when "Student"
        object.cohort.klass.course.name
      when "Assignment"
        object.cohort.klass.course.name
      when "StudentExercise"
        object.student_assignment.student.section.klass.course.name
      when "RegistrationRequest"
        object.section.klass.course.name
      else
        raise IllegalArgument
      end
    end

    def url_responds?(url)
      begin # check header response
        case Net::HTTP.get_response(URI.parse(url))
          when Net::HTTPSuccess, Net::HTTPMovedPermanently, Net::HTTPMovedTemporarily then true
          else false
        end
      rescue # Recover on DNS failures..
        false
      end
    end
  
    def online?
      url_responds?("http://www.google.com")
    end
  
    def get_boolean_config(name)
      Rails.configuration.respond_to?(name) && Rails.configuration.send(name)
    end
    
  end
end
