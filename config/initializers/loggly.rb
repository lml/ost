
if Rails.env.production? || true
  require 'logglier'
  Rails.logger = Logglier.new("https://logs.loggly.com/inputs/#{SECRET_SETTINGS[:loggly_input_key]}")
end