require "shrine"
require "shrine/storage/file_system"
require "image_processing/mini_magick"

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads")
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :derivatives, create_on_promote: true
Shrine.plugin :determine_mime_type
Shrine.plugin :store_dimensions
Shrine.plugin :validation_helpers