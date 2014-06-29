# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

source 'https://rubygems.org'

gem 'rails', '3.2.17'

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

gem 'babbler', '~> 1.0.0'
gem 'sketchily', '~> 1.5.0'

gem 'unconfirm', git: 'https://github.com/lml/unconfirm.git', ref: '7cc1ed8b46'

gem 'on_the_spot', git: 'https://github.com/kevinburleigh75/on_the_spot.git', ref: '67a423a'

gem 'fine_print', git: 'https://github.com/jpslav/fine_print.git', ref: '3146ce934e337'
gem 'openstax_utilities', '~> 1.1.0'

gem 'action_interceptor', '~> 0.2.4'

gem 'lev', '~> 2.1.0'

group :development, :test do
  gem 'debugger', '~> 1.1.4'
  gem 'faker', '~> 1.0.1'
  gem 'timecop', '~> 0.3.5'
  gem 'thin', '~> 1.4.1'
  gem 'quiet_assets', '~> 1.0.1'
  gem 'cheat'
  gem 'brakeman'
  gem 'rvm-capistrano'
  # gem 'localtunnel'
end

group :development, :test do
  gem 'factory_girl_rails', '~> 4.0'
  gem 'rspec-rails'
  gem 'rspec-rerun'
  gem 'cucumber-rails', :require => false
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'spork-rails'
end

group :development, :test do
  gem 'rails-erd', '~> 1.1.0'
end

group :production do
  gem 'mysql2', '~> 0.3.11'
  gem 'rack-ssl-enforcer', '~> 0.2.4'
  gem 'lograge', git: 'https://github.com/jpslav/lograge.git' # 'git@github.com:jpslav/lograge.git'
end
