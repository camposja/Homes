require "shrine"
require "shrine/storage/sql"
require "image_processing/mini_magick"
require "sequel"

DB = Sequel.connect(Rails.application.config.database_configuration[Rails.env])

Shrine.storages = {
  cache: Shrine::Storage::Sql.new(database: DB, table: :files),
  store: Shrine::Storage::Sql.new(database: DB, table: :files)
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :derivatives, create_on_promote: true
Shrine.plugin :determine_mime_type
Shrine.plugin :store_dimensions
Shrine.plugin :validation_helpers
Shrine.plugin :rack_response
Shrine.plugin :download_endpoint, prefix: "attachments"

# Make .url on any uploaded file use the download endpoint token URL,
# since SQL storage has no public URLs of its own.
Shrine::UploadedFile.class_eval do
  alias_method :url, :download_url
end