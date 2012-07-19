# encoding: utf-8

class MemberFilesUploader < CarrierWave::Uploader::Base

  include MyTools

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    if original_filename
      ext = File.extname(original_filename)
      hash_data = "#{model.class.to_s.underscore}/#{mounted_as}/#{model.company}/#{model.created_at}"
      filename = "#{hash_hash(hash_data)}#{ext}"
      Rails.logger.debug "******** hash_data: #{hash_data}"
      Rails.logger.debug "******** hash: #{hash_hash(hash_data)}"
      Rails.logger.debug "******** ext: #{ext}"
      Rails.logger.debug "******** filename: #{filename}"
      filename = "#{hash_hash(hash_data)}#{ext}"
    end
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    ## original
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"

    "#{Rails.root}/public/assets/uploads"
    #{model.class.to_s.underscore}/#{mounted_as}/#{model.company}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

end
