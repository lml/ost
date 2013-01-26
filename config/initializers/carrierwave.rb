CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => SECRET_SETTINGS[:aws_ses_access_key_id],
    :aws_secret_access_key  => SECRET_SETTINGS[:aws_ses_secret_access_key]
  }

  config.fog_directory  = 'openstaxtutor'
  config.fog_public     = false
end