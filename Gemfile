source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.2'

gem 'bootstrap-sass', '~> 3.1.1'

# Use Font Awesome icon fonts
gem "font-awesome-rails"

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Authentication
gem 'devise'

# PostgreSQL
gem 'pg'

# ElasticSearch
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

# Comments
gem 'acts_as_commentable'

# Attachments
gem 'carrierwave', '0.10.0'

gem 'mini_magick'

# Pagination
gem 'kaminari'

# Acts as tree
gem 'acts_as_tree', '~> 1.6.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

gem 'active_model_serializers'

gem 'bootstrap-x-editable-rails'

group :doc do
  gem 'yard', require: false
end

group :production do
  gem 'unicorn'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano3-unicorn'
  gem 'capistrano-rvm'
  gem 'capistrano-bower'
end

group :development, :test do
  # Pry REPL and friends
  gem 'pry-rails'
  gem 'pry-byebug'

  gem "rspec-rails"
end

group :test do

  # Test frameworks and helpers
  gem "shoulda-matchers", "~> 2.6"
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
