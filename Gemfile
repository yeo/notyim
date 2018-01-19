source 'https://rubygems.org'

ruby File.read('.ruby-version').split('@').first.strip

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
# gem 'uglifier', '>= 1.3.0' fuck this, this is 2017

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
gem "bulma-rails", "~> 0.6.2"
gem 'webpacker', '~> 3.0'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'mongoid', '~> 6.0.0'
gem 'devise'
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'rails_admin', :git => 'https://github.com/sferik/rails_admin'
gem 'sidekiq'
gem 'bugsnag'
gem 'twilio-ruby', '~> 4.11.1'
gem 'stripe'
gem 'slack-notifier'
gem 'hipchat'
gem 'kaminari', '~> 1.0'
gem 'kaminari-mongoid'
gem 'whenever', :require => false
gem 'influxdb'
gem 'redis-rails'
gem 'redis', '~>3.2'
gem 'connection_pool'
gem 'request_store'

gem 'newrelic_rpm'
gem 'mailgun-ruby', '~>1.1.6'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'pry-rails'
  gem 'pry'
  gem 'awesome_print'
  gem 'rubocop'
  gem 'rspec-rails'
  gem 'dotenv-rails'

  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'factory_girl_rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner'
  gem 'rails-controller-testing'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
