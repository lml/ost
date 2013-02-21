# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

source 'https://rubygems.org'

gem 'rails', '3.2.8'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'therubyracer', '~> 0.10.1'
  gem 'bootstrap-sass', '~> 2.0.2'
end

gem 'jquery-rails', '~> 2.0.2'

gem 'capistrano', '~> 2.12.0'

gem 'devise', '~> 2.1.0'

gem "will_paginate", "~> 3.0.3"

gem 'mime-types', :require => 'mime/types'

gem 'squeel', '~> 1.0.5'

gem 'recaptcha', '~> 0.3.4', :require => 'recaptcha/rails'

gem "aws-ses", "~> 0.4.3", :require => 'aws/ses'

gem 'whenever', :require => false

gem 'chronic'
gem 'date_validator'

gem 'fastercsv'
gem 'csv_builder', '~>2.1.1'

gem 'yaml_db'

gem 'best_in_place'

gem 'acts-as-taggable-on', '~> 2.3.1'

gem 'sqlite3', '~> 1.3.6'

gem 'rack-mini-profiler'
gem 'newrelic_rpm'

gem 'mini_magick'
gem 'carrierwave'
gem "fog", "~> 1.3.1"

gem 'remotipart', '~> 1.0'

gem 'sketchily', '~> 1.1.0'

group :development, :test do
  gem 'debugger', '~> 1.1.4'
  gem 'faker', '~> 1.0.1'
  gem 'timecop', '~> 0.3.5'
  gem 'thin', '~> 1.4.1'
  gem 'quiet_assets', '~> 1.0.1'
  gem 'cheat'
  gem 'brakeman'
  gem 'rvm-capistrano'
end

group :development, :test do
  gem 'factory_girl_rails', '~> 4.0'
  gem 'rspec-rails'
  gem 'rspec-rerun'
  gem 'cucumber-rails', :require => false
  gem 'capybara-webkit'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'spork-rails'
end

group :development, :test do
  gem 'railroady'
end

group :production do
	gem 'mysql2', '~> 0.3.11'
	gem 'rack-ssl-enforcer', '~> 0.2.4'
end