source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

ruby '2.1.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# User Flat UI components
gem 'flatui-rails'

# Use Font Awesome icon fonts
gem "font-awesome-rails"

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Authentication
gem 'devise'

# ElasticSearch
gem 'tire'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'active_model_serializers'

gem 'backbone-on-rails'

# Officially-supported gem for Backbone Marionette
gem 'marionette-rails'

group :doc do
  gem 'yard', require: false
end

group :production do
  gem 'unicorn'
  gem 'pg'
end

group :development do
  gem 'capistrano'
end

group :development, :test do
  gem 'sqlite3'
  gem 'debugger'

  gem "guard-rspec", '~> 2.2.1', :require => nil
  gem "guard-spork", '~> 1.4.2', :require => nil

  # Pry REPL and friends
  gem 'pry-rails'
  gem 'pry-debugger'

  gem "rspec-rails"
end

group :test do

  # Test frameworks and helpers
  gem "shoulda-matchers", "~> 2.1", "!= 2.2.0"
  gem "capybara", "~> 2.0.0"

  # Fixtures replacement
  gem "factory_girl_rails", "~> 4.0.0" # FactoryGirl v4.0

  # Test time-dependent code (“time travel” and “time freezing” capabilities)
  gem 'timecop', "~> 0.5.2"

  # Strategies for cleaning databases (multiple ORM/ODMs)
  gem "database_cleaner", "~> 0.8.0"

  # A DRb server for testing frameworks
  gem "spork", "0.9.2"

  # Test coverage stats
  gem 'simplecov'
end
