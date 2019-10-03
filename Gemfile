# frozen_string_literal: true

source 'https://rubygems.org'

ruby File.read('.ruby-version').split('@').first.strip

git_source(:github) do |repo_name|
  repo_name = '#{repo_name}/#{repo_name}' unless repo_name.include?('/')
  'https://github.com/#{repo_name}.git'
end

gem 'puma'
gem 'rails', '~> 5.2.2'

# TODO: Get rid of this since we use webpakckk
# Use SCSS for stylesheets
gem 'sassc-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'bulma-rails', '~> 0.6.2'
gem 'jbuilder', '~> 2.5'
gem 'webpacker', '~> 4.0'
# gem 'webpacker', git: 'git@github.com:rails/webpacker', branch: '3-x-stable'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'bugsnag'
gem 'connection_pool'
gem 'devise'
gem 'hipchat'
gem 'influxdb'
gem 'kaminari', '~> 1.0'
gem 'kaminari-mongoid'
gem 'mongoid', '~> 7.0.0'
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'redis', '~>3.2'
gem 'redis-rails'
gem 'request_store'
gem 'sidekiq'
gem 'slack-notifier'
gem 'stripe'
gem 'twilio-ruby', '~> 5.27.1'
gem 'whenever', require: false

gem 'bootsnap', require: false
gem 'newrelic_rpm'
gem 'rails_admin', '>= 1.4.1'

group :development, :test do
  gem 'awesome_print'
  gem 'byebug', platform: :mri

  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'factory_bot_rails'

  gem 'pry'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.0.5'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'rspec_junit_formatter'
  gem 'timecop'
  gem 'webmock', require: false
  gem "coveralls", "~> 0.7.1", require: false
end
