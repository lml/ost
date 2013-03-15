# encoding: utf-8

class FreeResponseUploader < UploaderBase
  
  process :resize_to_fit => [1000, 1000], :if => :image?
  process :auto_orient

  # https://github.com/jnicklas/carrierwave/wiki/How-to%3A-Do-conditional-processing  
  version :thumbnail, :if => :image? do
    process :resize_to_fit => [100, 100]
  end

  def filename
    model.filename_override || super
  end

  def auto_orient
    return if !image?(self.file)
    manipulate! do |img|
      img.auto_orient
      # minimagick operates in place, and manipulate assumes return val is image
      # so must return it here
      img 
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png pdf)
  end

  WHITE_LISTED_CONTENT_TYPES = [
    'image/jpg',
    'image/jpeg',
    'image/gif',
    'image/png',
    'application/pdf'
  ]

end
