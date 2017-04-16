class ImageUploader < Shrine
  # plugins and uploading logic
  include ImageUploader[:image]
end
