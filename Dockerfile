# syntax=docker/dockerfile:1

# --- Build stage ---
FROM ruby:3.3.10-slim AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential libsqlite3-dev git pkg-config && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /rails

COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment true && \
    bundle config set --local without "development test" && \
    bundle install && \
    rm -rf ~/.bundle/cache vendor/bundle/ruby/*/cache

COPY . .

RUN SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile

# --- Runtime stage ---
FROM ruby:3.3.10-slim

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    libsqlite3-0 imagemagick curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /rails

COPY --from=build /rails /rails
COPY --from=build /usr/local/bundle /usr/local/bundle

# Create the persistent data directory (volume mount point)
RUN mkdir -p /data

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /rails /data

USER 1000:1000

ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=1 \
    RAILS_SERVE_STATIC_FILES=1 \
    DATABASE_PATH=/data/production.sqlite3

EXPOSE 3000

ENTRYPOINT ["./bin/docker-entrypoint"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
