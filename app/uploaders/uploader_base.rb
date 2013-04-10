# encoding: utf-8

require 'carrierwave/processing/mime_types'

# Most OST uploaders should use this special uploader base class instead of 
# inheriting from CarrierWave::Uploader::Base, especially if they want to use
# Fog storage.  This class helps us not repeat ourselves and also helps us
# not shoot ourselves in the foot.

class UploaderBase < CarrierWave::Uploader::Base

  include CarrierWave::MimeTypes
  process :set_content_type

  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  storage Ost::Application.config.carrierwave_storage

  def store_dir
    # If we happen to be testing fog in anything but the production environment, 
    # use a prefix on the storage directory to make sure all uploads go in a different 
    # folder so we don't mess with real files
    prefix = (Ost::Application.config.carrierwave_storage == :fog && !Rails.env.production?) ? 'test/' : ''
    "#{prefix}uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  def image?(new_file)
    # sometimes this method needs a file passed in others it doesn't
    # sometimes new_file has its content_type set, sometimes it is 
    # available in 'file'; it is a mystery.
    (new_file.content_type || file.content_type).include? 'image'
  end

end
