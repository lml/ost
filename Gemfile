source 'https://rubygems.org'

gem 'rails', '3.2.4'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'therubyracer', '~> 0.10.1'
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

gem 'fastercsv'
gem 'csv_builder'

gem 'yaml_db'

group :development, :test do
  gem 'sqlite3', '~> 1.3.6'
  gem 'debugger', '~> 1.1.4'
  gem 'faker', '~> 1.0.1'
  gem 'factory_girl_rails', '~> 3.4.0'
  gem 'timecop', '~> 0.3.5'
  gem 'thin', '~> 1.3.1'
  gem 'quiet_assets', '~> 1.0.1'
end

group :production do
	gem 'mysql2', '~> 0.3.11'
	gem 'rack-ssl-enforcer', '~> 0.2.4'
end