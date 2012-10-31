Recaptcha.configure do |config|
  config.public_key  = SECRET_SETTINGS[:recaptcha_public_key]
  config.private_key = SECRET_SETTINGS[:recaptcha_private_key]
end
