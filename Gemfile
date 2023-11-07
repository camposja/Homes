ruby '3.0.4'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.4.0'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'


# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'


# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Authentication with oauth
gem 'omniauth'
gem 'omniauth-github'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'better_errors'
  gem 'byebug', platform: :mri
  gem 'pry'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'bootstrap-generators'
gem 'bootstrap-social-rails'
gem 'font-awesome-rails'
gem 'jquery-ui-rails'

# Image uploading
gem 'shrine'
gem 'shrine-sql'
gem 'roda'
gem "image_processing"
gem "mini_magick", ">= 4.3.5"

# Pagination
gem 'kaminari'

group :development do
  gem 'awesome_print'
  gem 'brakeman'
  gem 'dotenv-rails'
end

# gem 'refile'
# gem 'refile-postgres'
group :production do
  gem 'rails_12factor'
end

# gem 'gmaps4rails'
# gem 'underscore-rails'
