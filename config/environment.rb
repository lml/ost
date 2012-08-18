# Load the rails application
require File.expand_path('../application', __FILE__)

require 'extensions'
require 'url_validations'
require 'form_builder_extensions'
require 'ost_utilities'
require 'belongs_to_exercise'
require 'acts_as_numberable'
require 'enum'
require 'time_utils'

# STANDARD_DATETIME_FORMAT = "%m/%d/%Y %l:%M %p"
STANDARD_DATETIME_FORMAT = "%b %d, %Y %l:%M %p %Z"
# STANDARD_DATE_FORMAT = "%m/%d/%Y"
STANDARD_DATE_FORMAT = "%b %d, %Y"

SITE_NAME = "OpenStax Tutor"
COPYRIGHT_HOLDER = "Rice University"

HUMAN_FIELD_NAMES = {
  :"exercise.url" => "Exercise URL",
  :'esignature' => 'Electronic signature',
  :url => "URL"
}

# Initialize the rails application
Ost::Application.initialize!
