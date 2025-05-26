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
Shrine.plugin :derivatives
Shrine.plugin :determine_mime_type
Shrine.plugin :store_dimensions
Shrine.plugin :validation_helpers
Shrine.plugin :rack_response
Shrine.plugin :download_endpoint, prefix: "attachments"

# Configure Shrine to use UUIDs for SQL storage
Shrine::Storage::Sql.class_eval do
  def generate_id(io, record)
    require "securerandom"
    SecureRandom.hex
  end

  def url(id, **options)
    return nil if id.nil?
    Rails.logger.debug "SQL Storage generating URL for ID: #{id}"
    "/attachments/#{id}"
  end

  def open(id, **options)
    Rails.logger.debug "Opening file with ID: #{id}"
    super
  end
end

# Add route to serve files
Rails.application.routes.draw do
  # Your other routes...
  mount Shrine.download_endpoint => "/attachments"
end