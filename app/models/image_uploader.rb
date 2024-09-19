require "image_processing/mini_magick"

class ImageUploader < Shrine
  # plugins and uploading logic
  include ImageUploader[:image]

  include ImageProcessing::MiniMagick
    plugin :processing
    plugin :versions   # enable Shrine to handle a hash of files
    plugin :delete_raw # delete processed files after uploading

    process(:store) do |io, context|
      original = io.download

      # size_800 orient rotated images
      size_800 = ImageProcessing::MiniMagick.source(original).resize_and_pad(800, 600) { |cmd| cmd.auto_orient }
      size_500 = ImageProcessing::MiniMagick.source(size_800).resize_and_pad(500, 375)
      size_300 = ImageProcessing::MiniMagick.source(size_500).resize_and_pad(300, 225)
      size_64  = ImageProcessing::MiniMagick.source(size_300).resize_and_pad(64, 48)

      {
        original: io,
        large: size_800,
        medium: size_500,
        small: size_300,
        thumbnail: size_64
      }
    end
end
