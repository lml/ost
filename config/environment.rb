# Load the rails application
require File.expand_path('../application', __FILE__)

require 'extensions'
require 'url_validations'
require 'form_builder_extensions'
require 'ost_utilities'
require 'belongs_to_exercise'
require 'acts_as_numberable'

STANDARD_DATETIME_FORMAT = "%m/%d/%Y %l:%M %p"
STANDARD_DATE_FORMAT = "%m/%d/%Y"

SITE_NAME = "OpenStax Tutor"
COPYRIGHT_HOLDER = "Rice University"

HUMAN_FIELD_NAMES = {
  :"exercise.url" => "Exercise URL",
  :'esignature' => 'Electronic signature',
  :url => "URL"
}

# Initialize the rails application
Ost::Application.initialize!
