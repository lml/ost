secret_settings_filename = File.join(File.dirname(__FILE__), '..', 'secret_settings.yml')

SECRET_SETTINGS = File.file?(secret_settings_filename) ?
                  YAML::load_file(secret_settings_filename) : {}

SECRET_SETTINGS.symbolize_keys!
