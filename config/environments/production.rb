Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Fly.io: Puma serves static files directly (no separate Nginx)
  config.public_file_server.enabled = true

  config.assets.compile = false

  config.force_ssl = true
  config.assume_ssl = true

  config.log_level = :info
  config.log_tags = [ :request_id ]

  # Always log to stdout on Fly.io
  config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)

  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: 'TinyEstates.com' }

  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify

  config.active_record.dump_schema_after_migration = false
end
