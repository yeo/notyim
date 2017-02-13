source 'https://rubygems.org'

ruby File.read('.ruby-version').split('@').first.strip

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
# gem 'uglifier', '>= 1.3.0' fuck this, this is 2017

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
gem 'bulma-rails', "~> 0.2.3"
gem 'react-rails'
gem 'browserify-rails'

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
gem 'rails_admin'
gem 'sidekiq'
gem 'bugsnag'
gem 'twilio-ruby', '~> 4.11.1'
gem 'mongoid_paranoia'
gem 'stripe'
gem 'kaminari-mongoid'
gem 'slack-notifier'
gem 'whenever', :require => false
gem 'redis-rails'
gem 'influxdb'

# We have to temp disabel newrelic cuz it doesn't support our Rails version yet
# We are too bleeding edge
#gem 'newrelic_rpm'

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
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
