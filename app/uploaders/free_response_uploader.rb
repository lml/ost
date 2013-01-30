# encoding: utf-8

class FreeResponseUploader < UploaderBase
  
  process :resize_to_fit => [1000, 1000]

  # https://github.com/jnicklas/carrierwave/wiki/How-to%3A-Do-conditional-processing  
  version :thumbnail, :if => :image? do
    process :resize_to_fit => [100, 100]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png pdf)
  end

end
