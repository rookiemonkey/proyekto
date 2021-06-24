class CloudinaryWrapper
  CLOUDINARY_FOLDER = ENV['CLOUDINARY_FOLDER_NAME']

  def self.upload(path, file_name)
    uploaded_file = Cloudinary::Uploader.upload(
      File.open(path), 
      public_id: file_name,
      use_filename: true,
      folder: CLOUDINARY_FOLDER, 
      overwrite: true, 
      resource_type: "image"
    )

    { image_url: uploaded_file['secure_url'], image_name: file_name }
  end

  def self.delete(file_name)
    return nil unless file_name
    
    is_destroyed = Cloudinary::Uploader.destroy("#{CLOUDINARY_FOLDER}/#{file_name}")

    is_destroyed['result'] == 'not found' ? nil : true
  end

end