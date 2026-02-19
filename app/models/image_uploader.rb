require "image_processing/mini_magick"

class ImageUploader < Shrine
  plugin :store_dimensions
  plugin :validation_helpers
  plugin :determine_mime_type
  plugin :derivatives
  plugin :pretty_location

  Attacher.validate do
    validate_mime_type %w[image/jpeg image/png image/gif]
    validate_max_size 5*1024*1024 # 5MB
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      large:     magick.resize_to_limit!(800, 600),
      medium:    magick.resize_to_limit!(500, 375),
      small:     magick.resize_to_limit!(300, 225),
      thumbnail: magick.resize_to_limit!(64, 48)
    }
  end

  def generate_location(io, derivative: nil, **)
    derivative = derivative.to_s if derivative
    [ derivative, super ].compact.join("-")
  end
end
