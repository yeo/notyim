# frozen_string_literal: true

source 'https://rubygems.org'

ruby File.read('.ruby-version').split('@').first.strip

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'puma'
gem 'rails', '~> 6.0'

gem 'webpacker'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'sentry-raven'
gem 'connection_pool'
gem 'devise'
gem 'influxdb'
gem 'kaminari'
gem 'kaminari-mongoid'
gem 'mongoid', '~> 7.1.2'
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'redis', '~>4.1'
gem 'redis-rails'
gem 'request_store'
gem 'sidekiq'
gem 'slack-notifier'
gem 'stripe'
gem 'twilio-ruby', '~> 4.11.1'
gem 'whenever', require: false

gem 'bootsnap', require: false
gem 'newrelic_rpm'
gem 'rails_admin'

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
  gem 'coveralls', '~> 0.7.1', require: false
  gem 'database_cleaner'
  gem 'rspec_junit_formatter'
  gem 'timecop'
  gem 'webmock', require: false
end
