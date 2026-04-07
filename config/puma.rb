threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

port ENV.fetch("PORT") { 3000 }

environment ENV.fetch("RAILS_ENV") { "development" }

# Bind to all interfaces in production (required for containers/Fly.io)
bind "tcp://0.0.0.0:#{ENV.fetch('PORT') { 3000 }}" if ENV["RAILS_ENV"] == "production"

# IMPORTANT: Do NOT use workers with SQLite.
# SQLite allows only one writer at a time. Multiple Puma worker processes
# would each hold their own database connection and cause SQLITE_BUSY errors.
# Threads within a single process share a connection pool and are safe.

plugin :tmp_restart
