require 'net/http'

# Thanks Ilya! http://www.igvita.com/2006/09/07/validating-url-in-ruby-on-rails/
# Original credits: http://blog.inquirylabs.com/2006/04/13/simple-uri-validation/
# HTTP Codes: http://www.ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTPResponse.html
# http://www.distancetohere.com/validating-url-in-ruby-on-rails-3/

class UrlExistenceValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    
    return if Rails.configuration.respond_to?(:enable_url_existence_validations) &&
              !Rails.configuration.enable_url_existence_validations
              
    config = {:message => "does not exist"}
    config.update(options)
    
    begin # check header response
      case Net::HTTP.get_response(URI.parse(value))
        when Net::HTTPSuccess then true
        else object.errors.add(attribute, config[:message]) and false
      end
    rescue # Recover on DNS failures..
      object.errors.add(attribute, config[:message]) and false
    end
  end
end

class UrlFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    config = { :message => "is not formatted correctly", 
               :regex => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix }
    config.update(options)
    
    object.errors.add(attribute, config[:message]) unless value =~ config[:regex]
    object.errors.empty?
  end
end
